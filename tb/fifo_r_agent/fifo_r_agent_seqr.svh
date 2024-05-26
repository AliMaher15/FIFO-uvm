class fifo_r_agent_seqr extends uvm_sequencer #(fifo_item);

    `uvm_component_utils(fifo_r_agent_seqr)
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

endclass : fifo_r_agent_seqr