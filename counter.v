//计数器
`timescale 1ns/10ps
module counter(clk,res,y);
input clk;
input res;
output[7:0] y;

reg[7:0] y;
wire[7:0] sum;

assign sum = y+1;
always@(posedge clk or negedge res)
if(~res)begin
	y<=0;
end
else begin
	y<=sum;
end
endmodule

//---------testbench of counter_tb;
module counter_tb;
reg	clk, res;
wire[7:0] y;
counter counter(.clk(clk), .res(res), .y(y));

initial begin
	clk<=0;res<=0;
	#17 res<=1;
	#6000 $stop;
end

always #5 clk<=~clk;
endmodule