vlib work
vmap work work

vlog -work work tb_my_uart_top.v
vlog -work work my_uart_rx.v
vlog -work work my_uart_top.v
vlog -work work my_uart_tx.v
vlog -work work speed_select.v

vsim -novopt tb_my_uart_top
#add wave sim:/tb_openMSP430/u_dma_master/channel_0/*
#add wave -position insertpoint sim:/tb_openMSP430/dma_tfbuffer_u/*
#add wave sim:/tb_openMSP430/dma_tfbuffer_u/*
add wave -position insertpoint sim:/tb_my_uart_top/*
radix -hex
view wave
run 100us

