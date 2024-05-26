class fifo_base_test extends  uvm_test;
  
    `uvm_component_utils(fifo_base_test)
  
    // Reset Driver
    rst_driver_c     m_rst_drv;
    
    fifo_w_agent_cfg_t  m_fifo_w_agent_cfg;
    fifo_r_agent_cfg_t  m_fifo_r_agent_cfg;

    virtual fifo_if_t fifo_w_if;
    virtual fifo_if_t fifo_r_if;
  
    fifo_env_cfg       m_fifo_env_cfg;
    fifo_env           m_fifo_env;
    
  
    function new(string name, uvm_component parent);
      super.new(name,parent);
    endfunction : new
  
    extern virtual function void build_phase(uvm_phase phase);

    extern virtual function void start_of_simulation_phase(uvm_phase phase);
  
endclass : fifo_base_test


function void fifo_base_test::build_phase(uvm_phase phase);
    //****************************************************************************//
    //*************** Handle Configurations and Interfaces ***********************//
    //****************************************************************************//
    m_fifo_env_cfg   = fifo_env_cfg::type_id::create ("m_fifo_env_cfg");

    m_fifo_w_agent_cfg = fifo_w_agent_cfg_t::type_id::create("m_fifo_w_agent_cfg");
    m_fifo_r_agent_cfg = fifo_r_agent_cfg_t::type_id::create("m_fifo_r_agent_cfg");

    if(!uvm_config_db #(fifo_if_t)::get(this, "", "write_if",  m_fifo_w_agent_cfg.vif))
        `uvm_fatal(get_type_name(), "Failed to get write_if")
    if(!uvm_config_db #(fifo_if_t)::get(this, "", "read_if",   m_fifo_r_agent_cfg.vif))
        `uvm_fatal(get_type_name(), "Failed to get read_if")

    m_fifo_w_agent_cfg.active = UVM_ACTIVE ;
    m_fifo_r_agent_cfg.active = UVM_ACTIVE ;

    m_fifo_env_cfg.m_fifo_r_agent_cfg = m_fifo_r_agent_cfg;
    m_fifo_env_cfg.m_fifo_w_agent_cfg = m_fifo_w_agent_cfg;

    uvm_config_db #(fifo_env_cfg)::set(this, "*", "m_fifo_env_cfg", m_fifo_env_cfg);
    //****************************************************************************//
    m_fifo_env = fifo_env::type_id::create("m_fifo_env",this);

    // Reset Handling
    m_rst_drv = rst_driver_c::type_id::create("m_rst_drv", this);
    uvm_config_db#(string)::set(this, "m_rst_drv", "intf_name", "rst_i");
    m_rst_drv.randomize();
endfunction : build_phase


// Print Testbench structure and factory contents
function void fifo_base_test::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    if (uvm_report_enabled(UVM_MEDIUM)) begin
      this.print();
      factory.print();
    end
endfunction : start_of_simulation_phase