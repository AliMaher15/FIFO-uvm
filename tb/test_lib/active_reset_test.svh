// Class: active_reset_test
//
// jump to the pre_reset_phase during main_phase
class active_reset_test extends fifo_rand_test;
    `uvm_component_utils(active_reset_test)
 
    // field: hit_reset
    // Clear this after the reset event to ensure that it only happens once
    bit hit_reset = 1;
 
    // field: reset_delay_ns
    // The amount of time, in ns, before applying reset during the main phase
    int unsigned reset_delay_ns;
 
    function new(string name="active_reset", uvm_component parent=null);
       super.new(name, parent);
    endfunction : new
 
    extern virtual task main_phase(uvm_phase phase);
    
endclass : active_reset_test


task active_reset_test::main_phase(uvm_phase phase);
    fork
        super.main_phase(phase);
    join_none

    if(hit_reset) begin
        phase.raise_objection(this);
        Randomize_reset_delay_time: assert ( std::randomize(reset_delay_ns) with { reset_delay_ns inside {[200:400]}; } );
        #(reset_delay_ns * 1ns);
        phase.drop_objection(this);
        phase.get_objection().set_report_severity_id_override(UVM_WARNING, "OBJTN_CLEAR", UVM_INFO);
        `uvm_info(get_type_name(), "Hitting Reset!!!", UVM_NONE)
        phase.jump(uvm_pre_reset_phase::get());
        hit_reset = 0;
    end
endtask : main_phase