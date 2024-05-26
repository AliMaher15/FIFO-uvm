class fifo_rand_seq extends uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(fifo_rand_seq);

    fifo_item rand_item;
    bit enable_off;

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new

    extern virtual task body();
    
endclass: fifo_rand_seq


task fifo_rand_seq::body();
    rand_item = fifo_item::type_id::create("rand_item");
    //communicate with driver
    start_item(rand_item);
    // randomize
    if(enable_off) begin
        Randomize_fifo_item_enable_off: assert (rand_item.randomize() with {enable == 0;});
    end else begin
        Randomize_fifo_item: assert (rand_item.randomize() with {});
    end
    
    finish_item(rand_item);
endtask