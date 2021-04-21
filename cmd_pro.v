module cmd_pro(clk, res, din_pro, en_din_pro, dout_pro, en_dout_pro,rdy);
input clk;
input res;
input[7:0] din_pro;//指令和数据输入端口
input en_din_pro;//输入使能
output[7:0] dout_pro;
output en_dout_pro;
output rdy;//0表示空闲

parameter add_ab=8'h0a;
parameter sub_ab=8'h0b;
parameter and_ab=8'h0c;
parameter or_ab=8'h0d;

reg[2:0] state;
reg[7:0] cmd_reg,A_reg,B_reg;//存放指令、A、B
reg[7:0] dout_pro;
reg[7:0] en_dout_pro;
always@(posedge clk or negedge res)
if(~res)begin
    state<=0;
    cmd_reg<=0;A_reg<=0;B_reg<=0;en_dout_pro<=0;
    dout_pro<=0;
end
else begin
    case(state)
    0:
    begin
        en_dout_pro<=0;
        if(en_din_pro)begin
            cmd_reg<=din_pro;
            state<=1;
            end
    end
    1:
    begin
        if(en_din_pro)begin
            A_reg<=din_pro;
            state<=2;
        end
    end
    2:
    begin
        if(en_din_pro)begin
            B_reg<=din_pro;
            state<=3;
        end
    end
    3://指令译码和执行
    begin
        state<=4;
        case(cmd_reg)
        add_ab: begin dout_pro<=A_reg+B_reg; end
        sub_ab:begin dout_pro<=A_reg-B_reg; end
        and_ab: begin dout_pro<=A_reg&B_reg; end
        or_ab:  begin dout_pro<=A_reg|B_reg; end
        endcase
    end

    4://发送指令执行结果
    begin
        if(~rdy)begin
            en_dout_pro<=1;//如果串口模块空闲，使能串口发送
            state<=0;//一次cmd_pro已经结束了
        end
    end
    default:
    begin
        state<=0;
        en_dout_pro<=0;
    end
    endcase
end

endmodule

