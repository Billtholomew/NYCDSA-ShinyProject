# ui.R

pageWithSidebar(
  headerPanel("Tornado Locations by Year and Severity"),
  sidebarPanel(
    sliderInput("year", "Year Occured", 1950, 2015, value = c(1970, 2014)),
    checkboxGroupInput("severity", "Severity*", sort(unique(tornadoes$fujita.estimate)), selected = unique(tornadoes$fujita.estimate)),
    tags$small("*Fujita Scale values for severity are estimated based on property damage and distance traveled")
  ),
  mainPanel(
    plotOutput('plot1')
  )
)