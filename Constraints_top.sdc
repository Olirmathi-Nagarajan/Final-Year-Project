# Set clock period and define clock source
create_clock -period 10ns -name clk [get_pins APA_Filter/clk]

# Input and output signal timing constraints
set_input_delay -clock clk -max 5ns [get_pins APA_Filter/noisy_signal]
set_input_delay -clock clk -max 5ns [get_pins APA_Filter/desired_signal]
set_output_delay -clock clk -max 5ns [get_pins APA_Filter/filtered_signal]

# Define setup and hold timing constraints
set_max_delay -from [get_pins APA_Filter/noisy_signal] -to [get_pins APA_Filter/filtered_signal] 5ns
set_min_delay -from [get_pins APA_Filter/noisy_signal] -to [get_pins APA_Filter/filtered_signal] 1ns
set_min_delay -from [get_pins APA_Filter/desired_signal] -to [get_pins APA_Filter/filtered_signal] 1ns

# Power and area constraints
set_max_power 500mW -cell [get_cells APA_Filter]
set_max_area 5000 um^2 -cell [get_cells APA_Filter/weight]

# Timing exceptions for multi-cycle paths
set_multicycle_path 2 -setup -from [get_pins APA_Filter/weight] -to [get_pins APA_Filter/filtered_signal]

# Set simulation time and output files for Xcelium
set_simulation_time 10000ns
set_output_file "simulation_output.txt"

# Monitor signals during simulation
add_wave [get_pins APA_Filter/noisy_signal]
add_wave [get_pins APA_Filter/desired_signal]
add_wave [get_pins APA_Filter/filtered_signal]
add_wave [get_pins APA_Filter/weight]

# End of constraints
