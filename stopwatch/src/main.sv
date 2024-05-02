module stopwatch (
input wire clk,

output reg [3:0] sel,
output reg [6:0] seg
);

reg rst,cn_10ms, sec_flag, min_flag;
reg [5:0] sec, min;

reg [3:0]sec_unit,sec_ten,min_unit,min_ten;

assign rst = 1'b1;

cnt_10ms cnt_10ms0(
.clk (clk),
.rst (rst),

.cnt_out (cn_10ms)
);

Sec Sec0(
.rst (rst),
.cnt_10ms (cn_10ms),

.sec (sec),
.sec_flag (sec_flag)
);


Mins Mins0(
.rst (rst),
.sec_in (sec_flag),

.mins (min),
.min_flag (min_flag)
);

bcd bcd0
(
.clk (clk),
.rst (rst),
.data (min),
.unit (min_unit),
.ten  (min_ten)
 );

bcd bcd1
(
.clk (clk),
.rst (rst),
.data (sec),
.unit (sec_unit),
.ten  (sec_ten)
 );

seg_dynamic seg0(
.clk (clk), 
.rst (rst), 
.unit (sec_unit),
.ten (sec_ten), 
.hun (min_unit), 
.tho (min_ten), 

.sel_out (sel),
.seg (seg)
);

endmodule 