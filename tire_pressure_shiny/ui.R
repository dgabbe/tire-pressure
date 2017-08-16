library(btpress)
library(shiny)
# library(shinythemes)

slider_width <- "250px"
dropdown_width <- "125px"

shinyUI(
  fluidPage( # theme = shinytheme("yeti"),
    tags$head(includeScript("google-analytics.js")),

    titlePanel(title = "", windowTitle = "Optimizing Your Tire Pressure to Your Weight"),

    sidebarLayout(
      sidebarPanel(
        width = 3,
        fluidRow(
          column(12, h4("Bicycle and Rider Information", align = "center"))),
        fluidRow(
          column(12, helpText("Use at your own risk."))),
        fluidRow(
          column(12,
          sliderInput("rider_weight", label = "Rider Weight:", min = 80, max = 250, value = c(150), width = slider_width))
          ),
        fluidRow(
          column(12,
                 sliderInput("bike_weight", label = "Bike Weight:", min = 10, max = 50, value = c(15), width = slider_width))
          ),
        fluidRow(
          column(12,
                 sliderInput("load_weight", label = "Load Weight:", min = 0, max = 75, value = c(13), width = slider_width))
          ),
        fluidRow(
          column(12,
          sliderInput("front_distribution", label = "Front Wheel Load (%):",
                      min = 35, max = 70, step = 5, value = c(40), width = slider_width))
          ),
        fluidRow(
          column(4,
                 selectInput("front_tire", label = "Front Tire Size (mm):",
                             choices = btpress::tire_sizes_mm, selected = 28,
                             width = dropdown_width, selectize = FALSE)),
          column(7,
                 checkboxInput("front_casing_extralight", "Extra Light Casing", FALSE))
          ),
        fluidRow(
          column(4,
                 selectInput("rear_tire", label = 'Rear Tire Size (mm):',
                             choices = btpress::tire_sizes_mm, selected = 28,
                             width = dropdown_width, selectize = FALSE)),
          column(7,
                 checkboxInput("rear_casing_extralight", "Extra Light Casing", FALSE)))
      ),
      mainPanel(width = 9, plotOutput("inflation_plot"))
    )
  )
)
