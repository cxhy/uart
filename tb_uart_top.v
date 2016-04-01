//----------------------------------------------------------------------------
//
// *File Name      :       tb_my_uart_top.v
// *Version        :
//                         uart顶层模块仿真文件
// *Module Description:
//                         1.0
// *Author(s)      :
//                        -Guodezheng cxhy1981@gmail.com,
// *LastChangeBy   :      guodezheng
// *CreatTime      :      2016-03-22 10:12:07
// *LastChangeTime :      2016-04-01 10:24:25
//----------------------------------------------------------------------------



`timescale 1ns / 1ps
module tb_uart_top;


wire clk;
wire rst_n;
reg rs232_rx;
wire rs232_tx;

print_task print();

sys_ctrl_task sys_ctrl(
                .clk_sys       (clk)   ,
                .reset_l       (rst_n)

    );

uart_top uart_top_u(
                .clk       (clk)      ,
                .rst_n     (rst_n)    ,
                .rs232_rx  (rs232_rx) ,
                .rs232_tx  (rs232_tx)
                );





parameter BPS9600   = 32'd104_167;      //104167ns= 5207 * 20  在50M时钟下面就是5207个clk上升沿
parameter BPS19200  = 32'd52_083;
parameter BPS38400  = 32'd26_041;
parameter BPS57600  = 32'd17_361;
parameter BPS115200 = 32'd8_681;

integer tx_bps;
integer rx_bps;
reg [7:0] cnt;

reg [7:0] data_temp;
reg rx_flag;
reg [7:0] tx_data;


initial begin
    sys_ctrl.sys_reset(500);
    rs232_rx = 1'b1;
    #1000;

    rx_bps = BPS9600;
    tx_bps = BPS9600;

    // rs232_rx = 1'b0;
    // #tx_bps;

    // rs232_rx = 1;
    // #tx_bps;
    // rs232_rx = 0;
    // #tx_bps;
    // rs232_rx = 1;
    // #tx_bps;
    // rs232_rx = 0;
    // #tx_bps;
    // rs232_rx = 1;
    // #tx_bps;
    // rs232_rx = 0;
    // #tx_bps;
    // rs232_rx = 1;
    // #tx_bps;
    // rs232_rx = 0;
    // #tx_bps;

    // rs232_rx = 1;
    // #tx_bps;
    // tx_task(8'haa);
    for(cnt=0; cnt<255; cnt=cnt+1)begin
        tx_task(cnt);
        @(negedge rx_flag)begin
            if(data_temp == cnt)begin
                $write("order data transmit: %d,receive:%d;OK\n",cnt,data_temp);
            end
            else begin
                $write("order data transmit: %d,receive:%d;error\n",cnt,data_temp);
                print.error("false");
            end
        end
    end

    #10_000;

    for(cnt=0; cnt<255; cnt=cnt+1)begin
        tx_data = {$random};
        tx_task(tx_data);
        @(negedge rx_flag)begin
            if(data_temp == tx_data)begin
                $write("random data transmit: %d,receive:%d;OK\n",tx_data,data_temp);
            end
            else begin
                $write("random data transmit: %d,receive:%d;error\n",tx_data,data_temp);
                print.error("false");
            end
        end
    end
    print.terminate;
end

task tx_task;
    input [7:0] txdata;
    integer i;
    begin
        rs232_rx = 0;
        #tx_bps;
        for (i = 0; i < 8; i = i + 1) begin
            rs232_rx = txdata[7-i];
            #tx_bps;
        end
        rs232_rx = 1;
        #tx_bps;
    end
endtask



integer j;
always@(negedge rs232_tx)begin
    #(tx_bps/2);
    if(rs232_tx == 0)begin
        rx_flag = 1;
        #tx_bps;
        for (j = 0; j < 8; j = j + 1) begin
            data_temp[7-j] = rs232_tx;
            #tx_bps;
        end
        rx_flag = 0;
    end
end



endmodule
