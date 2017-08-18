library(btpress)
library(shiny)
library(shinyBS)
# library(shinythemes)

# input_well_style <- function() {return(paste('"background-color: #ffffff; padding-bottom: 5px; padding-top: 5px; border: 1px solid blue"'))
# }

rider_well <- function() {
  wellPanel(
    style = "background-color: #ffffff; padding-bottom: 5px; padding-top: 7px; box-shadow: 5px 5px 5px grey;",
    fluidRow(
      style = "margin-bottom: 0px; padding-bottom: 0px;",
      column(
        12,
        style = "margin-bottom: 0px; border: 0px;",
        sliderInput(
          "rider_weight",
          label = "Rider Weight:",
          min = min_rider_lbs,
          max = max_rider_lbs,
          value = c(bike_ui$rider_lbs),
          width = slider_width
        ),
        bsTooltip(
          id = "rider_weight", title = tt_rider_weight, placement = "right"
        )
      )
    )
  )
}

bike_well <- function() {
  wellPanel(
    style = "background-color: #ffffff; padding-bottom: 5px; padding-top: 5px; box-shadow: 5px 5px 5px grey;",
    fluidRow(
      style = "margin-bottom: 8px; margin-bottom: 5px;",
      column(
        12,
        sliderInput(
          "bike_weight",
          label = "Bike Weight:",
          min = min_bike_lbs,
          max = max_bike_lbs,
          value = c(bike_ui$bike_lbs),
          width = slider_width
        ),
        bsTooltip(
          id = "bike_weight", title = tt_bike_weight, placement = "right"
        )
      )
    ),
    fluidRow(
      style = "margin-bottom: 8px; margin-bottom: 5px;",
      column(
        12,
        sliderInput(
          "load_weight",
          label = "Load Weight:",
          min = min_load_lbs,
          max = max_load_lbs,
          value = c(bike_ui$load_lbs),
          width = slider_width
        ),
        bsTooltip(
          "load_weight", title = tt_load_weight, placement = "right"
        )
      )
    ),
    fluidRow(
      style = "margin-bottom: 8px; margin-bottom: 5px;",
      column(
        12,
        sliderInput(
          "front_distribution",
          label = "Load Distribution (Front %):",
          min = min_distribution,
          max = max_distribution,
          step = 5,
          value = c(bike_ui$distribution),
          width = slider_width
        ),
        bsTooltip(
          "front_distribution", title = tt_load_distribution, placement = "right"
        )
      )
    )
  )
}

tire_well <- function() {
  wellPanel(
    style = "background-color: #ffffff; padding-bottom: 5px; padding-top: 5px; box-shadow: 5px 5px 5px grey;",
    fluidRow(
      style = "margin-bottom: 3px;",
      column(
        12,
        h5(
          'Tire Sizes (mm)',
          align = "left",
          style="font-weight: bold; margin-top: 3px; margin-bottom: 3px;"
        )
      )
    ),
    fluidRow(
      style = "margin-bottom: 2px;",
      column(
        4,
        style = "padding-bottom: 0px;",
        selectInput(
          "front_tire",
          label = "Front:",
          choices = btpress::tire_sizes_mm,
          selected = bike_ui$front_tire,
          width = dropdown_width,
          selectize = FALSE
        )
      ),
      column(
        8,
        style = "padding-top: 17px;",
        checkboxInput(
          "front_extralight",
          "Extra Light Casing",
          bike_ui$front_extralight
        ),
        bsTooltip("front_extralight", title = tt_extralight, placement = "right")
      )
    ),
    fluidRow(
      style = "margin-bottom: 8px; margin-bottom: 5px;",
      column(
        4,
        selectInput(
          "rear_tire",
          label = 'Rear:',
          choices = btpress::tire_sizes_mm,
          selected = bike_ui$rear_tire,
          width = dropdown_width,
          selectize = FALSE
        )
      ),
      column(
        8,
        style = "padding-top: 17px;",
        checkboxInput(
          "rear_extralight",
          "Extra Light Casing",
          bike_ui$rear_extralight
        ),
        bsTooltip("rear_extralight", title = tt_extralight, placement = "right")
      )
    )
  )
}

shinyUI(
  fluidPage(
    # theme = shinytheme("yeti"),
    tags$head(includeScript("google-analytics.js")),
    titlePanel(title = "", windowTitle = "Optimizing Your Tire Pressure to Your Weight"),

    sidebarLayout(
      sidebarPanel(
        style = "background-color: #ededed; padding: 12px",
        width = 3,
        fluidRow(
          column(12, h4("Bicycle and Rider Information", align = "center"))
        ),
        fluidRow(
          column(12, helpText("Use at your own risk.", style = "color: black;"))
        ),
        rider_well(),
        bike_well(),
        fluidRow(
          column(
            12,
            tire_well()
          )
        )
      ),
      mainPanel(
        width = 9,
        plotOutput("inflation_plot")
      )
    )
  )
) # shinyUI
