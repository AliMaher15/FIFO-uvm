class fifo_r_monitor#(DATA_WIDTH = 8) extends uvm_monitor;
    
    `uvm_component_param_utils(fifo_r_monitor#(DATA_WIDTH))

    // Interface and Config handles
	virtual fifo_if #(DATA_WIDTH) vif;
	fifo_r_agent_cfg #(DATA_WIDTH) m_cfg;

    uvm_analysis_port #(fifo_item) input_ap;
    uvm_analysis_port #(fifo_item) output_ap;
    

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Task: input_monitor_run
    extern task input_monitor_run();
    // Task: output_monitor_run
    extern task output_monitor_run();
    // Function: cleanup
    extern function void cleanup();

endclass : fifo_r_monitor


function void fifo_r_monitor::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(fifo_r_agent_cfg #(DATA_WIDTH))::get(this, "", "fifo_r_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
    input_ap  = new("input_ap", this);
    output_ap = new("output_ap", this);
endfunction: build_phase


// Task: run_phase
task fifo_r_monitor::run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.res_n);

      fork
        input_monitor_run();
        output_monitor_run();
      join_none

      @(negedge vif.res_n);
      disable fork;
      cleanup();
    end   
endtask: run_phase


task fifo_r_monitor::input_monitor_run();
    fifo_item m_item = fifo_item::type_id::create("in_item");
    forever begin
        @(posedge vif.clk);
        #2;
        m_item.enable = vif.enable; // read enable
        m_item.timestamp = $time;
        input_ap.write(m_item);
    end
endtask: input_monitor_run


task fifo_r_monitor::output_monitor_run();
    fifo_item m_item = fifo_item::type_id::create("out_item");
    forever begin
        @(posedge vif.clk);
        if(vif.enable) begin
            m_item.data = vif.data;   // read old data
            #2;
            m_item.fifo_busy_flag = vif.fifo_busy_flag; // empty flag
            m_item.timestamp = $time;
            output_ap.write(m_item);
        end
    end
endtask: output_monitor_run


// Function: cleanup
function void fifo_r_monitor::cleanup();
    // Clear all
    fifo_item    cleanup_item = fifo_item::type_id::create("cleanup_item");
    cleanup_item.rst_op = 1;
    input_ap.write(cleanup_item);
    output_ap.write(cleanup_item);
  
  endfunction : cleanup