set test_list {{fifo_rand_test} {active_reset_test} {idle_reset_test}} 

foreach var $test_list {
    # Start a new Transcript File
    transcript file ../log/$var.log

    # Start Simulation (choose your options)
    vsim top_opt -c    -assertdebug  -coverage +UVM_TESTNAME=$var +UVM_VERBOSITY=UVM_MEDIUM
    set NoQuitOnFinish 1
    onbreak {resume}
    run -all

    # Save Coverage Results in .ucdb file
    coverage attribute -name var -value $var
    coverage save ../coverage/$var.ucdb

    # Close Transcript File by making a new one
    transcript file {}

    # draw the waves if needed
    #do waves.do
}