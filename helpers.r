

lower48 = state.abb
lower48 = state.abb[state.abb!="AK" & state.abb!="HI"]
tornadoes = tornadoes[tornadoes$st %in% lower48, ]
map("state", fill = FALSE, projection = "polyconic")
tornadoes5 = tornadoes[tornadoes$fujita.estimate==5, ]
points(mapproject(list(x=tornadoes5$slon, y=tornadoes5$slat)), cex=0.1)
