class fifo_vseq_base extends  uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(fifo_vseq_base)
    `uvm_declare_p_sequencer(fifo_vsequencer)
  
  
    function new(string name = "");
      super.new(name);
    endfunction : new
  
  endclass : fifo_vseq_base