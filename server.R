library(shiny)
library(mapproj)
library(dplyr)

tornadoes = read.csv("tornadoes.csv")
map("state", fill = FALSE, projection = "polyconic")

function(input, output, session) {
  
  # Filter the movies, returning a data frame
  movies <- reactive({
    # Due to dplyr issue #318, we need temp variables for input values
    minyear <- input$year[1]
    maxyear <- input$year[2]
    severity <- input$severity

    # Apply filters
    t <- tornadoes %>%
      filter(
        yr >= minyear,
        yr <= maxyear
      )
    
    severity <- paste0("%", input$severity, "%")
    t <- t %>% filter(fujita.estimate %like% severity)
    
    t <- as.data.frame(t)
    
  })
  
}