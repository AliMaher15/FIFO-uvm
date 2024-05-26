module fifo_memory #(
                        parameter DATA_WIDTH = 8,
                                  ADDR_WIDTH = 4
                    )
(
// write clock domain
input  wire                    w_clk,
input  wire                    w_en,
input  wire  [DATA_WIDTH-1:0]  w_data,
input  wire  [ADDR_WIDTH-1:0]  w_addr,
input  wire                    w_full,
// read clock domain
input  wire  [ADDR_WIDTH-1:0]  r_addr,
output wire  [DATA_WIDTH-1:0]  r_data
);

localparam DEPTH = 1<<(ADDR_WIDTH);
reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

///////////// Write into the Memory //////////////
always @(posedge w_clk)
 begin
    if(w_en && !w_full)
     begin
        memory[w_addr] <= w_data ; 
     end
 end

///////////// Read from the Memory //////////////
assign r_data = memory[r_addr];

endmodule