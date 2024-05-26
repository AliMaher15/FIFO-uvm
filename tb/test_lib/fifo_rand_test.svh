class fifo_rand_test extends  fifo_base_test;
    `uvm_component_utils(fifo_rand_test)

    fifo_rand_vseq m_fifo_rand_vseq;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new
  
    extern virtual task main_phase(uvm_phase phase);
  
endclass : fifo_rand_test

task fifo_rand_test::main_phase(uvm_phase phase);

    m_fifo_rand_vseq = fifo_rand_vseq::type_id::create("m_fifo_rand_vseq");
        
    phase.raise_objection(this);

        `uvm_info(get_type_name(),"Starting test", UVM_LOW)

        `uvm_info(get_type_name(),"executing m_fifo_rand_vseq", UVM_MEDIUM)    
        Randomize_vseq : assert(m_fifo_rand_vseq.randomize() with {number_of_writes inside {[500:1000]};
                                                                   number_of_reads inside  {[500:1000]}; });  
        m_fifo_rand_vseq.start(m_fifo_env.m_vseqr) ;        
        `uvm_info(get_type_name(), "m_fifo_rand_vseq complete", UVM_MEDIUM) 

        `uvm_info(get_type_name(),"Ending test", UVM_LOW)

    phase.drop_objection(this);

endtask : main_phase