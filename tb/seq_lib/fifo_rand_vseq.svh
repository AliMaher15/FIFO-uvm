class fifo_rand_vseq extends fifo_vseq_base;

    `uvm_object_utils(fifo_rand_vseq)
  
    fifo_rand_seq  m_write_seq;
    fifo_rand_seq  m_read_seq ;

    rand int unsigned number_of_writes;
    rand int unsigned number_of_reads;
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
    extern virtual task body();
  
endclass : fifo_rand_vseq

task fifo_rand_vseq::body();
    m_write_seq = fifo_rand_seq::type_id::create("m_write_seq");
    m_read_seq  = fifo_rand_seq::type_id::create("m_read_seq");
    
    fork
        begin
            `uvm_info(get_type_name(), $sformatf("executing %0d rand write ops", number_of_writes), UVM_MEDIUM)
            repeat(number_of_writes) begin
                `uvm_info(get_type_name(), "executing write sequence", UVM_HIGH)
                m_write_seq.start(p_sequencer.m_fifo_w_agent_seqr); 
            end
            m_write_seq.enable_off = 1; // so it ends with no write
            m_write_seq.start(p_sequencer.m_fifo_w_agent_seqr);
            `uvm_info(get_type_name(), "write sequence complete", UVM_MEDIUM)
        end
        begin
            `uvm_info(get_type_name(), $sformatf("executing %0d rand read ops", number_of_reads), UVM_MEDIUM)
            repeat(number_of_reads) begin
                `uvm_info(get_type_name(), "executing read sequence", UVM_HIGH)
                m_read_seq.start(p_sequencer.m_fifo_r_agent_seqr);
            end
            m_read_seq.enable_off = 1; // so it ends with no read
            m_read_seq.start(p_sequencer.m_fifo_r_agent_seqr);
            `uvm_info(get_type_name(), "read sequence complete", UVM_MEDIUM)
        end
    join
endtask : body