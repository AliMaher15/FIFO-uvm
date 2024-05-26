// Class: fifo_sb_predictor
//
class fifo_sb_predictor extends uvm_component;
    `uvm_component_utils(fifo_sb_predictor);

    // Analysis Implementations
    //
    `uvm_analysis_imp_decl(_fifo_w)
    uvm_analysis_imp_fifo_w#(fifo_item, fifo_sb_predictor)  fifo_w_imp;
    `uvm_analysis_imp_decl(_fifo_r)
    uvm_analysis_imp_fifo_r#(fifo_item, fifo_sb_predictor)  fifo_r_imp;

    // Analysis Ports
    //
    uvm_analysis_port #(fifo_item) predicted_w_out_ap;
    uvm_analysis_port #(fifo_item) predicted_r_out_ap;

    // simulate the fifo, to check full/empty
    int unsigned depth = 1<<ADDR_WIDTH;
    logic [DATA_WIDTH-1:0] fifo_q [$];
    bit  predicted_full = 0;
    bit  predicted_empty = 1;
    bit just_read; // it takes time for write domain to sense read

    //  Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new


    // Class Methods
    //
    // Subscriber Implimintation Function for write agent
    extern virtual function    void       write_fifo_w (input fifo_item t);
    // Subscriber Implimintation Function for read agent
    extern virtual function    void       write_fifo_r (input fifo_item t);
    // Function: w_out_predictor
    extern virtual function    fifo_item  w_out_predictor(input fifo_item t);
    // Function: r_out_predictor
    extern virtual function    fifo_item  r_out_predictor(input fifo_item t);
    // Function: build_phase
    extern virtual function    void       build_phase(uvm_phase phase);

endclass : fifo_sb_predictor


// Function: build_phase
function void fifo_sb_predictor::build_phase(uvm_phase phase);
    fifo_w_imp = new("fifo_w_imp",this);
    fifo_r_imp = new("fifo_r_imp",this);
    predicted_w_out_ap = new("predicted_w_out_ap",this);
    predicted_r_out_ap = new("predicted_r_out_ap",this);
endfunction: build_phase


// Function: write_fifo_w
function void fifo_sb_predictor::write_fifo_w(input fifo_item t);
    fifo_item     exp_tr;
    //-------------------------
    exp_tr = w_out_predictor(t);
    if(exp_tr.enable) begin 
        `uvm_info(get_type_name(), $sformatf("write op :\n %0s", exp_tr.sprint), UVM_HIGH)
        predicted_w_out_ap.write(exp_tr);
    end
endfunction : write_fifo_w


// Function: write_fifo_r
function void fifo_sb_predictor::write_fifo_r(input fifo_item t);
    fifo_item     exp_tr;
    //-------------------------
    exp_tr = r_out_predictor(t);
    if(exp_tr.enable) begin
        `uvm_info(get_type_name(), $sformatf("read op :\n %0s", exp_tr.sprint), UVM_HIGH)
        predicted_r_out_ap.write(exp_tr);
    end
endfunction : write_fifo_r


// Function: w_out_predictor
function fifo_item fifo_sb_predictor::w_out_predictor(input fifo_item t);
    fifo_item    tr;

    tr = fifo_item::type_id::create("tr");
    //-------------------------
    `uvm_info(get_type_name(), t.sprint(), UVM_FULL)
    // prediction
    if(t.enable && fifo_q.size() < depth) begin
        fifo_q.push_back(t.data);
        predicted_full = 0;
    end
    if(fifo_q.size() == depth) begin
        predicted_full = 1;
    end
    if((fifo_q.size() == depth-1) && just_read) begin
        predicted_full = 1;
    end
    just_read = 0;
    // if reset
    if(t.rst_op) begin
        predicted_full = 0;
        fifo_q.delete();
    end
    //-------------------------
    // copy all sampled inputs & outputs
    tr.copy(t);
    // overwrite the values with the calculated values
    tr.fifo_busy_flag = predicted_full;
    tr.fifo_used_size = fifo_q.size();
    return(tr);
endfunction: w_out_predictor


// Function: r_out_predictor
function fifo_item fifo_sb_predictor::r_out_predictor(input fifo_item t);
    logic [DATA_WIDTH-1:0] predicted_data;
    fifo_item    tr;

    tr = fifo_item::type_id::create("tr");
    //-------------------------
    `uvm_info(get_type_name(), t.sprint(), UVM_FULL)

    // prediction
    if(t.enable && (fifo_q.size() > 0)) begin
        predicted_data = fifo_q.pop_front();
        predicted_empty = 0;
        just_read = 1;
    end
    if(fifo_q.size() == 0) begin
        predicted_empty = 1;
    end
    // if reset
    if(t.rst_op) begin
        predicted_empty = 1;
    end
    //-------------------------
    // copy all sampled inputs & outputs
    tr.copy(t);
    // overwrite the values with the calculated values
    tr.data = predicted_data;
    tr.fifo_busy_flag = predicted_empty;
    tr.fifo_used_size = fifo_q.size();
    return(tr);
endfunction: r_out_predictor