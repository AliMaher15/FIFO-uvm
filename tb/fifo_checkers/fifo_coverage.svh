// To Do
// cover when you read and write at the same location

class fifo_coverage extends uvm_subscriber#(fifo_item);
    `uvm_component_utils(fifo_coverage)
    
    `uvm_analysis_imp_decl(_read)
    uvm_analysis_imp_read#(fifo_item, fifo_coverage) read_imp; 

    /// inputs to dut
    fifo_item  write_item;
    fifo_item  read_item;

    // simulate the fifo, to check full/empty
    int depth = 1<<ADDR_WIDTH;
    logic [DATA_WIDTH-1:0] fifo_q [$];
    bit full, empty;

    // Covergroups
    //
    // covergroup for all write operations
    covergroup fifo_write_cg;
        wdata_cp : coverpoint write_item.data {
            bins all_zeros = {'b0};
            bins all_ones  = {'hFF};
        }

        wen_cp : coverpoint write_item.enable;

        wdata_wen_cxp : cross wdata_cp, wen_cp {
            bins write_zeros    = binsof(wdata_cp.all_zeros) && binsof(wen_cp) intersect {1};
            bins write_ones     = binsof(wdata_cp.all_ones)  && binsof(wen_cp) intersect {1};
            ignore_bins wen_off = binsof(wen_cp) intersect {0};
        }

        full_cp : coverpoint full;

        wen_full_cxp : cross wen_cp, full_cp {
            bins write_when_full = binsof(wen_cp) intersect {1} && binsof(full_cp) intersect {1};
            ignore_bins wen_off  = binsof(wen_cp) intersect {0};
            ignore_bins full_off = binsof(full_cp) intersect {0};
        }
    endgroup: fifo_write_cg

    // covergroup for all read operations
    covergroup fifo_read_cg;
        ren_cp : coverpoint read_item.enable;

        empty_cp : coverpoint empty;

        ren_empty_cxp : cross ren_cp, empty_cp {
            bins read_when_empty = binsof(ren_cp) intersect {1} && binsof(empty_cp) intersect {1};
            ignore_bins ren_off  = binsof(ren_cp) intersect {0};
            ignore_bins empty_off = binsof(empty_cp) intersect {0};
        }
    endgroup: fifo_read_cg
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        fifo_write_cg = new();
        fifo_read_cg = new();
    endfunction

    extern virtual function void build_phase(uvm_phase phase);

    extern virtual function void write(fifo_item t);

    extern virtual function void write_read(fifo_item t);

endclass : fifo_coverage


function void fifo_coverage::build_phase(uvm_phase phase);
    write_item = fifo_item::type_id::create("read_item");
    read_item  = fifo_item::type_id::create("write_item");
    read_imp = new("read_imp", this);
endfunction


function void fifo_coverage::write(fifo_item t);
    write_item.data   = t.data;
    write_item.enable = t.enable;
    //********************************//
    //********* Full logic  **********//
    //********************************//
    if(t.rst_op == 1) begin
        full = 0;
    end else begin
    //********************************//
        if(t.enable) begin
            fifo_q.push_back(t.data);
            if(fifo_q.size() == depth) begin
                full = 1;
            end else begin
                full = 0;
            end
        end
        // sample covergroup
        fifo_write_cg.sample();
    end
    
endfunction


function void fifo_coverage::write_read(fifo_item t);
    read_item.enable = t.enable;
    //********************************//
    //********* Empty logic **********//
    //********************************//
    if(t.rst_op == 1) begin
        empty = 1;
    end else begin
    //********************************//
        if(t.enable) begin
            void'(fifo_q.pop_front());
            if(fifo_q.size() == 0) begin
                empty = 1;
            end else begin
                empty = 0;
            end
        end
        // sample covergroup
        fifo_read_cg.sample();
    end
endfunction