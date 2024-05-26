module w_ptr_full #(
                        parameter ADDR_WIDTH = 4
                    )
(
input   wire                   w_clk  ,
input   wire                   w_rst_n,
input   wire                   w_en   ,
input   wire  [ADDR_WIDTH:0]   r_ptr, // synchronized
output  wire  [ADDR_WIDTH-1:0] w_addr, // binary
output  reg   [ADDR_WIDTH:0]   w_ptr,
output  reg                    w_full                     
);

reg  [ADDR_WIDTH:0] w_bin;
wire [ADDR_WIDTH:0] w_gray_next, w_bin_next;

always@(posedge w_clk or negedge w_rst_n) begin
    if(!w_rst_n) begin
        w_bin <= 'b0;
        w_ptr <= 'b0;
    end else begin
        w_bin <= w_bin_next;
        w_ptr <= w_gray_next;
    end
end

// memory address in binary
assign w_addr = w_bin[ADDR_WIDTH-1:0];

// next count
assign w_bin_next = w_bin + (w_en & ~w_full);
// convert to gray (style#2)
assign w_gray_next = (w_bin_next>>1) ^ w_bin_next;

// FIFO is full when both pointers are equal
// except the MSBs are different

//-----------------------------------------------------------------  
// Simplified version of the three necessary full-tests:
// assign wfull_val=((wgnext[ADDRSIZE]    != rptr[ADDRSIZE]  ) &&
//                   (wgnext[ADDRSIZE-1]  != rptr[ADDRSIZE-1]) &&
//                   (wgnext[ADDRSIZE-2:0]== rptr[ADDRSIZE-2:0]));  
//----------------------------------------------------------------- 
always@(posedge w_clk or negedge w_rst_n)
 begin
  if(!w_rst_n)
    begin
        w_full <= 1'b0;
    end
  else
    begin
        w_full <= (w_gray_next == {~r_ptr[ADDR_WIDTH:ADDR_WIDTH-1], r_ptr[ADDR_WIDTH-2:0]});
    end
 end
               
endmodule