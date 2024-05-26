class fifo_w_agent#(DATA_WIDTH = 8) extends uvm_agent;

    `uvm_component_param_utils(fifo_w_agent#(DATA_WIDTH))

    fifo_w_agent_cfg #(DATA_WIDTH)  m_cfg;
    fifo_w_driver    #(DATA_WIDTH)  m_driver;
    fifo_w_monitor   #(DATA_WIDTH)  m_monitor;
    fifo_w_agent_seqr               m_seqr;

    uvm_analysis_port #(fifo_item) fifo_w_input_ap;
    uvm_analysis_port #(fifo_item) fifo_w_output_ap;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Function: connect_phase
    extern function void connect_phase(uvm_phase phase);
    //  Task: pre_reset_phase
    extern virtual task pre_reset_phase(uvm_phase phase);
    
endclass : fifo_w_agent


task fifo_w_agent::pre_reset_phase(uvm_phase phase);
    if (m_seqr && m_driver) begin
        m_seqr.stop_sequences();
        ->m_driver.reset_driver;
    end
endtask : pre_reset_phase


function void fifo_w_agent::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(fifo_w_agent_cfg#(DATA_WIDTH))::get(this, "", "fifo_w_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    m_monitor = fifo_w_monitor#(DATA_WIDTH)::type_id::create("m_monitor",this);
    m_monitor.m_cfg = m_cfg;

    // create driver and sequencer if active agent
    if (m_cfg.active == UVM_ACTIVE) begin
        m_seqr   = fifo_w_agent_seqr::type_id::create("m_seqr", this);
        m_driver = fifo_w_driver#(DATA_WIDTH)::type_id::create("m_driver",this);
        m_driver.m_cfg = m_cfg;
    end

    fifo_w_input_ap  = new("fifo_w_input_ap" , this);
    fifo_w_output_ap = new("fifo_w_output_ap", this);
endfunction: build_phase

function void fifo_w_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    m_monitor.input_ap.connect(fifo_w_input_ap);
    m_monitor.output_ap.connect(fifo_w_output_ap);

    if (m_cfg.active == UVM_ACTIVE) begin
        m_driver.seq_item_port.connect(m_seqr.seq_item_export);
    end
    
endfunction: connect_phase