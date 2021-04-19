`timescale 1ns/10ps

module inv(A, Y);
input A;
output Y;

assign Y = ~A;
endmodule

module inv_tb;
reg aa;
wire yy;
inv inv(.A(aa), .Y(yy));

initial begin
	aa<=0;
	#10 aa<=1;
	#10 aa<=0;
	#10 aa<=1;
	#10 aa<=0;
	#10 $stop;
end
endmodule