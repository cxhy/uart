//----------------------------------------------------------------------------
//
// *File Name      :       my_uart_top.v
// *Version        :
//                         1.0
// *Module Description:
//                         uart顶层模块
//
// *Author(s)      :
//                        - Guodezheng cxhy1981@gmail.com,
// *LastChangeBy   :      guodezheng
// *CreatTime      :      2016-03-22 10:12:07
// *LastChangeTime :      2016-03-29 14:27:08
//----------------------------------------------------------------------------
`timescale 1ns / 1ps
module my_uart_top(
                clk         ,
                rst_n       ,
                rs232_rx    ,
                rs232_tx
                );

input clk;          // 50MHz主时钟
input rst_n;        //低电平复位信号

input rs232_rx;     // RS232接收数据信号
output rs232_tx;    //  RS232发送数据信号

wire bps_start1,bps_start2; //接收到数据后，波特率时钟启动信号置位
wire clk_bps1,clk_bps2;     // clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点
wire[7:0] rx_data;  //接收数据寄存器，保存直至下一个数据来到
wire rx_int;        //接收数据中断信号,接收到数据期间始终为高电平

speed_select        speed_rx_u(
                            .clk(clk),  //波特率选择模块
                            .rst_n(rst_n),
                            .bps_start(bps_start1),
                            .clk_bps(clk_bps1)
                        );

my_uart_rx          my_uart_rx_u(
                            .clk(clk),  //接收数据模块
                            .rst_n(rst_n),
                            .rs232_rx(rs232_rx),
                            .rx_data(rx_data),
                            .rx_int(rx_int),
                            .clk_bps(clk_bps1),
                            .bps_start(bps_start1)
                        );


speed_select        speed_tx_u(
                            .clk(clk),  //波特率选择模块
                            .rst_n(rst_n),
                            .bps_start(bps_start2),
                            .clk_bps(clk_bps2)
                        );

my_uart_tx          my_uart_tx_u(
                            .clk(clk),  //发送数据模块
                            .rst_n(rst_n),
                            .rx_data(rx_data),
                            .rx_int(rx_int),
                            .rs232_tx(rs232_tx),
                            .clk_bps(clk_bps2),
                            .bps_start(bps_start2)
                        );

endmodule
