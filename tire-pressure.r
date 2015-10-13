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

# Based on the Bicycle Quarterly chart which was laid out in kilograms
wheel_loads_lbs <- c(66, 77, 88, 100, 110, 121, 132, 143, 154)

# Nominal tire sizes. Also happen to be the ones Compass Bicycle sells
tire_sizes_mm <- c(23, 25, 28, 32, 35, 38, 42, 48)

#tire_size_labels <- lapply(tire_sizes_mm, function (t) {paste(as.character(t), "mm", sep = "")})

# Figure out double nested apply semantics!
# Even worse - first row is NAs because of inflation_data has no info in it for
# first rbind call.
for(wll in wheel_loads_lbs){
  for(ts in tire_sizes_mm){
    inflation_data <- rbind(inflation_data, inflation_datum(wll, ts))
  }
}

inflation_data <- as.data.frame(inflation_data)
inflation_data <- inflation_data[-c(1), ] # hack alert!
inflation_data$tire_size_mm <- as.factor(inflation_data$tire_size_mm)
inflation_data$label  <- paste(inflation_data$tire_size_mm, "mm", sep = "")

theme_dg <- theme_bw() +
  theme(panel.grid.minor = element_line(colour="#666666", linetype="dotted", size=0.25),
        panel.grid.major = element_line(size = 0.25, color = "#555555"),
        panel.background = element_blank()
  )


base_inflation_plot <- ggplot(inflation_data,
                              aes(x=wheel_load_lbs, y=tire_pressure_psi,
                                  group=tire_size_mm, color=tire_size_mm
                              )) +
                    theme_dg +
                    labs(title = "Suggested Bike Tire Inflation\nfor 26in, 650B, and 700C",
                         x = "Wheel Load (Lbs)", y = "Tire Pressure (PSI)") +
#                    theme(legend.position = c(0.08, 0.735), legend.justification = c(0, 1)) +
                    theme(aspect.ratio = 0.66) +
                    scale_color_brewer(name = "Tire Size (mm)", type="seq", palette = "Set1") +
                    scale_x_continuous(breaks=seq(floor(min(inflation_data$wheel_load_lbs) / 10) * 10,
                                                  ceiling(max(inflation_data$wheel_load_lbs) / 10) * 10, 10)) +
                    scale_y_continuous(breaks=seq(20, 160, 10)) +
                    coord_cartesian(ylim = c(20, 150)) +
                    geom_line(size = 0.75, show_guide = FALSE) +
                    expand_limits(x = 158) +
                    geom_dl(aes(label = label), method = list("last.qp", cex = 0.75, hjust = -0.05),
                            color = "Black", show_guide = FALSE)

#base_inflation_plot <- direct.label(base_inflation_plot)

display_bike_inflation <- function (base_plot = base_inflation_plot, bike) {
  return(base_plot +
           geom_point(data=bike, aes(x=Weight, y = Pressure), color = "Black", show_guide = FALSE) +
           annotate("text", label = paste0("F: ", bike[1,3]), x = bike[1,1], y = bike[1,3],
                    vjust = -0.4, parse = TRUE) +
           annotate("text", label = paste0("R: ", bike[2,3]), x = bike[2,1], y = bike[2,3],
                    vjust = -0.4, parse = TRUE)
  )
}

# mooney_inflation <- base_inflation_plot +
#   geom_point(data=mooney, aes(x=Weight, y = Pressure), color = "Black", show_guide = FALSE) +
#   annotate("text", label = paste0("F: ", mooney[1,3]), x = mooney[1,1], y = mooney[1,3],
#            vjust = -0.4, parse = TRUE) +
#   annotate("text", label = paste0("R: ", mooney[2,3]), x = mooney[2,1], y = mooney[2,3],
#            vjust = -0.4, parse = TRUE)
