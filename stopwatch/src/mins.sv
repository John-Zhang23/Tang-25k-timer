module Mins
#(
parameter    CNT_MAX= 6'd59, //设最多100 mins    
parameter    Mins_MAX=6'd59 // 60s 进 1 mins
)
(
input wire rst , //全局复位
input reg sec_in ,//second信号

output reg [5:0] mins,
output reg min_flag
);

//define
reg [5:0] min_cnt;

//sec_in:计数器计数，当计数到59时清零
always@(posedge sec_in or negedge rst) 

    if(rst == 1'b0)  begin
        min_cnt <= 6'b0;
        min_flag <= 1'b0;
    end

    else if(min_cnt == Mins_MAX) begin
        min_cnt <= 6'b0;
        min_flag <= 1'b1;
    end

    else begin
        min_cnt <= min_cnt  + 1'b1;
        min_flag <= 1'b0;
    end


 //min_flag:计数到最大值产生的信号
 always@(posedge min_flag or negedge rst) 
    if(rst == 1'b0)
        mins <= 6'b0;
    else if(mins == CNT_MAX)
        mins <= 6'b0;
    else
        mins <= mins + 1'b1;
 endmodule