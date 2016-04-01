//----------------------------------------------------------------------------
//
// *File Name      :       sys_ctrl_task.v
// *Version        :
//                         系统时钟以及复位信号的产生
// *Module Description:
//                         1.0
// *Author(s)      :
//                         Guodezheng cxhy1981@gmail.com,
// *LastChangeBy   :      guodezheng
// *CreatTime      :      2016-03-31 22:25:56
// *LastChangeTime :      2016-03-31 23:03:33
//----------------------------------------------------------------------------
//
`timescale 1ns / 1ps
module sys_ctrl_task (
     clk_sys,
     reset_l
);


output clk_sys;
output reset_l;


reg  clk_sys;
reg  reset_l;


parameter PERIOD = 20;                //时钟周期为20ns fs=1/20*10^-9 = 50M hz
parameter RST_ING = 1'b0;             //低电平复位

initial begin
    clk_sys = 0;
    forever
        #(PERIOD/2) clk_sys = ~clk_sys;
end

task sys_reset;
    input [31:0] rseet_time;
    begin
        reset_l = RST_ING;
        #rseet_time;
        reset_l = ~RST_ING;
    end
endtask



endmodule
