create_clock -name clk -period 10 -waveform {0 5} [get_ports "clk"]
set_clock_transition -rise 0.1 [get_clocks "clk"]
set_clock_transition -fall 0.1 [get_clocks "clk"]
set_clock_uncertainty 0.01 [get_ports "clk"]
set_input_delay -max 1.0 [get_ports "A"] -clock [get_clocks "clk"]
set_input_delay -max 1.0 [get_ports "B"] -clock [get_clocks "clk"]
set_input_delay -max 1.0 [get_ports "op_code"] -clock [get_clocks "clk"]
set_input_delay -max 1.0 [get_ports "en"] -clock [get_clocks "clk"]


set_output_delay -max 1.0 [get_ports "result_out"] -clock [get_clocks "clk"]
set_output_delay -max 1.0 [get_ports "flag_carry"] -clock [get_clocks "clk"]
set_output_delay -max 1.0 [get_ports "flag_zero"] -clock [get_clocks "clk"]
