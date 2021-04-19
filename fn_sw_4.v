//四选一逻辑
`timescale 1ns/10ps;
module fn_sw_4(a, b, sel, y);
input a;
input b;
input[1:0] sel;
output y;
reg y;
always@(a or b or sel)begin
	case(sel)
	2'b00:begin	y<=a&b;	end
	2'b01:begin	y<=a|b;	end
	2'b10:begin	y<=a^b;	end
	2'b11:begin	y<=~(a^b); end
	endcase
end
endmodule

//-------------testbench of fn_sw_4-------
module fn_sw_4_tb;
reg[3:0]	absel;
wire	y;
fn_sw_4 fn_sw_4(.a(absel[0]),.b(absel[1]),.sel(absel[3:2]),.y(y));

initial begin
	absel<=0;
	#200	$stop;
end

always #10 absel<=absel+1;
endmodule