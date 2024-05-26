// Class: idle_reset_test
//
// jump to pre_reset_phase after the simulation and all transactions are ended during shutdown phase
class idle_reset_test extends fifo_rand_test;
    `uvm_component_utils(idle_reset_test)
 
    // field: run_count
    // The number of times the test has run so far
    int run_count;
    
    function new(string name="idle_reset", uvm_component parent=null);
       super.new(name, parent);
    endfunction : new
 
    extern virtual function void phase_ready_to_end(uvm_phase phase);

endclass : idle_reset_test


function void idle_reset_test::phase_ready_to_end(uvm_phase phase);
    super.phase_ready_to_end(phase);
    
    if(phase.get_imp() == uvm_shutdown_phase::get()) begin
      if(run_count == 0) begin
         `uvm_info(get_type_name(), "Hitting Reset!!!", UVM_NONE)
            phase.jump(uvm_pre_reset_phase::get());
            run_count++;
      end
    end
 endfunction : phase_ready_to_end