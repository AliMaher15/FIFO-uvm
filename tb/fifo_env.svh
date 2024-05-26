class fifo_env extends uvm_env;

    // register in factory 
    `uvm_component_utils(fifo_env)

//********** Declare Handles **********//    
    fifo_vsequencer  m_vseqr;
    fifo_env_cfg     m_cfg;
    fifo_w_agent_t   m_fifo_w_agent;
    fifo_r_agent_t   m_fifo_r_agent;
    fifo_scoreboard  m_scoreboard;
    fifo_coverage    m_coverage;
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    // Class Methods
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass : fifo_env

function void fifo_env::build_phase(uvm_phase phase);

    // check configuration
    if(!uvm_config_db#(fifo_env_cfg)::get(this, "", "m_fifo_env_cfg", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get env_cfg from database")

    // path configuration to agents
    uvm_config_db#(fifo_w_agent_cfg_t)::set(this, "m_fifo_w_agent*", "fifo_w_agent_cfg_t", m_cfg.m_fifo_w_agent_cfg);
    uvm_config_db#(fifo_r_agent_cfg_t)::set(this, "m_fifo_r_agent*", "fifo_r_agent_cfg_t", m_cfg.m_fifo_r_agent_cfg);
    
    // create objects
    m_fifo_w_agent = fifo_w_agent_t::type_id::create("m_fifo_w_agent",this);
    m_fifo_r_agent = fifo_r_agent_t::type_id::create("m_fifo_r_agent",this);
    m_vseqr        = fifo_vsequencer::type_id::create("m_vseqr",this);
    m_scoreboard   = fifo_scoreboard::type_id::create("m_scoreboard",this);
    m_coverage     = fifo_coverage::type_id::create("m_coverage",this);
  
endfunction: build_phase


function void fifo_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // connect the virtual sequencer with the agent sequencer
    m_vseqr.m_fifo_w_agent_seqr = m_fifo_w_agent.m_seqr;
    m_vseqr.m_fifo_r_agent_seqr = m_fifo_r_agent.m_seqr;

    // Connect Coverage and Scoreboard with monitor
    m_fifo_w_agent.fifo_w_input_ap.connect(m_coverage.analysis_export);
    m_fifo_r_agent.fifo_r_input_ap.connect(m_coverage.read_imp);

    m_fifo_w_agent.fifo_w_input_ap.connect(m_scoreboard.axp_w_in);
    m_fifo_w_agent.fifo_w_output_ap.connect(m_scoreboard.axp_w_out);

    m_fifo_r_agent.fifo_r_input_ap.connect(m_scoreboard.axp_r_in);
    m_fifo_r_agent.fifo_r_output_ap.connect(m_scoreboard.axp_r_out);
endfunction: connect_phase
