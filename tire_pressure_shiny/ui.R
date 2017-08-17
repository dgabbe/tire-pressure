library(btpress)
library(shiny)
# library(shinythemes)

slider_width <- "280px"
dropdown_width <- "50px"

tire_well <- function() {
  wellPanel(
    fluidRow(
      column(12, h5('Tire Sizes (mm)', align = "left", style="font-weight: bold;"))
    ),
    fluidRow(
      column(
        4,
        selectInput("front_tire", label = "Front:",
                    choices = btpress::tire_sizes_mm, selected = 28,
                    width = dropdown_width, selectize = FALSE)
      ),
      column(
        8,
        checkboxInput("front_casing_extralight", "Extra Light Casing", FALSE))
    ),
    fluidRow(
      column(
        4,
        selectInput("rear_tire", label = 'Rear:',
                    choices = btpress::tire_sizes_mm, selected = 28,
                    width = dropdown_width, selectize = FALSE)),
      column(
        8,
        checkboxInput("rear_casing_extralight", "Extra Light Casing", FALSE)
      )
    )
  )
}

bike_well <- function() {
  wellPanel(
    fluidRow(
      column(
        12,
        sliderInput("bike_weight", label = "Bike Weight:", min = 10, max = 50, value = c(15), width = slider_width)
      )
    ),
    fluidRow(
      column(
        12,
        sliderInput("load_weight", label = "Load Weight:", min = 0, max = 72, value = c(13), width = slider_width)
      )
    ),
    fluidRow(
      column(
        12,
        sliderInput("front_distribution", label = "Front Wheel Load (%):",
                    min = 35, max = 70, step = 5, value = c(40), width = slider_width)
      )
    )
  )
}

rider_well <- function() {
  wellPanel(
    fluidRow(
      column(
        12,
        sliderInput("rider_weight", label = "Rider Weight:", min = 80, max = 250, value = c(150), width = slider_width)
      )
    )
  )
}

shinyUI(
  fluidPage( # theme = shinytheme("yeti"),
    tags$head(includeScript("google-analytics.js")),

    titlePanel(title = "", windowTitle = "Optimizing Your Tire Pressure to Your Weight"),

    sidebarLayout(
      sidebarPanel(
        width = 3,
        fluidRow(
          column(12, h4("Bicycle and Rider Information", align = "center"))
        ),
        fluidRow(
          column(12, helpText("Use at your own risk."))
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
      mainPanel(width = 9, plotOutput("inflation_plot"))
    )
  )
) # shinyUI
