// //----------------------------------------------------------------------------
// //
// // *File Name      :       tb_my_uart_top.v
// // *Version        :
// //                         uart顶层模块仿真文件
// // *Module Description:
// //                         1.0
// // *Author(s)      :
// //                        -Guodezheng cxhy1981@gmail.com,
// // *LastChangeBy   :      guodezheng
// // *CreatTime      :      2016-03-22 10:12:07
// // *LastChangeTime :      2016-03-30 10:26:05
// //----------------------------------------------------------------------------
//
//
`timescale 1 ns/ 1 ps
module tb_my_uart_top();

reg clk;
reg rs232_rx;
reg rst_n;
// wires
wire rs232_tx;

// assign statements (if any)
my_uart_top my_uart_top_u (
// port map - connection between master ports and signals/registers
    .clk(clk),
    .rs232_rx(rs232_rx),
    .rs232_tx(rs232_tx),
    .rst_n(rst_n)
);

initial clk = 0;
always #10 clk = ~clk;

initial
begin
    rst_n = 0;
    #60 rst_n = 1;
end

//这里模拟PC机循环发出两字节的数据前一个数据是0xA9（8'b1010_1001）,
//后一个数据是0xD4（8'b1101_0100）
//数据的格式采用1字节起始位（0）、8字节数据、1字节停止位（1）
initial
begin
    #100        rs232_rx = 1;
    forever
        begin                           //1ms时开始发送第一个数据
            #1000000    rs232_rx = 0;   //第一个数据起始位--->0
            #104166     rs232_rx = 1;   //第一个数据0bit--->1
            #104166     rs232_rx = 0;   //第一个数据1bit--->0
            #104166     rs232_rx = 0;   //第一个数据2bit--->0
            #104166     rs232_rx = 1;   //第一个数据3bit--->1
            #104166     rs232_rx = 0;   //第一个数据4bit--->0
            #104166     rs232_rx = 1;   //第一个数据5bit--->1
            #104166     rs232_rx = 0;   //第一个数据6bit--->0
            #104166     rs232_rx = 1;   //第一个数据7bit--->1
            #104166     rs232_rx = 1;   //第一个数据停止位--->1
            #104166     ;   //停止位的持续时间

            //1ms后开始发送第二个数据
            #1000000    rs232_rx = 0;   //第二个数据起始位--->0
            #104166     rs232_rx = 0;   //第二个数据0bit--->0
            #104166     rs232_rx = 0;   //第二个数据1bit--->0
            #104166     rs232_rx = 1;   //第二个数据2bit--->1
            #104166     rs232_rx = 0;   //第二个数据3bit--->0
            #104166     rs232_rx = 1;   //第二个数据4bit--->1
            #104166     rs232_rx = 0;   //第二个数据5bit--->0
            #104166     rs232_rx = 1;   //第二个数据6bit--->1
            #104166     rs232_rx = 1;   //第二个数据7bit--->1
            #104166     rs232_rx = 1;   //第二个数据停止位--->1
            #104166     ;   //停止位的持续时间
        end
end

// initial
// begin
//     #100000000 $stop;
// end

endmodule


// `timescale 1ns / 1ps
// module tb_my_uart_top;

// reg clk;
// reg rst_n;

// reg rs232_rx;
// wire rs232_tx;

// parameter PERIOD = 20;           //周期时间长度 （ns）
// parameter RST_ING = 1'b0;       //复位模式，


// my_uart_top my_uart_top_u(
//                 .clk       (clk)      ,
//                 .rst_n     (rst_n)    ,
//                 .rs232_rx  (rs232_rx) ,
//                 .rs232_tx  (rs232_tx)
//                 );

// initial begin
//     clk = 0;
//     forever
//         #(PERIOD/2) clk = ~clk;
// end

// task sys_reset;
//     input [31:0] reset_time;
//     begin
//         rst_n = RST_ING;
//         #reset_time;
//         rst_n = ~RST_ING;
//     end
// endtask

// task warning;
//     input[80*8:1] msg;
//     begin
//         $write("WARNING at %t : %s ", $time,msg);
//     end
// endtask

// task error;
//     input[80*8:1]msg;
//     begin
//         $write("ERROR at %t : %s", $time,msg);
//     end
// endtask

// task fatal;
//     input[80*8:1]msg;
//     begin
//         $write("FATAL at %t: %s", $time,msg);
//         $write("simulation false\n");
//         $stop;
//     end
// endtask

// task terminate;
//     begin
//         $write("simulation successful\n");
//     end
// endtask

// parameter BPS9600   = 32'd104_167;
// parameter BPS19200  = 32'd52_083;
// parameter BPS38400  = 32'd26_041;
// parameter BPS57600  = 32'd17_361;
// parameter BPS115200 = 32'd8_681;

// integer tx_bps;
// integer rx_bps;
// reg [7:0] cnt;

// reg [7:0] data_temp;
// reg rx_flag;
// reg tx_data;

// initial begin
//     sys_reset(500);
//     rs232_rx = 1'b1;
//     #1000;

//     rx_bps = BPS9600;
//     tx_bps = BPS9600;

//     for (cnt = 0; cnt < 255; cnt = cnt + 1) begin
//         // tx_task(cnt);
//         // @(negedge rx_flag);
//         // if(data_temp == cnt)
//         //     $write("transmit: %d,receive:%d;ture\n",cnt,data_temp);
//         // else begin
//         //     $write("transmit: %d,receive:%d;error\n",cnt,data_temp);
//         //     error("false");
//         // end
//     end

