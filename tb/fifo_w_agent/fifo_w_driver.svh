class fifo_w_driver#(DATA_WIDTH = 8) extends uvm_driver#(fifo_item);
    
    `uvm_component_param_utils(fifo_w_driver#(DATA_WIDTH))
    
    // Interface and Config handles
	virtual fifo_if#(DATA_WIDTH)  vif;
	fifo_w_agent_cfg #(DATA_WIDTH)  m_cfg;
    // reset event activated by agent
    event           reset_driver;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    //  Task: run_phase
    extern task run_phase(uvm_phase phase);
    // Task: run_driver
    extern task run_driver();
    // Function: cleanup
    extern function void cleanup();
    // Task : reset_phase
    extern task reset_phase(uvm_phase phase);

endclass : fifo_w_driver


function void fifo_w_driver::build_phase(uvm_phase phase);
    // check configuration
    if(!uvm_config_db#(fifo_w_agent_cfg #(DATA_WIDTH))::get(this, "", "fifo_w_agent_cfg_t", m_cfg))
        `uvm_fatal(get_full_name(), "Failed to get agent_cfg from database")

    vif = m_cfg.vif;
endfunction: build_phase


// Task : reset_phase
task fifo_w_driver::reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    cleanup();
endtask: reset_phase


//  Task: run_phase
task fifo_w_driver::run_phase(uvm_phase phase);
    forever begin
        @(posedge vif.res_n);

        fork
            run_driver();
        join_none
        @(reset_driver);
        disable fork;
        cleanup();
    end
endtask: run_phase


task fifo_w_driver::run_driver();

    fifo_item m_item;

    forever begin
        seq_item_port.get_next_item(m_item);
        
        @(negedge vif.clk);

        if(vif.fifo_busy_flag) begin 
            // fifo is full
            vif.enable <= 0;
            seq_item_port.item_done();
        end else begin
            vif.data   <= m_item.data;
            vif.enable <= m_item.enable;
            seq_item_port.item_done();
        end
    end

endtask: run_driver


// Function: cleanup
function void fifo_w_driver::cleanup();
    vif.data     <= 'b0; // wdata
    vif.enable <= 0;     // w_en
endfunction : cleanup