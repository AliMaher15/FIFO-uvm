class fifo_item extends uvm_sequence_item;
    `uvm_object_utils(fifo_item)

    // Variables
    rand logic [DATA_WIDTH-1:0] data; // w_data || r_data
    rand logic enable;                // w_en   || r_en
    rand logic fifo_busy_flag;        // full   || empty
    // control
    bit rst_op = 0;
    time timestamp;
    bit [1<<ADDR_WIDTH:0] fifo_used_size;
    

    //  Group: Functions

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new

    
    extern virtual function void do_print(uvm_printer printer);
    extern virtual function void do_copy(uvm_object rhs);
    
endclass: fifo_item

function void fifo_item::do_print(uvm_printer printer);
    printer.print_field (.name("data"), .value(data), .size($bits(data)), .radix(UVM_HEX));
    printer.print_field ("enable", enable, 1, UVM_BIN);
    printer.print_field ("fifo_busy_flag", fifo_busy_flag, 1, UVM_BIN);
    printer.print_field ("rst_op", rst_op, 1, UVM_BIN);
    printer.print_field ("fifo_size", fifo_used_size, $bits(fifo_used_size), UVM_DEC);
    printer.print_time  ("TIME", timestamp);
endfunction


function void fifo_item::do_copy(uvm_object rhs);
    fifo_item _item;
    $cast(_item, rhs);
    data = _item.data;
    enable = _item.enable;
    fifo_busy_flag = _item.fifo_busy_flag;
    rst_op = _item.rst_op;
    fifo_used_size = _item.fifo_used_size;
    timestamp = _item.timestamp;
endfunction