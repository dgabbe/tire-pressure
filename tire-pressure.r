# The formula is imperial centric and can be found here:
# http://www.biketinker.com/2010/bike-resources/optimal-tire-pressure-for-bicycles/
# The original article is http://www.bikequarterly.com/images/BQTireDrop.pdf.
#
# Weight_lbs is the load on the bicycle wheel and typcially 40 - 60 percent
# of the total weight of the rider, bike and carried items.
#
compute_tire_pressure_psi <- function(weight_lbs, tireSize_mm) {
  return(153.6 * weight_lbs / tireSize_mm**1.5785 - 7.1685)
}

inflation_datum <- function(wheel_load_lbs, tire_size_mm) {
  ltp <- c(wheel_load_lbs, tire_size_mm, compute_tire_pressure_psi(wheel_load_lbs, tire_size_mm))
  return(ltp)
}

# Extra light casings need an extra 10% pressure to prevent the casing threads from breaking.
#
bike_tire_pressures <- function(rider_weight_lbs=100,
                                bike_weight_lbs=15,
                                load_lbs=2,
                                front_tire_casing_compensation=1,
                                front_tire_size_mm=28,
                                rear_tire_casing_compensation=1,
                                rear_tire_size_mm=28,
                                front_distribution=0.5){
  total_weight <- rider_weight_lbs + bike_weight_lbs + load_lbs
  front_weight <- total_weight * front_distribution
  rear_weight <- total_weight * (1 - front_distribution)
  front <- c(round(front_weight), front_tire_size_mm,
              round(compute_tire_pressure_psi(front_weight, front_tire_size_mm) * front_tire_casing_compensation)
             )
  rear <- c(round(rear_weight), rear_tire_size_mm,
            round(compute_tire_pressure_psi(rear_weight, rear_tire_size_mm) * rear_tire_casing_compensation)
             )
  pressures <- matrix(front, ncol=3, byrow=TRUE)
  pressures <- rbind(pressures, rear)
  pressures <- as.data.frame(pressures)
  colnames(pressures) <- c("Weight", "tire_size_mm", "Pressure")
  rownames(pressures) <- c("Front", "Rear")
  pressures$tire_size_mm <- as.factor(pressures$tire_size_mm)
  return(pressures)
}

inflation_data <- matrix(ncol=3, byrow=TRUE,
                           dimnames=list(c(), c("wheel_load_lbs", "tire_size_mm", "tire_pressure_psi")))

# Based on the Bicycle Quarterly chart which was laid in kilograms
wheel_loads_lbs <- c(66, 77, 88, 100, 110, 121, 132, 143, 154)

# Nominal tire sizes
tire_sizes_mm <- c(23, 25, 28, 32, 35, 38, 42, 48)

for(wll in wheel_loads_lbs){
  for(ts in tire_sizes_mm){
    inflation_data <- rbind(inflation_data, inflation_datum(wll, ts))
  }
}

inflation_data <- as.data.frame(inflation_data)
inflation_data <- inflation_data[-c(1), ] # hack alert!
inflation_data$tire_size_mm <- as.factor(inflation_data$tire_size_mm)

base_inflation_plot <- ggplot(inflation_data,
                            aes(x=wheel_load_lbs, y=tire_pressure_psi,
                                group=tire_size_mm, color=tire_size_mm
                            )) +
                    labs(title = "Suggested Bike Tire Inflation\nfor 26in, 650B, and 700C",
                         x = "Wheel Load (Lbs)", y = "Tire Pressure (PSI)") +
                    theme(panel.grid.minor.x = element_line(colour="black", linetype="dotted", size=0.25),
                          panel.grid.minor.y = element_line(color="black", size=0.25)) +
                    theme(panel.background = element_blank()) +
                    theme(aspect.ratio = 0.66) + # hum, might coord_fixed work better?
                    scale_color_brewer(type="seq", palette = "Set1") +
                    scale_x_continuous(breaks=seq(floor(min(inflation_data$wheel_load_lbs) / 10) * 10, ceiling(max(inflation_data$wheel_load_lbs) / 10) * 10, 10)) +
                    scale_y_continuous(breaks=seq(15, 165, 5)) +
                    geom_line()
# # experimenting
# base_inflation_plot +
#   geom_point(data = mooney,
#              aes(x= Weight, y=Pressure, color="black", group= NULL, shape=rownames(mooney)))
# experimenting
base_inflation_plot +
  geom_point(data = mooney,
             aes(x= Weight, y=Pressure, color="black", group= NULL, shape=24))

display_bike_inflation <- function(bike) {

#  cat(str(bike))
  base_inflation_plot +
     geom_point(data = bike,
              mapping = aes(x = Weight, y = Pressure, color = rownames(bike), shape = rownames(bike))
       )
}

mooney <- bike_tire_pressures(rider_weight_lbs = 165,
                              bike_weight_lbs = 20,
                              front_distribution = 0.4,
                              front_tire_size_mm = 26,
                              front_tire_casing_compensation = 1.1,
                              rear_tire_size_mm = 28,
                              rear_tire_casing_compensation = 1.1)

norco <- bike_tire_pressures(rider_weight_lbs = 165,
                             bike_weight_lbs = 35,
                             load_lbs = 20,
                             front_distribution = 0.5,
                             front_tire_size_mm = 32,
                             front_tire_casing_compensation = 1.1,
                             rear_tire_size_mm = 28)
mooney1 <- mooney
mooney1 <- mooney1[, -c(2)]