//     #10_000;

//     // for (cnt = 0; cnt < 255; cnt = cnt + 1) begin
//     //     tx_data = {$random};
//     //     tx_task(tx_data);
//     //     @(negedge rx_flag);
//     //     if(data_temp == tx_data)
//     //         $write("transmit: %d,receive:%d;ture\n",cnt,data_temp);
//     //     else begin
//     //         $write("transmit: %d,receive:%d;error\n",cnt,data_temp);
//     //         error("false");
//     //     end
//     // end

//     terminate;
// end

// task tx_task;
//     input [7:0] txdata;
//     integer i;
//     begin
//         rs232_rx = 0;
//         #tx_bps;
//         for (i = 0; i < 8; i = i + 1) begin
//             rs232_rx = txdata[7-i];
//             #tx_bps;
//         end
//         rs232_rx = 1;
//         #tx_bps;
//     end
// endtask

// integer j;
// always@(posedge rs232_tx)begin
//     #(tx_bps/2);
//     if(rs232_tx == 0)begin
//         rx_flag = 1;
//         #tx_bps;
//         for (j = 0; j < 8; j = j + 1) begin
//             data_temp[7-j] = rs232_tx;
//             #tx_bps;
//         end
//         rx_flag = 0;
//     end
// end



// endmodule
// // module tb_my_uart_top;


// // reg clk;
// // reg rst_n;
// // reg rs232_rx;
// // wire rs232_tx;

// // reg [3:0] cnt;
// // reg [9:0] cnt_send;


// // // initial begin
// // //             clk = 0;
// // //             rst_n = 1;
// // //             // din8 = 0;
// // //             #100;
// // //             rst_n = 0;
// // //             repeat(100) begin
// // //             // #   86800;
// // //             // # 86800;
// // //             // TxD_start_in = 0;
// // //         end
// // //       end
// // //     always #10  clk = ~clk;
// // //     always @(posedge clk or negedge rst_n) begin
// // //         if(!rst_n) begin
// // //             rs232_tx <= 1'b0;
// // //             cnt      <= 0;
// // //         end else begin
// // //             rs232_tx <= 1'b1;
// // //         end
// // //     end
// // //     always @(posedge clk or negedge rst_n) begin
// // //         if(!rst_n) begin
// // //             cnt <= 0;
// // //         end else begin
// // //             cnt <= cnt + 1;
// // //         end
// // //     end
// // //     always @(posedge clk or negedge rst_n) begin
// // //         if(!rst_n) begin
// // //             cnt_send <= 0;
// // //         end else begin
// // //             cnt_send <= cnt_send + 1;
// // //         end
// // //     end

// // // end

// // initial begin
// //     clk      = 0 ;
// //     rs232_rx = 0 ;
// //     cnt      = 0 ;
// //     cnt_send = 0 ;
// //     rst_n    = 0 ;
// //     #100
// //     rst_n    = 1 ;
// // end

// // always #10 clk = ~clk;           //50M 时钟

// // always @(posedge clk or negedge rst_n) begin
// //     if(~rst_n) begin
// //         cnt <= 0;
// //     end else begin
// //         cnt <= cnt + 1 ;
// //     end
// // end

// // always @(posedge clk or negedge rst_n) begin
// //     if(~rst_n) begin
// //         cnt_send <= 0;
// //     end else begin
// //         cnt_send <= cnt_send + 1 ;
// //     end
// // end


// // //2603
// // wire  [7:0] q = 8'b01100110;
// // reg   [7:0] q1 ;
// // always @(posedge clk or negedge rst_n) begin
// //     if(~rst_n) begin
// //         q1 <= 0;
// //     end else begin
// //         q1 <= 8'b01100110;
// //     end
// // end

// // initial begin
// //     #500
// //     rs232_rx = 1;
// //     #5207           //500 + 5207 * 1
// //     rs232_rx = 0;
// //     #5207          //500 + 5207 * 2
// //     rs232_rx = 1;
// //     #5207          //500 + 5207 * 3
// //     rs232_rx = 0;
// //     #5207          //500 + 5207 * 4
// //     rs232_rx = 1;
// //     #5207          //500 + 5207 * 5
// //     rs232_rx = 0;
// //     #5207          //500 + 5207 * 6
// //     rs232_rx = 1;
// //     #5207          //500 + 5207 * 7
// //     rs232_rx = 0;
// //     #5207          //500 + 5207 * 8
// //     rs232_rx = 1;


// // end

// // my_uart_top my_uart_top_u(
// //                           clk         ,
// //                           rst_n       ,
// //                           rs232_rx    ,
// //                           rs232_tx
// //                 );

// // initial begin
// //     #99
// //     $display("rst_n in 99 is %h ", rst_n );
// //     #100
// //     $display("rst_n in 100 is %h ", rst_n );
// //     #101
// //     $display("rst_n in 101 is %h ", rst_n );
// //     #3000
// //     $display("q is %h",q);
// //     $display("q1 is %h",q1);
// // end


// // endmodule


// // // 500 + 5207 * 1 =  5707
// // // 500 + 5207 * 2 =  10914
// // // 500 + 5207 * 3 =  16121
// // // 500 + 5207 * 4 =21328
// // // 500 + 5207 * 5 =26535
// // // 500 + 5207 * 6 =31742
// // // 500 + 5207 * 7 =36949

