library(shiny)
library(btpress)

tire_casing_indicator <- function(checkbox) {
  return(
    if (checkbox == TRUE) {1.15}
    else {1}
  )
}

# Define server logic required to draw a histogram
shinyServer(
  function(input, output) {

  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  output$inflation_plot <- renderPlot({
    bike <- bike_tire_pressures(
      rider_weight_lbs = input$rider_weight,
      bike_weight_lbs = input$bike_weight,
      load_lbs = input$load_weight,
      front_distribution = (input$front_distribution / 100),
      front_tire_size_mm = as.numeric(input$front_tire),
      front_tire_casing_compensation = tire_casing_indicator(input$front_casing_extralight),
      rear_tire_size_mm = as.numeric(input$rear_tire),
      rear_tire_casing_compensation = tire_casing_indicator(input$rear_casing_extralight)
    )
    plot_bike_inflation(bike = bike)
  },
  height = 800)
  }
)
