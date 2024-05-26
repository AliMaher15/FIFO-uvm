interface fifo_if #(
                        parameter DATA_WIDTH = 8
                    )
(
    input clk,
    input res_n
);

// the interface will be generic
// and used in both read and write domains
// used twice, one for read and one for write

logic [DATA_WIDTH-1:0] data;
logic                  enable;
logic                  fifo_busy_flag;

//*****************************************************//
//***************** ASSERTIONS ************************//
//*****************************************************//
`define assert_clk(arg) \
  assert property (@(posedge clk) disable iff (!res_n) arg);

`define assert_async_rst(arg) \
  assert property (@(negedge res_n) 1'b1 |=> @(posedge clk) arg);
    
endinterface : fifo_if