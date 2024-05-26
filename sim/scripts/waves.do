# Clocks
add wave /fifo_tb_top/dut/w_clk
add wave /fifo_tb_top/dut/r_clk
add wave /fifo_tb_top/dut/w_rst_n
add wave /fifo_tb_top/dut/r_rst_n

# Inputs
add wave -group FIFO_W -color Magenta /fifo_tb_top/dut/w_en \
                            /fifo_tb_top/dut/w_data \
                            /fifo_tb_top/dut/w_full
                    
# Outputs
add wave -group FIFO_R -color Pink /fifo_tb_top/dut/r_en \
                            /fifo_tb_top/dut/r_data \
                            /fifo_tb_top/dut/r_empty
                            
add wave -position insertpoint  \
sim:/fifo_tb_top/dut/fifomem_0/memory