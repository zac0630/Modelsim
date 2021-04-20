//最简单的状态机，三角波发生器
`timescale 1ns/10ps
module tri_gen(clk, res, d_out);
input clk;
input res;
output[9:0] d_out;

reg[1:0] state;//主状态机寄存器
reg[9:0] d_out;
reg[7:0] con;//计数器记录平顶周期数

always@(posedge clk or negedge res)
if(~res)begin
    state<=0;d_out<=0;con<=0;
end
else begin
    case(state)
    0://上升
    begin
        d_out<=d_out+1;
        if(d_out == 299)begin
            state<=1;
            end
    end
    1:
    begin
        if(con==200)begin
            state<=2;
            con<=0;
        end
        else begin
            con<=con+1;
        end
    end

    2://下降
    begin
        d_out<=d_out-1;
        if(d_out == 1)begin
            state<=3;
            end
    end
    3:
    begin
        if(con==200)begin
            state<=0;
            con<=0;
        end
        else begin
            con<=con+1;
        end
    end
    endcase
end


endmodule

module tri_gen_tb();
reg clk, res;
wire[9:0] d_out;

tri_gen U1(.clk(clk), .res(res), .d_out(d_out));

initial begin
    clk<=0; res<=0;
    #17 res<=1;
    #8000 $stop;
end

always #5 clk<=~clk;

endmodule