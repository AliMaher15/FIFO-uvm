module r_ptr_empty #(
                    parameter ADDR_WIDTH = 4
                  )
(
input   wire                   r_clk  ,
input   wire                   r_rst_n,
input   wire                   r_en   ,
input   wire  [ADDR_WIDTH:0]   w_ptr , // synchronized    
output  wire  [ADDR_WIDTH-1:0] r_addr , // binary
output  reg   [ADDR_WIDTH:0]   r_ptr,
output  reg                    r_empty
);

reg  [ADDR_WIDTH:0] r_bin;
wire [ADDR_WIDTH:0] r_gray_next, r_bin_next;

always@(posedge r_clk or negedge r_rst_n) begin
    if(!r_rst_n) begin
        r_bin <= 'b0;
        r_ptr <= 'b0;
    end else begin
        r_bin <= r_bin_next;
        r_ptr <= r_gray_next;
    end
end
// memory address in binary
assign r_addr = r_bin[ADDR_WIDTH-1:0];

// next count
assign r_bin_next = r_bin + (r_en & ~r_empty);
// convert to gray (style#2)
assign r_gray_next = (r_bin_next>>1) ^ r_bin_next;

/****** Empty flag ******/
// FIFO is full when both pointers are equal
always@(posedge r_clk or negedge r_rst_n) begin
    if(!r_rst_n) begin
        r_empty <= 1'b1;
    end else begin
        r_empty <= (r_gray_next == w_ptr);
    end 
end

endmodule