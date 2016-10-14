vlib work
vmap work work

vlog -work work tb_uart_top.v
vlog -work work sys_ctrl_task.v
vlog -work work print_task.v
vlog -work work uart_rx.v
vlog -work work uart_top.v
vlog -work work uart_tx.v
vlog -work work uart_speed_select.v

vsim -novopt tb_uart_top
#add wave -position insertpoint sim:/tb_my_uart_top/*
#add wave -position insertpoint sim:/tb_my_uart_top/my_uart_top_u/*
#add wave -position insertpoint sim:/tb_my_uart_top/my_uart_top_u/my_uart_rx_u/*
add wave -position insertpoint sim:/tb_uart_top/uart_top_u/*
add wave -position insertpoint sim:/tb_uart_top/uart_top_u/uart_tx_u/*
radix -hex
view wave
run -all
