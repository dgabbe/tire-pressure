# The formula is imperial centric and can be found here:
# http://www.biketinker.com/2010/bike-resources/optimal-tire-pressure-for-bicycles/
# The original article is http://www.bikequarterly.com/images/BQTireDrop.pdf.
#
# Weight_lbs is the load on the bicycle wheel and typcially 40 - 60 percent
# of the total weight of the rider, bike and carried items.
#
tirePressure_psi <- function(weight_lbs, tireSize_mm) {
  return(153.6 * weight_lbs / tireSize_mm**1.5785 - 7.1685)
}

inflation_data <- function(wheel_load_lbs, tire_size_mm) {
  ltp <- c(wheel_load_lbs, tire_size_mm, tirePressure_psi(wheel_load_lbs, tire_size_mm))
  return(ltp)
}

bike_tire_pressures <- function(rider_weight_lbs=100,
                                bike_weight_lbs=15,
                                load_lbs=2,
                                tire_casing_compensation=1,
                                front_tire_size_mm=28,
                                rear_tire_size_mm=28,
                                front_distribution=0.5){

}

inflation_chart <- matrix(ncol=3, byrow=TRUE,
                           dimnames=list(c(), c("wheel_load_lbs", "tire_size_mm", "tire_pressure_psi")))

# Based on the Bicycle Quarterly chart which was laid in kilograms
wheel_loads_lbs <- c(66, 77, 88, 100, 110, 121, 132, 143, 154)

# Nominal tire sizes
tire_sizes_mm <- c(23, 25, 28, 32, 35, 42, 48)

for(wll in wheel_loads_lbs){
  for(ts in tire_sizes_mm){
    inflation_chart <- rbind(inflation_chart, inflation_data(wll, ts))
  }
}

inflation_chart <- as.data.frame(inflation_chart)

inflation_graphic <- ggplot(inflation_chart, aes(x=wheel_load_lbs, y=tire_pressure_psi, group=tire_size_mm, color=tire_size_mm)) +
  geom_line()


# try melt in reshape package?
