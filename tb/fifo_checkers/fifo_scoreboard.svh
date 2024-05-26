class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    // Analysis Exports
    //
    // connected with fifo write agent monitor
    uvm_analysis_export #(fifo_item)     axp_w_in;
    uvm_analysis_export #(fifo_item)     axp_w_out;
    // connected with fifo read agent monitor
    uvm_analysis_export #(fifo_item)     axp_r_in;
    uvm_analysis_export #(fifo_item)     axp_r_out;

    // Predictor and Comparator
    //
    fifo_sb_predictor         prd;
    fifo_sb_w_comparator      cmp_w;
    fifo_sb_r_comparator      cmp_r;

    // Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Class Methods
    //
    // Function: build_phase
    extern virtual function void build_phase(uvm_phase phase);
    // Function: connect_phase
    extern virtual function void connect_phase(uvm_phase phase); 

endclass : fifo_scoreboard


// Function: build_phase
function void fifo_scoreboard::build_phase(uvm_phase phase);
    axp_w_in  = new("axp_w_in",    this);
    axp_w_out = new("axp_w_out",   this);
    axp_r_in  = new("axp_r_in",    this);
    axp_r_out = new("axp_r_out",   this);  
    prd       = fifo_sb_predictor   ::type_id::create("prd",   this);
    cmp_w     = fifo_sb_w_comparator::type_id::create("cmp_w", this); 
    cmp_r     = fifo_sb_r_comparator::type_id::create("cmp_r", this); 
endfunction : build_phase


// Function: connect_phase
function void fifo_scoreboard::connect_phase( uvm_phase phase ); 
    // Connect predictor & comparator to respective analysis exports
    axp_w_in .connect(prd.fifo_w_imp); 
    axp_r_in .connect(prd.fifo_r_imp); 

    axp_w_out.connect(cmp_w.axp_out); 
    axp_r_out.connect(cmp_r.axp_out);
    // Connect predictor to comparator
    prd.predicted_w_out_ap.connect(cmp_w.axp_predicted_out); 
    prd.predicted_r_out_ap.connect(cmp_r.axp_predicted_out); 
endfunction: connect_phase