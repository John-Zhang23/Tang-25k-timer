module stopwatch (
    input clk     ,
    input rst_n   ,
    output segment ,
    seg_sel ,
    key     
    );
 
    //can shu
    parameter      DATA_W =         8;
    parameter      TIMES_1S =   4999_999;
    parameter      TIMES_1us= 49    ;
    parameter _0 = 8'b1100_0000, _1 = 8'b1111_1001, _2 = 8'b1010_0100,
              _3 = 8'b1011_0000, _4 = 8'b1001_1001, _5 = 8'b1001_0010,
              _6 = 8'b1000_0010, _7 = 8'b1111_1000, _8 = 8'b1000_0000,
              _9 = 8'b1001_0000;
 
 
 
    //输入信号定义
    input               key       ;
    input               clk       ;
    input               rst_n     ;
    output[DATA_W-1:0]  segment   ;
    output[DATA_W-3:0]  seg_sel   ;
 
    reg   [DATA_W-1:0]  segment   ;
    reg   [DATA_W-3:0]  seg_sel   ;
    //一些中间变量
    reg   [22:0]        count_1s  ;
    reg   [5:0]         count_1us ;
    reg   [6:0]         count_120us ;
    //miao
    reg   [5:0]         count_60s ;
    //fen
    reg   [5:0]         count_60m ;
    //shi
    reg   [4:0]         count_24h ;
    //20ms 定时器
    reg   [14:0]        count_20ms ;
    //按键  打两拍
    reg     key_reg1    ;
    reg     key_reg2    ;
	 reg     key_flag    ;
	 reg[DATA_W-1:0]  s_ge    ;
	 reg[DATA_W-1:0]  s_shi   ;
	 reg[DATA_W-1:0]  m_ge    ;
	 reg[DATA_W-1:0]  m_shi   ;
	 reg[DATA_W-1:0]  h_ge    ;
	 reg[DATA_W-1:0]  h_shi   ;
	 //停止与启动信号  按键
	 reg pause                ;
	 reg flag_20ms            ;
	 reg key_en               ;
	 reg flag_20ms_ff0        ;
