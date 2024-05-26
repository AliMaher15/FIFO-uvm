class fifo_w_agent_cfg #(DATA_WIDTH = 8) extends uvm_object;

    `uvm_object_param_utils(fifo_w_agent_cfg #(DATA_WIDTH))

    //Variables
    virtual fifo_if #(DATA_WIDTH) vif;
    uvm_active_passive_enum active = UVM_ACTIVE;

    // Randimized variables and configurations
    

    //Constraints


    //Functions

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass : fifo_w_agent_cfg
