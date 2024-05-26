`timescale 1ns/1ns

`include "rst_intf.sv"
`include "fifo_if.sv"

module fifo_tb_top();

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "fifo_tb_includes.svh"

logic w_clk, r_clk;

//************** INTERFACES INSTANTS ****************//
rst_intf rst_i ();

fifo_if #(.DATA_WIDTH(DATA_WIDTH)) 
write_if (.clk(w_clk), .res_n(rst_i.res_n));

fifo_if #(.DATA_WIDTH(DATA_WIDTH)) 
read_if (.clk(r_clk), .res_n(rst_i.res_n));
//***************************************************//

//**************** DUT INSTANTS *********************//
fifo_top #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))
dut (// write clock domain
     .w_clk(w_clk),
     .w_rst_n(rst_i.res_n),
     .w_en(write_if.enable),
     .w_data(write_if.data),
     .w_full(write_if.fifo_busy_flag),
     // read clock domain
     .r_clk(r_clk),
     .r_rst_n(rst_i.res_n),
     .r_en(read_if.enable),
     .r_data(read_if.data),
     .r_empty(read_if.fifo_busy_flag)
     );
//***************** START TEST **********************//
// pass the interfaces handles then run the test
initial begin
    
    //            interface type                        access hierarchy            instance name
    uvm_resource_db#(virtual rst_intf)::set("rst_intf", "rst_i", rst_i);

    uvm_config_db#(virtual fifo_if#(DATA_WIDTH))::set(null, "uvm_test_top", "write_if", write_if);
    uvm_config_db#(virtual fifo_if#(DATA_WIDTH))::set(null, "uvm_test_top", "read_if", read_if);

    run_test();
end
//***************************************************// 

//***************** CLOCK ***************************//
initial begin
    w_clk = 0;
    forever begin
        #(FAST_CLK_PERIOD/2);  w_clk = ~w_clk;
    end
end
initial begin
    r_clk = 0;
    forever begin
        #(SLOW_CLK_PERIOD/2);  r_clk = ~r_clk;    
    end
end
//***************************************************// 

endmodule : fifo_tb_top