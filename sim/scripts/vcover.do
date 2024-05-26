
# can use instance=/tb/dut/* to cover all dut's instances

vcover report ../coverage/fifo.ucdb  -cvg      -details                      -output   ../coverage/fun_coverage.txt
vcover report ../coverage/fifo.ucdb  -instance=/fifo_tb_top/dut/*            -output   ../coverage/code_coverage.txt
vcover report ../coverage/fifo.ucdb  -instance=/fifo_tb_top/dut/*  -details  -output   ../coverage/code_coverage_details.txt