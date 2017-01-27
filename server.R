library(dygraphs)
library(dplyr)
library(googleVis)
library(reshape2)

# load the data, reduce to just the data we really intend to use
# hopefully this should help with memory usage
tornadoes.since.1996 <- readRDS("tornadoes_since_1996.rds")
#tornadoes$date <- as.Date(tornadoes$date, format="%m/%d/%Y")

function(input, output, session) {
  
  output$map <- renderLeaflet({
    t <- tornadoes.since.1996 %>% filter(yr >= input$map.year[1], yr <= input$map.year[2]) %>% filter(mag %in% input$map.severity)
    leaflet() %>% addTiles() %>% addCircleMarkers(lng = t$slon, lat = t$slat, clusterOptions = markerClusterOptions())
  })
  
  output$loss.chart <- renderGvis({
    loss.by.state <- tornadoes.since.1996
    loss.by.state <- loss.by.state %>% filter(!is.na(loss))
    if (input$group.by == "Year") {
      loss.by.state <- loss.by.state %>% group_by(yr, st) %>% summarise(loss = sum(loss))
    }
    if (!input$include.zero.values) {
      loss.by.state <- loss.by.state %>% filter(loss > 0)
    }
    loss.by.state <- loss.by.state %>% group_by(st) %>% summarise(loss = mean(loss)) %>% arrange(loss)
    loss.by.state <- loss.by.state %>% filter(loss >= quantile(loss, input$percentile[1]  / 100.0)) %>% 
      filter(loss <= quantile(loss, input$percentile[2] / 100.0))
    
    gvisColumnChart(loss.by.state, 
                    options = list(title = paste("Average Financial Loss per",input$group.by,"per State"),
                                   legend = "none",
                                   hAxis = "{title:'State'}",
                                   vAxis = "{title:'Loss in $Millions'}",
                                   height=300))
  })
  
  
  output$casualty.chart <- renderGvis({
    casualties.by.state <- tornadoes.since.1996
    casualties.by.state <- casualties.by.state %>% filter(!is.na(inj) & !is.na(fat))
    casualties.by.state <- casualties.by.state %>% mutate(casualties = inj + fat)
    if (input$group.by == "Year") {
      casualties.by.state <- casualties.by.state %>% group_by(yr, st) %>% summarise(casualties = sum(casualties))
    }
    if (!input$include.zero.values) {
      casualties.by.state <- casualties.by.state %>% filter(casualties > 0)
    }
    casualties.by.state <- casualties.by.state %>% group_by(st) %>% summarise(casualties = mean(casualties)) %>% arrange(casualties)
    casualties.by.state <- casualties.by.state %>% filter(casualties >= quantile(casualties, input$percentile[1] / 100.0)) %>% 
      filter(casualties <= quantile(casualties, input$percentile[2] / 100.0))
    
    
    gvisColumnChart(casualties.by.state,
                    options = list(title = paste("Average Casualties (Injuries + Fatalities) per",input$group.by,"per State"),
                                   legend = "none",
                                   hAxis = "{title:'State'}",
                                   vAxis = "{title:'Number of Casualties'}",
                                   height=300))
  })
  
  ####### Info Boxes ######
  
  output$average.storms.per.year <- renderInfoBox({
    
    storms.per.year <- tornadoes.since.1996 %>% filter(st == input$state) %>% group_by(yr) %>% summarise(count = n())
    
    infoBox("Average Storms Per Year", round(mean(storms.per.year$count)), icon = icon("bolt"), color = "black", fill = TRUE)
  })
  
  output$casualties.per.storm <- renderInfoBox({
    
    casualties.per.storm <- tornadoes.since.1996 %>% filter(st == input$state) %>% filter(!is.na(inj) & !is.na(fat))
    casualties.per.storm <- casualties.per.storm %>% mutate(casualties = inj + fat)
    if (!input$state.include.zero.values) {
      casualties.per.storm <- casualties.per.storm %>% filter(casualties > 0)
    }
    
    infoBox("Average Casualties Per Storm", round(mean(casualties.per.storm$casualties)), icon = icon("frown-o"), color = "red", fill = TRUE)
  })
  
  output$loss.per.storm <- renderInfoBox({
    
    loss.per.storm <- tornadoes.since.1996 %>% filter(st == input$state) %>% filter(!is.na(loss))
    if (!input$state.include.zero.values) {
      loss.per.storm <- loss.per.storm %>% filter(loss > 0)
    }
    
    infoBox("Average Loss Per Storm", paste(format(mean(loss.per.storm$loss), digits = 2, nsmall = 2), "Million"), icon = icon("usd"), color = "green", fill = TRUE)
  })
  
}