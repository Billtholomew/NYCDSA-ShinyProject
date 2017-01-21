library(mapproj)
library(dplyr)

tornadoes = read.csv("tornadoes.csv")

function(input, output, session) {
  
  # Filter the tornadoes, returning a data frame
  selectedData <- reactive({
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
    
    t <- tornadoes %>% filter(fujita.estimate %in% severity)
    
    t <- as.data.frame(t)
  })

  output$plot1 <- renderPlot({
    map("state", fill = FALSE, projection = "polyconic")
    t = selectedData()
    points(mapproject(list(x=t$slon, y=t$slat)), cex=0.33, col=alpha("blue", as.numeric(t$fujita.estimate) / 7 + (1/7)))
  })
  
  
}