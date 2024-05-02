module cnt_10ms
#(
parameter  CNT_MAX = 19'd499_999
)
(
input wire clk , //系统时钟50MHz
input wire rst , //全局复位

output reg cnt_out //输出
 );

//define
reg [18:0] cnt ; //经计算得需要18位宽的寄存器才够10ms

//cnt:计数器计数，当计数到CNT_MAX的值时清零,只有start信号进入时才开始计数
always@(posedge clk or negedge rst) 
    if(rst == 1'b0) begin
        cnt <= 19'b0;
        cnt_out <= 1'b0;
    end 
    else if(cnt == CNT_MAX) begin
        cnt <= 19'b0;
        cnt_out <= 1'b1;
    end 
    else begin
        cnt <= cnt + 1'b1;
        cnt_out <= 1'b0;
    end
endmodule