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

# tt_rider_weight <- bsTooltip("tt-rider_weight", "Your weight, dressed for riding, in pounds", "right", options = list(container = "body"))
