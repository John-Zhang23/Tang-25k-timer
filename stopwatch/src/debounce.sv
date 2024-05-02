module key_debounce
#(
parameter  CNT_MAX = 20'd999_999 //计数器计数最大值
)
(
input wire clk , //系统时钟50MHz
input wire rst , //全局复位
input wire key_in , //按键输入信号

output reg key_out //key_flag为1时表示消抖后检测到按键被按下
                    //key_flag为0时表示没有检测到按键被按下
);

//define
reg [19:0] cnt_20ms ; //counter


//cnt_20ms:如果时钟的上升沿检测到外部按键输入的值为低电平时，计数器开始计数
always@(posedge clk or negedge rst) begin
    if(rst == 1'b0)
        cnt_20ms <= 20'b0;
    else if(key_in == 1'b1)
        cnt_20ms <= 20'b0;
    else if(cnt_20ms == CNT_MAX && key_in == 1'b0)
        cnt_20ms <= cnt_20ms;
    else
        cnt_20ms <= cnt_20ms + 1'b1;
end



//key_out:当计数满20ms后产生按键有效标志位
//且key_flag在999_999时拉高,维持一个时钟的高电平
always@(posedge clk or negedge rst) begin
    if(rst == 1'b0)
        key_out <= 1'b0;
    else if(cnt_20ms == CNT_MAX - 1'b1)
        key_out <= 1'b1;
    else
        key_out <= 1'b0;
end
endmodule