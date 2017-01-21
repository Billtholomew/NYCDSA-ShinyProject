# ui.R

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

fluidPage(
  titlePanel("Tornado Locations by Year and Severity"),
  fluidRow(
    column(3,
           wellPanel(
             sliderInput("year", "Year Occured", 1940, 2014, value = c(1970, 2014)),
             checkboxGroupInput("fujita", "Severity*", sort(unique(tornadoes$fujita.estimate)), selected = unique(tornadoes$fujita.estimate)),
             tags$small("*Fujita Scale values for severity are estimated based on property damage and distance traveled")
           )
    ),
    column(9)
  )
)