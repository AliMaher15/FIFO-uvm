#***************************************************#
# Clean Work Library
#***************************************************#
if [file exists "work"] {vdel -all}
vlib work

#***************************************************#
# Start a new Transcript File
#***************************************************#
transcript file ../log/compile.log

#***************************************************#
# Compile RTL and TB files
#***************************************************#
do compile_dut.do
do compile_tb.do 

#***************************************************#
# Optimizing Design with vopt
#***************************************************#
vopt fifo_tb_top -o top_opt +acc +cover

#***************************************************#
# Simulation of Tests
#***************************************************#

do test.do

#***************************************************#
# Close the Transcript file
#***************************************************#
transcript file {}

#***************************************************#
# save the coverage in text files
#***************************************************#
vcover merge  ../coverage/fifo.ucdb \
              ../coverage/fifo_rand_test.ucdb \
              ../coverage/active_reset_test.ucdb \
              ../coverage/idle_reset_test.ucdb 
              
do vcover.do

exit