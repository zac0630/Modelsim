`timescale 1ns/10ps
module s_counter(clk, res, s_num);
input clk;
input res;
output[3:0] s_num;

parameter frequency_clk = 24;//24MHz
reg[24:0] con_t;//秒脉冲分频计数器
reg s_pulse;//秒脉冲尖
reg[3:0] s_num;

always@(posedge clk or negedge res)
if(~res)begin
    con_t<=0;s_pulse<=0;s_num<=0;
end
else begin
    if(con_t == frequency_clk*1000-1)begin
        con_t<=0;
    end
    else begin
        con_t<=con_t+1;
    end

    if(con_t == 0)begin
    s_pulse<=1;
	end
	else begin
    s_pulse<=0;
	end


	if(s_pulse)begin
    	if(s_num == 9)begin
        	s_num<=0;
    	end
    	else begin
        	s_num<=s_num +1;
    	end
	end

end

endmodule

//------------testbench of s_counter--------

module s_counter_tb;
reg clk,res;
wire[3:0] s_num;
s_counter s_counter(.clk(clk), .res(res), .s_num(s_num));

initial begin
    clk<=0;res<=0;
    #17 res<=1;
    #1000 $stop;
end
always #5 clk<=~clk;
endmodule