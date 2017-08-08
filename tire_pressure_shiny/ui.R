library(shiny)
library(btpress)

slider_width <- "250px"

shinyUI(fluidPage(
  tags$head(includeScript("google-analytics.js")),

  titlePanel(title = "", windowTitle = "Optimizing Your Tire Pressure to Your Weight"),

  sidebarLayout(
    sidebarPanel(
      width = 3, type = c("tabs"), selected = "Advanced",
      tabsetPanel(
        tabPanel("Simple",
                 fluidRow(h4("Bicycle and Rider Information", align = "center")),
                 fluidRow(helpText("Bike riding is dangerous - don't blame me if any thing happens to you!")),
                 fluidRow(
                   sliderInput(
                     "rider_weight",
                     label = "Weight of Rider, Bike, and Stuff Carried:",
                     min = 80, max = 275, value = c(150), width = slider_width)),
                 # Where is your load carried
                 fluidRow(
                   column(5, selectInput(
                     "front_tire",
                     label = "Front Tire Size (mm):",
                     choices = btpress::tire_sizes_mm, selected = 28,
                     width = "150px", selectize = FALSE)
                   )
                 ),
                 fluidRow(
                   column(5, selectInput("rear_tire", label = "Rear Tire Size (mm):",
                                         choices = btpress::tire_sizes_mm, selected = 28,
                                         width = "150px", selectize = FALSE)))
        ),
        tabPanel(
          "Advanced",
          fluidRow(h4("Bicycle and Rider Information", align = "center")),
          fluidRow(helpText("Bike riding is dangerous - don't blame me if any thing happens to you!")),
          fluidRow(sliderInput("rider_weight", label = "Rider Weight:", min = 80, max = 250, value = c(150), width = slider_width)),
          fluidRow(sliderInput("bike_weight", label = "Bike Weight:", min = 10, max = 50, value = c(15), width = slider_width)),
          fluidRow(sliderInput("load_weight", label = "Load Weight:", min = 0, max = 75, value = c(13), width = slider_width)),
          fluidRow(sliderInput("front_distribution", label = "Front Wheel Load (%):",
                               min = 35, max = 70, step = 5, value = c(40), width = slider_width)),
          fluidRow(
            column(5, selectInput("front_tire", label = "Front Tire Size (mm):",
                                  choices = btpress::tire_sizes_mm, selected = 28,
                                  width = "150px", selectize = FALSE)),
            column(5, checkboxInput("front_casing_extralight", "Extra Light Casing", FALSE))),
          fluidRow(
            column(5, selectInput("rear_tire", label = "Rear Tire Size (mm):",
                                  choices = btpress::tire_sizes_mm, selected = 28,
                                  width = "150px", selectize = FALSE)),
            column(5, checkboxInput("rear_casing_extralight", "Extra Light Casing", FALSE)))
        )
      )
    ),
    mainPanel(width = 9, plotOutput("inflation_plot"))
  )
)
)
