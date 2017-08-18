library(shiny)
library(btpress)

tire_casing_indicator <- function(checkbox) {
  return(
    if (isTRUE(checkbox)) {extralight_compensation}
    else {1}
  )
}

shinyServer(
  function(input, output) {
    output$inflation_plot <- renderPlot({
      bike <- bike_tire_pressures(
        rider_weight_lbs = input$rider_weight,
        bike_weight_lbs = input$bike_weight,
        load_lbs = input$load_weight,
        front_distribution = (input$front_distribution / 100),
        front_tire_size_mm = as.numeric(input$front_tire),
        front_tire_casing_compensation = tire_casing_indicator(input$front_extralight),
        rear_tire_size_mm = as.numeric(input$rear_tire),
        rear_tire_casing_compensation = tire_casing_indicator(input$rear_extralight)
      )
      plot_bike_inflation(bike = bike, show_summary = TRUE)
    },
    height = 800)
  }
)
