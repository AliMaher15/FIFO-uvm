module synchronizer #( 
    parameter ADDR_WIDTH = 4,
              NUM_OF_STAGES = 2 )
(
input   wire                    i_clk     ,
input   wire                    i_rst_n   ,
input   wire    [ADDR_WIDTH:0]  unsync_ptr,
output  reg     [ADDR_WIDTH:0]  sync_ptr
);

//internal connections
reg [(ADDR_WIDTH*(NUM_OF_STAGES-1)):0] meta_flops;

//////////////// Multi Flip Flop ////////////////
always @(posedge i_clk or negedge i_rst_n)
 begin
    if(!i_rst_n)
        begin
            {sync_ptr, meta_flops} <= 'b0 ;
        end
    else
        begin
            {sync_ptr, meta_flops} <= {meta_flops, unsync_ptr};
        end
 end

endmodule