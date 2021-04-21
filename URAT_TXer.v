`timescale 1ns/10ps
module URAT_TXer(clk, res, data_in,en_data_in, TX, rdy);
input clk;
input res;
input[7:0] data_in;
input en_data_in;
output TX;
output rdy;//0表示空闲

reg[3:0] state;
reg[9:0] send_buf;
assign TX=send_buf[0];

reg[12:0] con;//用于计算波特周期
reg[9:0] send_flag;//用于判断右移结束

reg rdy;

always@(posedge clk or negedge res)
if(~res) begin
    state<=0;send_buf<=1;con<=0;send_flag<=10'b10_0000_0000;
    rdy<=0;
end
else begin
    case(state)
    0://等待使能信号
    begin
        if(en_data_in)begin
            send_buf<={1'b1, data_in,1'b0};
            send_flag<=10'b10_0000_0000;
            rdy<=1;
            state<=1;
        end
    end
    1://串口发送，寄存器右移
    begin
        if(con==5000-1)
        begin
            con<=0;
        end
        else begin
            con<=con+1;
        end

        if(con==5000-1)begin
            send_buf[8:0]<=send_buf[9:1];
            send_flag[8:0]<=send_flag[9:1];
        end

        if(send_flag[0])begin
            rdy<=0;
            state<=0;
        end
    end
    2:begin   end
    3:begin   end
    endcase
end

endmodule

module UART_TXer_tb;
reg clk,res;
reg[7:0] data_in;
reg en_data_in;
wire TX;
wire rdy;
URAT_TXer URAT_TXer(clk, res, data_in, en_data_in, TX, rdy);

initial begin
    clk<=0;res<=0;data_in<=8'h0a;en_data_in<=0;
    #17 res<=1;
    #30 en_data_in<=1;
    #10 en_data_in<=0;

    #1000000 $stop;
end

always #5 clk<=~clk;

endmodule