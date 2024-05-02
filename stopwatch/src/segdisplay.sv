module seg_dynamic
(
input wire clk , //系统时钟，频率50MHz
input wire rst , //复位信号，低有效
input wire [3:0] unit , //个位数
input wire [3:0] ten , //十位数
input wire [3:0] hun , //百位数
input wire [3:0] tho , //千位数

output reg [3:0] sel_out , //数码管位选信号
output reg [6:0] seg //数码管段选信号
);

//parameter define
parameter CNT_MAX = 16'd49_999; //数码管刷新时间计数最大值


//reg define
reg flag_1ms; //1ms标志信号
reg [15:0] cnt_1ms ; //1ms计数器


reg [3:0] sel;
reg [1:0] cnt_sel ; //数码管位选计数器
reg [3:0] data_disp ; //当前数码管显示的数据




//flag_1ms:1ms标志信号
//cnt_sel：从0到3循环数，用于选择当前显示的数码管

always@(posedge clk or negedge rst)
if(rst == 1'b0) begin
cnt_1ms <= 16'b0;
cnt_sel <= 2'd0;
end 

else if(cnt_1ms == CNT_MAX) begin
cnt_1ms <= 16'b0;
cnt_sel <= cnt_sel + 1'b1;
end

else begin
cnt_1ms <= cnt_1ms + 1'b1;
cnt_sel <= cnt_sel;
end 

 //控制数码管的位选信号，使4个数码管轮流显示
 always@(posedge clk or negedge rst)
 if(rst == 1'b0) begin 
 data_disp <= 4'b0;
sel_out <= 4'b1111;
end
else begin
 case(cnt_sel)
 3'd0:  begin 
        data_disp <= unit ;
        sel_out <= 4'b1110;
    end
 3'd1:  begin 
        data_disp <= ten ;
        sel_out <= 4'b1101;
    end
 3'd2:  begin 
        data_disp <= hun ;
        sel_out <= 4'b1011;
    end
 3'd3:  begin   
        data_disp <= tho;
        sel_out <= 4'b0111;
    end
 default:begin   
        data_disp <= 4'b0000;
        sel_out <= 4'b1111;
    end
 endcase
end 


 //控制数码管段选信号，显示数字
 always@(posedge clk or negedge rst)
 if(rst == 1'b0)
 seg <= 7'b000_0001;
 else
 case(data_disp)
 4'd0 : seg <= 7'b011_1111; //显示数字0
 4'd1 : seg <= 7'b000_0110; //显示数字1
 4'd2 : seg <= 7'b101_1011; //显示数字2
 4'd3 : seg <= 7'b100_1111; //显示数字3
 4'd4 : seg <= 7'b110_0110; //显示数字4
 4'd5 : seg <= 7'b110_1101; //显示数字5
 4'd6 : seg <= 7'b111_1101; //显示数字6
 4'd7 : seg <= 7'b000_0111; //显示数字7
 4'd8 : seg <= 7'b111_1111; //显示数字8
 4'd9 : seg <= 7'b110_0111; //显示数字9
 default:seg <=7'b100_0000;
 endcase

endmodule