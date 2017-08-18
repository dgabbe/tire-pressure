# Setup app values
app_title <- "Bicycle Tire Pressure Optimizer"

# Setup control values
slider_width <- "280px"
dropdown_width <- "50px"

# Setup GUI values
min_rider_lbs <- 80
max_rider_lbs <- 250
min_bike_lbs <- 12
max_bike_lbs <- 50
min_load_lbs <- 0
max_load_lbs <- 72
min_distribution <- 35
max_distribution <- 65
extralight_compensation <- 1.15

# Setup default control values
bike_ui <- list(
  rider_lbs = 150,
  bike_lbs = 18,
  load_lbs = 5,
  front_tire = 28,
  front_extralight = FALSE,
  rear_tire = 28,
  rear_extralight = FALSE,
  distribution = 40
)

# Setup Tool Tips
tt_style <- function(tip) {
  paste0(
    '<div style="text-align:left; width: 200px;">',
    tip,
    '</div>'
  )
}

tt_rider_weight <- tt_style("Weight of rider, as dressed for ride including shoes.")

tt_bike_weight <- tt_style("Weight of bicycle with permanently attached accessories.")

tt_load_weight <- tt_style("Weight of items like pump, lock, water bottles, and backpack, bag, pannier and their contents.")

tt_load_distribution <- tt_style(
  paste0(
    "Weight distribution between front & rear wheels.<br>",
    '<ul style="padding-left:20px">',
    "<li><b>Commuter, rear load:</b> 35%</li>",
    "<li><b>Touring, rear load:</b> 35%</li>",
    "<li><b>Racer, no load:</b> 40%</li>",
      "<li><b>Randonneur, front load:</b> 45%</li>",
      "<li><b>Time Trial:</b> 65%</li>",
    "</ul>"
  )
)

tt_extralight <- tt_style(
  "Check if tire casing is very flexible.<br>Leave unchecked if unknown or unsure."
)