/********************************************************************************************/
//1s timer
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_1s<=23'd0 ;
        end
        else  if(count_1s==TIMES_1S)
            count_1s<=23'd0 ;
        else  if(pause==1'b1)
            count_1s<=count_1s+1'b1;
		  else 
				count_1s<=count_1s     ;
    end 
/********************************************************************************************/
    //逐一设计每个输出信号
    //列扫描  刷新时间为20us  总共用了6个数码管，设计一个计时器  6*20us=120us
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_1us<=6'd0;
        end
        else if(count_1us==TIMES_1us) 
            count_1us<=6'd0;
        else
            count_1us<=count_1us+1'b1;
    end
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_120us<=7'd0;
        end
        else if(count_120us==119&&count_1us==TIMES_1us)
            count_120us<=7'd0;
        else if(count_1us==TIMES_1us)
            count_120us<=count_120us+1'b1;      
    end
 
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            seg_sel<=6'b111_110 ;
        end
        else if(count_120us==0)
            seg_sel<=6'b111_110 ;
        else if(count_120us==19&&count_1us==TIMES_1us)
            seg_sel<=6'b111_101 ; 
        else if(count_120us==39&&count_1us==TIMES_1us)
            seg_sel<=6'b111_011 ;
        else if(count_120us==59&&count_1us==TIMES_1us)
            seg_sel<=6'b110_111 ;
        else if(count_120us==79&&count_1us==TIMES_1us)
            seg_sel<=6'b101_111 ;
        else if(count_120us==99&&count_1us==TIMES_1us)
            seg_sel<=6'b011_111 ;        
    end
	
/********************************************************************************************/
    //shi 设计一个24进制计数器
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_24h<=5'd0;
        end
        else if(count_60m==59&&count_60s==59&&count_1s==TIMES_1S)begin
            if(count_24h==23)
                count_24h<=5'd0;
            else
                count_24h<=count_24h+1'b1;
        end
    end
      //shi_ge   
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            h_ge<=4'd0;
        end
        else if(seg_sel==6'b101_111)begin
            case (count_24h%10)
                0:
                    h_ge<=_0;
                1:
                    h_ge<=_1;
                2:
                    h_ge<=_2;
                3:
                    h_ge<=_3;
                4:
                    h_ge<=_4;
                5:
                    h_ge<=_5;
                6:
                    h_ge<=_6;
                7:
                    h_ge<=_7;
                8:
                    h_ge<=_8;
                9:
                    h_ge<=_9;
            endcase
 
        end
    end
//shi_shi
   always  @(posedge clk or negedge rst_n)begin
       if(rst_n==1'b0)begin
           h_shi<=4'd0;
       end
       else if(seg_sel==6'b011_111)begin
           case (count_24h/10)
                0:
                    h_shi<=_0;
                1:
                    h_shi<=_1;
                2:
                    h_shi<=_2;
                3:
                    h_shi<=_3;
                4:
                    h_shi<=_4;
                5:
                    h_shi<=_5;
                6:
                    h_shi<=_6;
                7:
                    h_shi<=_7;
                8:
                    h_shi<=_8;
                9:
                    h_shi<=_9;
           endcase
       end
   end
 
    
/********************************************************************************************/
    //fen 设计一个60进制计数器 count_60m
 
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_60m<=6'd0;
        end
        else if(count_60m==59&&count_60s==59&&count_1s==TIMES_1S)
              count_60m<=6'd0;
        else if(count_60s==59&&count_1s==TIMES_1S)
              count_60m<=count_60m+1'b1;
        
    end
 
    //fen_ge   
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            m_ge<=4'd0;
        end
        else if(seg_sel==6'b111_011)begin
            case (count_60m%10)
                0:
                    m_ge<=_0;
                1:
                    m_ge<=_1;
                2:
                    m_ge<=_2;
                3:
                    m_ge<=_3;
                4:
                    m_ge<=_4;
                5:
                    m_ge<=_5;
                6:
                    m_ge<=_6;
                7:
                    m_ge<=_7;
                8:
                    m_ge<=_8;
                9:
                    m_ge<=_9;
            endcase
        end
    end
//fen_shi
   always  @(posedge clk or negedge rst_n)begin
       if(rst_n==1'b0)begin
           m_shi<=4'd0;
       end
       else if(seg_sel==6'b110_111)begin
           case (count_60m/10)
                0:
                    m_shi<=_0;
                1:
                    m_shi<=_1;
                2:
                    m_shi<=_2;
                3:
                    m_shi<=_3;
                4:
                    m_shi<=_4;
                5:
                    m_shi<=_5;
                6:
                    m_shi<=_6;
                7:
                    m_shi<=_7;
                8:
                    m_shi<=_8;
                9:
                    m_shi<=_9;
           endcase
       end
   end
/********************************************************************************************/
    //miao 设计一个60计数器  count_60s 
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_60s<=6'd0;
        end
        else if(count_60s==59&&count_1s==TIMES_1S)
           count_60s<=6'd0;
        else if(count_1s==TIMES_1S)
           count_60s<=count_60s+1'b1; 
        
    end
//miao_ge   
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            s_ge<=4'd0;
        end
        else if(seg_sel==6'b111_110)begin
            case (count_60s%10)
                0:
                    s_ge<=_0;
                1:
                    s_ge<=_1;
                2:
                    s_ge<=_2;
                3:
                    s_ge<=_3;
                4:
                    s_ge<=_4;
                5:
                    s_ge<=_5;
                6:
                    s_ge<=_6;
                7:
                    s_ge<=_7;
                8:
                    s_ge<=_8;
                9:
                    s_ge<=_9;
            endcase
        end
    end
//miaoshi
   always  @(posedge clk or negedge rst_n)begin
       if(rst_n==1'b0)begin
           s_shi<=4'd0;
       end
       else if(seg_sel==6'b111_101)begin
           case (count_60s/10)
                0:
                    s_shi<=_0;
                1:
                    s_shi<=_1;
                2:
                    s_shi<=_2;
                3:
                    s_shi<=_3;
                4:
                    s_shi<=_4;
                5:
                    s_shi<=_5;
                6:
                    s_shi<=_6;
                7:
                    s_shi<=_7;
                8:
                    s_shi<=_8;
                9:
                    s_shi<=_9;
           endcase
       end
   end
/********************************************************************************************/
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            key_reg1<=1'b1;
            key_reg2<=1'b1;
        end
        else begin
            key_reg1<=key       ;
            key_reg2<=key_reg1  ;
        end
    end
	 
//按键输入
//20ms 定时器
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_20ms<=15'd0;
        end
        else if(key_reg2)begin 
				count_20ms<=15'd0;
		  end 
		  else if(count_20ms==19999&&count_1us==TIMES_1us)begin
				count_20ms<=count_20ms;
		  end 
		  else  if(count_1us==TIMES_1us)begin
				count_20ms<=count_20ms+1'b1;
		  end 
    end
  always @(*) begin
	if(count_20ms>=19999)
		flag_20ms<=1'b1;
	else 
		flag_20ms<=1'b0;
  end 
 
	always  @(posedge clk or negedge rst_n)begin
		  if(rst_n==1'b0)begin
            flag_20ms_ff0<=1'b0;
        end
		  else 
				flag_20ms_ff0 <= flag_20ms;
	end
//	always  @(posedge clk or negedge rst_n)begin
//		  if(rst_n==1'b0)begin
//            key_en<=1'b0;
//        end
//		  else if(flag_20ms&&flag_20ms_ff0==1'b0)
//				key_en <= 1'b1;
//		  else 
//				key_en <= 1'b0;
//	end
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
             key_en<=1'b0;
         end
	 else if(flag_20ms==1'b0&&flag_20ms_ff0==1)
				 key_en <= 1'b1;
	 else 
				 key_en <= 1'b0;
	 end         
	always  @(posedge clk or negedge rst_n)begin
		  if(rst_n==1'b0)begin
            pause<=1'b1;
        end
		  else if(pause==1'b1&&key_en)
				pause <= 1'b0;
		  else if(pause==1'b0&&key_en)
				pause <= 1'b1;
	end   
 
 
 
/********************************************************************************************/
 always  @(posedge clk or negedge rst_n)begin
	if(rst_n==1'b0)begin
            segment<=8'd0;
   end
	else begin
		case(seg_sel)
		6'b111_110:
			segment<=s_ge;
		6'b111_101:
			segment<=s_shi;
		6'b111_011:
			segment<=m_ge;
		6'b110_111:
			segment<=m_shi;
		6'b101_111:
			segment<=h_ge;
		6'b011_111:
			segment<=h_shi;
		default:
			segment<=segment;
		endcase
	end
 end
   
    endmodule
