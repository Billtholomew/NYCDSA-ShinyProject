# ui.R
library(leaflet)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = 'Tornado'),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map", tabName = "storm_map", icon = icon("map")),
      menuItem("Damage Overview", tabName = "damage_overview", icon = icon("bar-chart")),
      menuItem("State Data", tabName = "state_data", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "storm_map",
        fluidRow(
          box(leafletOutput('map')),
          box(
            title = "Controls",
            sliderInput("map.year", "Year Occured", 1996, 2015, value = c(1996, 2015)),
            checkboxGroupInput("map.severity", "Severity", 
                               c("F0" = 0, "F1" = 1, "F2" = 2, "F3" = 3, "F4" = 4, "F5" = 5), 
                               selected = c(3, 4, 5))
          )
        )
      ),
      tabItem(tabName = "damage_overview",
        fluidRow(
          box(htmlOutput('loss.chart')),
          box(htmlOutput('casualty.chart'))
        ),
        fluidRow(
          box(
            title = "Controls",
            sliderInput("percentile", "Percentile", 0, 100, value = c(80, 100)),
            radioButtons("group.by", "Grouping Method", c("By Year" = "Year", "By Storm" = "Storm"), selected = "Year"),
            checkboxInput("include.zero.values", "Include Zero Values", value = FALSE)
          )
        )
      ),
      tabItem(tabName = "state_data",
        fluidRow(
          box(selectInput("state", "Select State:",
                          choices = state.abb[state.abb!="AK" & state.abb!="HI"], multiple=FALSE, selectize=TRUE
                          )
          ),
          box(checkboxInput("state.include.zero.values", "Include Zero Values", value = FALSE))
        ),
        fluidRow(
          infoBoxOutput("average.storms.per.year"),
          infoBoxOutput("casualties.per.storm"),
          infoBoxOutput("loss.per.storm")
        )
      )
    )
  )
)