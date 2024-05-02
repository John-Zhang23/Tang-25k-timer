\`timescale 1ns/1ns
module tb_top_seg_595();


//wire define
wire stcp ; //输出数据存储寄时钟
wire shcp ; //移位寄存器的时钟输入
 wire ds ; //串行数据输入
 wire oe ; //输出使能信号

 //reg define
 reg sys_clk ;
 reg sys_rst_n ;


 initial
 begin
 sys_clk = 1'b1;
 sys_rst_n <= 1'b0;
 #100
 sys_rst_n <= 1'b1;
 end

 //clk:产生时钟
 always #10 sys_clk <= ~sys_clk;


 