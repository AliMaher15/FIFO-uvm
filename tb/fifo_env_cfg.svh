class fifo_env_cfg extends uvm_object;

    `uvm_object_utils(fifo_env_cfg);

    //  Variables
    // rand bit flag = 0;
    //  Constraints

    // agents configurations
    fifo_r_agent_cfg_t  m_fifo_r_agent_cfg;
    fifo_w_agent_cfg_t  m_fifo_w_agent_cfg;

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass: fifo_env_cfg