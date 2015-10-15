source("tire-pressure.r")

mooney_bike <- bike_tire_pressures(rider_weight_lbs = 165,
                                   bike_weight_lbs = 20,
                                   front_distribution = 0.4,
                                   front_tire_size_mm = 26,
                                   front_tire_casing_compensation = 1.1,
                                   rear_tire_size_mm = 28,
                                   rear_tire_casing_compensation = 1.1)

mooney_plot <- display_bike_inflation(base_inflation_plot, mooney_bike)

norco_shopping_bike <- bike_tire_pressures(rider_weight_lbs = 165,
                                           bike_weight_lbs = 35,
                                           load_lbs = 20,
                                           front_distribution = 0.5,
                                           front_tire_size_mm = 32,
                                           front_tire_casing_compensation = 1.1,
                                           rear_tire_size_mm = 28)

norco_shopping_35_bike <- bike_tire_pressures(rider_weight_lbs = 165,
                                              bike_weight_lbs = 35,
                                              load_lbs = 20,
                                              front_distribution = 0.5,
                                              front_tire_size_mm = 35,
                                              front_tire_casing_compensation = 1.1,
                                              rear_tire_size_mm = 32,
                                              rear_tire_casing_compensation = 1.1)

norco_fun_bike <- bike_tire_pressures(rider_weight_lbs = 165,
                                      bike_weight_lbs = 35,
                                      load_lbs = 3,
                                      front_distribution = 0.45,
                                      front_tire_size_mm = 32,
                                      front_tire_casing_compensation = 1.1,
                                      rear_tire_size_mm = 28)

norco_plot <- display_bike_inflation(base_inflation_plot, norco_shopping_bike)

leslie_trek_lexa_bike <- bike_tire_pressures(rider_weight_lbs = 145,
                                      bike_weight_lbs = 15,
                                      load_lbs = 1,
                                      front_distribution = 0.4,
                                      front_tire_size_mm = 28,
                                      rear_tire_size_mm = 26)

leslie_trek_lexa_plot <- display_bike_inflation(base_inflation_plot, leslie_trek_lexa_bike)

# Someone like Nairo Quintana
light_rider_bike <- bike_tire_pressures(
  rider_weight_lbs = 125,
  bike_weight_lbs = 15,
  load_lbs = 1,
  front_distribution = 0.4,
  front_tire_size_mm = 28,
  front_tire_casing_compensation = 1.1,
  rear_tire_size_mm = 28,
  rear_tire_casing_compensation = 1.1)

# Someone like Nairo Quintana
light_rider_plot <- display_bike_inflation(base_inflation_plot, light_rider_bike)
