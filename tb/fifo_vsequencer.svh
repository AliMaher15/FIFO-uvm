class fifo_vsequencer extends uvm_sequencer;

    // register in factory
    `uvm_component_utils(fifo_vsequencer)

    // contains the following sequencers
    fifo_w_agent_seqr m_fifo_w_agent_seqr;
    fifo_r_agent_seqr m_fifo_r_agent_seqr;
    // env config
    fifo_env_cfg    m_cfg;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(fifo_env_cfg)::get(this, "","m_fifo_env_cfg", m_cfg))
            `uvm_fatal(get_full_name(), "Failed to get fifo_env_cfg from database")
    endfunction

endclass : fifo_vsequencer