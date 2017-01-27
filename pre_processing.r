lower48 = state.abb
lower48 = state.abb[state.abb!="AK" & state.abb!="HI"]
tornadoes = read.csv("Tornadoes_SPC_1950to2015.csv")
tornadoes = tornadoes[tornadoes$st %in% lower48, ]
write.csv(tornadoes, "tornadoes.csv")

# reduce set of sites to those within 1 degree of a storm
storm <- data.frame(lat = round(tornadoes$slat), lon = round(tornadoes$slon))

site <- data.frame(Station.ID = site_summary$`Station ID`, lat = round(site_summary$Latitude), lon = round(site_summary$Longitude))

site$near.storm = FALSE

for (site.idx in 1:dim(site)[1]) {
  site.lat <- site[site.idx, ]$lat
  site.lon <- site[site.idx, ]$lon
  storm.lats <- storm$lat
  storm.lons <- storm$lon
  d.lat <- site.lat - storm.lats
  d.lon <- site.lon - storm.lons
  dd = sqrt(d.lat ^ 2 + d.lon ^ 2)
  site[site.idx, ]$near.storm = any(dd < 1)
}

site <- site %>% filter(near.storm)
site <- site_summary %>% filter(site_summary$`Station ID` %in% site$Station.ID)
saveRDS(site, "stations_near_storms.rds")



# filter down us_data
stations.near.storms <- readRDS("stations_near_storms.rds")
us.data.near.storms <- us_data %>% filter(`Station ID` %in% stations.near.storms$`Station ID`)
us.data.near.storms <- us.data.near.storms %>% mutate(Date = format(date_decimal(Date), "%m/%d/%Y"))
us.data.near.storms <- us.data.near.storms %>% mutate(Date = as.Date(Date, format = "%m/%d/%Y"))
us.data.near.storms.since.1996 <- us.data.near.storms %>% filter(Date >= as.Date("01/01/1996", format = "%m/%d/%Y"))
us.data.near.storms.since.1996 <- us.data.near.storms.since.1996 %>% group_by(`Station ID`, Date) %>% summarise(mean.temperature = mean(`Temperature (C)`))
saveRDS(us.data.near.storms.since.1996, "us_data_near_storms_since_1996.rds")




