`timescale 1ns/10ps
module UART_RXer(clk, res, RX, data_out, en_data_out);
input clk;
input res;
input RX;
output[7:0] data_out;
output en_data_out;

reg[7:0] state;
reg[12:0] con;//用于计算比特宽度
reg[3:0] con_bits;//用于计算比特数

reg RX_delay;//RX延时
reg[7:0] data_out;
reg en_data_out;

always@(posedge clk or negedge res)
if(~res)begin
    state<=0; con<=0; con_bits<=0; RX_delay<=0;
    data_out<=0;
end
else begin
    RX_delay<=RX;
    case(state)
    0://等空闲
    begin
        if(con==5000-1)begin
            con<=0;
        end
        else begin
            con<=con+1;
        end

        if(con==0)begin
            if(RX)begin
                con_bits<=con_bits+1;
            end
            else begin
                con_bits=0;
            end
        end

        if(con_bits == 12)begin
            state<=1;
        end
    end

    1://空闲
    begin
        en_data_out<=0;
        if(~RX&RX_delay)begin
            state<=2;
        end
    end

    2://收b0位 等1.5T
    begin
        if(con == 7500-1)begin
            con<=0;
            data_out[0]<=RX;
            state<=3;
        end
        else  begin
            con<=con+1;
        end
    end

    3:
    begin
        if(con == 5000-1)begin
            con<=0;
            data_out[1]<=RX;
            state<=4;
        end
        else  begin
            con<=con+1;
        end
    end

    4:
    begin
        if(con == 5000-1)begin
            con<=0;
            data_out[2]<=RX;
            state<=5;
        end
        else  begin
            con<=con+1;
        end        
    end

    5:
    begin
        if(con == 5000-1)begin
            con<=0;
            data_out[3]<=RX;
            state<=6;
        end
        else  begin
            con<=con+1;
        end
    end

    6:
    begin
        if(con == 5000-1)begin
            con<=0;
            data_out[4]<=RX;
            state<=7;
        end
        else  begin
            con<=con+1;
        end
    end

    7:
    begin
        if(con == 5000-1)begin
            con<=0;
            data_out[5]<=RX;
            state<=8;
        end
        else  begin
            con<=con+1;
        end
    end 

    8:
    begin
        if(con == 5000-1)begin
            con<=0;
            data_out[6]<=RX;
            state<=9;
        end
        else  begin
            con<=con+1;
        end
    end  

    9:
    begin
        if(con == 5000-1)begin
            con<=0;
            data_out[7]<=RX;
            state<=10;
        end
        else  begin
            con<=con+1;
        end
    end 

    10://产生使能脉冲
    begin
        en_data_out<=1;
        state<=1;
    end

    default:
    begin
        con<=0;
        state<=0;
        con_bits<=0;
        en_data_out<=0;
    end
    endcase
end

endmodule

//------------testbench of URAT_RXer----------------
module URAT_RXer_tb();
reg clk, res;
wire RX;
wire[7:0] data_out;
wire en_data_out;

reg[35:0] RX_send;//里面装有串口数据
assign RX=RX_send[0];

reg[12:0] con;

UART_RXer UART_RXer(.clk(clk), .res(res), .RX(RX), .data_out(data_out), .en_data_out(en_data_out));

initial begin
    clk<=0;res<=0;RX_send<={1'b1,8'h26,1'b0,1'b1,8'haa,1'b0,16'hffff};con<=0;
    #17 res<=1;
    #4000000 $stop;
end

always #5 clk=~clk;

always@(posedge clk)begin
    if(con== 5000 -1)begin
        con<=0;
    end
    else begin
        con<=con+1;
    end

    if(con==0)begin
        RX_send[34:0]<=RX_send[35:1];
        RX_send[35]<=RX_send[0];
    end


end


endmodule