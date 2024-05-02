//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.9 Beta-4 Education
//Created Time: 2024-04-20 09:04:39
create_clock -name clk_50m -period 20 -waveform {0 10} [get_ports {clk}]
