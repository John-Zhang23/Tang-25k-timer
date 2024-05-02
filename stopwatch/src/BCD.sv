module bcd
(
input wire clk , //系统时钟，频率50MHz
input wire rst , //复位信号，低电平有效
input wire [5:0] data , //输入需要转换的数据

output reg [3:0] unit , //个位BCD码
output reg [3:0] ten  //十位BCD码
);

reg [13:0] temp;

assign unit = temp[9:6];
assign ten = temp[13:10];
  always @ (*)
    begin
        temp = 14'b0;                         //置 0
        temp[5:0] = data;                     //读入低 8 位
        repeat (6)                            //重复 8 次
        begin 
            temp[9:6] = (temp[9:6]>4)? temp[9:6] + 2'b11 : temp[9:6]; //大于 4 就加 3
            temp[13:10] = (temp[13:10]>4)? temp[13:10] + 2'b11 : temp[13:10]; //大于 4 就加 3
            temp[13:1] = temp[12:0];               //左移一位
        end
    end
endmodule