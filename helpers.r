calc_fujita <- function(damage, distance) {
  f_rating = 0;
  if (damage < 5e1) {
    # $50
    f_rating = 0;
  } else if (damage < 5e3) { 
    # $5k
    f_rating = 1;
  } else if (damage < 5e5) { 
    # $500k
    f_rating = 2;
  } else if (damage < 5e7) { 
    # $50M
    f_rating = 3;
  } else if (damage < 5e9) {
    # $5B
    f_rating = 4;
  } else {
    # impossibly huge damage
    f_rating = 5;
  }
  
  if (distance <= 5) {
    f_rating = f_rating - 1;
  } else {
    f_rating = f_rating + 1;
  }
  
  return(max(f_rating, 0));
}

lower48 = state.abb
lower48 = state.abb[state.abb!="AK" & state.abb!="HI"]
tornadoes2 = tornadoes[tornadoes$st %in% lower48, ]
map("state", fill = FALSE, projection = "polyconic")
points(mapproject(list(x=tornadoes$slon, y=tornadoes$slat)), cex=0.1)
