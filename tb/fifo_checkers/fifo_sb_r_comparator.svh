// Class: fifo_sb_r_comparator
//
class fifo_sb_r_comparator extends uvm_component;

    `uvm_component_utils(fifo_sb_r_comparator);


    // Analysis Exports
    //
    // actual outputs
    uvm_analysis_export   #(fifo_item)       axp_out;
    // predicted outputs
    uvm_analysis_export   #(fifo_item)       axp_predicted_out;
    
    // TLM FIFOs
    //
    // fifo to extract out writes one by one
    uvm_tlm_analysis_fifo #(fifo_item)       expfifo;
    uvm_tlm_analysis_fifo #(fifo_item)       outfifo;

    // Variables
    //
    typedef enum int {
        data_error, empty_error
    } error_type;
    error_type error_array [int];
    int TEST_CNT, PASS_CNT, ERROR_CNT;
    bit test_ended = 0;

    // Constructor: new
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction


    // Class Methods
    //
    // Function: build_phase
    extern virtual function void build_phase(uvm_phase phase);
    // Function: connect_phase
    extern virtual function void connect_phase(uvm_phase phase);
    // Task: run_phase
    extern virtual task run_phase(uvm_phase phase);
    // Function: report_phase
    extern virtual function void report_phase(uvm_phase phase); 
    // Task: compare_out
    extern virtual task compare_out(input fifo_item exp, fifo_item out);
    // Functions: PASS
    extern virtual function void PASS(fifo_item out, fifo_item exp); 
    // Functions: ERROR
    extern virtual function void ERROR(error_type err, fifo_item out, fifo_item exp); 
    // Function: phase_ready_to_end
    extern virtual function void phase_ready_to_end(uvm_phase phase);
    // Task: wait_for_ok_to_finish
    extern virtual task wait_for_ok_to_finish();
endclass : fifo_sb_r_comparator


// Function: build_phase
function void fifo_sb_r_comparator::build_phase(uvm_phase phase);
    axp_out           = new("axp_out"          , this);
    axp_predicted_out = new("axp_predicted_out", this); 

    expfifo = new("expfifo", this); 
    outfifo = new("outfifo", this); 
endfunction : build_phase

// Function: connect_phase
function void fifo_sb_r_comparator::connect_phase(uvm_phase phase); 
    super.connect_phase(phase);
    // connect to predictor
    axp_predicted_out.connect(expfifo.analysis_export); 
    // connect to actual output
    axp_out.connect(outfifo.analysis_export); 
endfunction : connect_phase

// Task: run_phase
task fifo_sb_r_comparator::run_phase(uvm_phase phase);
    fifo_item     exp, out;
    fork
        compare_out(exp, out);
    join
endtask: run_phase

// Task: compare_out
task fifo_sb_r_comparator::compare_out(input fifo_item exp  , fifo_item out);
    bit empty_pass, data_pass;
    forever begin 
        empty_pass = 0; data_pass = 0;
        `uvm_info(get_type_name(), "WAITING for expected output", UVM_FULL)
        expfifo.get(exp);
        `uvm_info(get_type_name(), "WAITING for actual output"  , UVM_FULL)
        outfifo.get(out);
        if(out.rst_op || exp.rst_op) begin
            `uvm_info(get_type_name(), "flushing fifo", UVM_FULL)
            expfifo.flush();
            outfifo.flush();
            continue;
        end
        if(exp.enable) begin
            TEST_CNT++;
            // check empty bit
            if (exp.fifo_busy_flag == out.fifo_busy_flag) begin
                empty_pass = 1;
            end
            else begin 
                ERROR(empty_error, out, exp);
            end
            // check data
            if(!exp.fifo_busy_flag) begin // fifo not empty
                if (exp.data == out.data) begin
                    data_pass = 1;
                end
                else begin 
                    ERROR(data_error, out, exp);
                end
            end else begin
                data_pass = 1;
            end
            // if all passed
            if(empty_pass && data_pass) begin
                PASS(out, exp);
            end
        end else begin
            continue;
        end
    end
endtask: compare_out

// Functions: PASS
function void fifo_sb_r_comparator::PASS(fifo_item out, fifo_item exp); 
    PASS_CNT++;
    `uvm_info ("PASS", $sformatf("\nActual=%s\nExpected=%s \n",
                                out.sprint(), 
                                exp.sprint()), UVM_FULL)
endfunction: PASS

// Functions: ERROR
function void fifo_sb_r_comparator::ERROR(error_type err, fifo_item out, fifo_item exp);
    ERROR_CNT++;
    error_array[TEST_CNT] = err;
    `uvm_error("ERROR", $sformatf("\n%s\nActual=%s\nExpected=%s \n", err,
                                out.sprint(),
                                exp.sprint()))
endfunction: ERROR

// Function: report_phase
function void fifo_sb_r_comparator::report_phase(uvm_phase phase); 
    super.report_phase(phase); 
    if (TEST_CNT && !ERROR_CNT) begin
        `uvm_info(get_type_name(),$sformatf("\n\n\n*** READ TEST PASSED - %0d vectors ran, %0d vectors passed ***\n", 
                                            TEST_CNT, PASS_CNT), UVM_LOW) 
    end else begin
        `uvm_info(get_type_name(), $sformatf("\n\n\n*** READ TEST FAILED - %0d vectors ran, %0d vectors passed, %0d vectors failed ***\n",
                                             TEST_CNT, PASS_CNT, ERROR_CNT), UVM_LOW)
    end
    for (int i=1; i<=TEST_CNT; i++) begin
        if(error_array.exists(i))
            `uvm_info(get_type_name(), $sformatf("\nerror at test index %0d : %0s", i, error_array[i].name()), UVM_LOW)
    end
endfunction: report_phase


function void fifo_sb_r_comparator::phase_ready_to_end(uvm_phase phase);
    if(phase.is(uvm_run_phase::get)) begin
        if(!test_ended) begin
            phase.raise_objection(this);
            fork
                begin
                    wait_for_ok_to_finish();
                    phase.drop_objection(this);
                end
            join_none
        end
    end
endfunction


task fifo_sb_r_comparator::wait_for_ok_to_finish();
    `uvm_info(get_type_name(), "finishing checks", UVM_MEDIUM)
    wait(expfifo.used() == outfifo.used());
    test_ended = 1;
endtask