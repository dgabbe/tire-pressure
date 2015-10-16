# The formula is imperial centric and can be found here:
# http://www.biketinker.com/2010/bike-resources/optimal-tire-pressure-for-bicycles/
# The original article is http://www.bikequarterly.com/images/BQTireDrop.pdf.
#
# Weight_lbs is the load on the bicycle wheel and typcially 40 - 60 percent
# of the total weight of the rider, bike and carried items.
#
# 1 Psi = 0.0689475729 Bar
# 1 pound = 0.45359 kilogram
#

psi_to_bar <- function(psi) {return(psi * 0.068947)}

lb_to_kg <- function(lb) {return(lb *  0.45359)}

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
        panel.background = element_blank(),
        plot.title = element_text(size = rel(1.75), face = "bold", vjust = 1),
        axis.text = element_text(size = rel(1.25)),
        axis.title.x = element_text(size = rel(1.5), vjust = -1),
        axis.title.y = element_text(size = rel(1.5), vjust = 0)
  )

dual_weight <- function(lbs) {
  return(sprintf('%.0f lbs\n%.0f kg', lbs, lb_to_kg(lbs)))
}

dual_pressure_point <- function(position, psi) {
  return(sprintf('%s\n%d psi\n%.1f bar', position, psi, psi_to_bar(psi)))
}

dual_pressure <- function(psi) {
  return(sprintf('%d psi\n%.1f bar', psi, psi_to_bar(psi)))
}

base_inflation_plot <- ggplot(inflation_data,
                              aes(x=wheel_load_lbs, y=tire_pressure_psi,
                                  group=tire_size_mm, color=tire_size_mm
                              )) +
                    theme_dg +
                    labs(title = "Optimized Bicycle Tire Pressure for 26, 650B, and 700C Sizes",
                         x = "Wheel Load", y = "Tire Pressure") +
#                    theme(legend.position = c(0.08, 0.735), legend.justification = c(0, 1)) +
                    theme(aspect.ratio = 0.66) +
                    scale_color_brewer(name = "Tire Size (mm)", type="seq", palette = "Set1") +
                    scale_x_continuous(breaks=seq(floor(min(inflation_data$wheel_load_lbs) / 10) * 10,
                                                  ceiling(max(inflation_data$wheel_load_lbs) / 10) * 10, 10),
                                       label = dual_weight) +
                    scale_y_continuous(breaks=seq(20, 160, 10), label = dual_pressure) +
                    coord_cartesian(ylim = c(20, 150)) +
                    annotate("rect", xmin = 66, xmax= 160, ymin = 20, ymax = 105, alpha = 0.1, fill = "#33cc33") +
                    annotate("text", label = paste0("Attempt to keep pressure below 105 psi for safety and comfort"),
                             x = 67, y = 99, hjust = 0, vjust = -0.9, color = "#33cc33") +
                    geom_line(size = 0.75, show_guide = FALSE) +
                    expand_limits(x = 158) +
                    geom_dl(aes(label = label), method = list("last.qp", cex = 1, hjust = -0.05),
                            color = "Black", show_guide = FALSE)

#base_inflation_plot <- direct.label(base_inflation_plot)

display_bike_inflation <- function (base_plot = base_inflation_plot, bike) {
  return(base_plot +
           geom_point(data=bike, aes(x=Weight, y = Pressure), color = "Black", show_guide = FALSE) +
           annotate("text", label = dual_pressure_point("Front", bike["Front","Pressure"]),
                                           x = bike["Front", "Weight"], y = bike["Front","Pressure"],
                    vjust = -0.4) +
            annotate("text", label = dual_pressure_point("Rear", bike["Rear", "Pressure"]),
                                            x = bike["Rear", "Weight"], y = bike["Rear", "Pressure"],
                     vjust = -0.4)
  )
}

