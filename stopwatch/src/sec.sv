module Sec
#(
parameter  CTS_MAX = 7'd99, //10ms-1s时间
parameter  SECS_MAX = 6'd59 //60 秒最多
)
(
input wire rst , //全局复位
input wire cnt_10ms ,//100hz信号

output reg [5:0] sec,
output reg sec_flag
);

//define
reg [6:0] sec_cnt;

//cnt_10ms:计数器计数，当计数到99时清零
always@(posedge cnt_10ms or negedge rst) 

    if(rst == 1'b0)  begin
        sec_cnt <= 7'b0;
        sec_flag <= 1'b0;
    end

    else if(sec_cnt == CTS_MAX) begin
        sec_cnt <= 7'b0;
        sec_flag <= 1'b1;
    end

    else begin
        sec_cnt <= sec_cnt  + 1'b1;
        sec_flag <= 1'b0;
    end

 //sec_flag:计数到最大值产生的信号
 always@(posedge sec_flag or negedge rst) 
    if(rst == 1'b0)
        sec <= 6'b0;
    else if(sec == SECS_MAX)
        sec <= 6'b0;
    else
        sec <= sec + 1'b1;
 endmodule