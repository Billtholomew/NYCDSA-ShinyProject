lower48 = state.abb
lower48 = state.abb[state.abb!="AK" & state.abb!="HI"]
tornadoes = read.csv("Tornadoes_SPC_1950to2015.csv")
tornadoes = tornadoes[tornadoes$st %in% lower48, ]

calc_fujita <- function(year, loss, distance) {
  
  f_rating = ifelse(year >= 1996, floor(log10(pmax(loss * 1e6 %/% 5 == 0, 1))), loss) %/% 2
  
  # If length is above 5 miles, add 1 to F-Rating
  # If length is below 5 miles, subtract 1 from F-Rating
  f_rating = f_rating + ifelse(distance > 5, 1, -1)
  
  # Fujita rating cannot be negative
  return(paste0("F",pmax(f_rating, 0)))
}

tornadoes <- tornadoes %>% mutate(fujita.estimate = calc_fujita(yr, loss, len))
unique(tornadoes$fujita.estimate)
write.csv(tornadoes, "tornadoes.csv")