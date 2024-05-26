module fifo_top #(
                    parameter DATA_WIDTH = 8,
                              ADDR_WIDTH = 3
                )
(
// write clock domain
input  wire                  w_clk   ,
input  wire                  w_rst_n ,
input  wire                  w_en    ,
input  wire [DATA_WIDTH-1:0] w_data  ,
output wire                  w_full  ,
// read clock domain
input  wire                  r_clk   ,
input  wire                  r_rst_n ,
input  wire                  r_en    ,
output wire [DATA_WIDTH-1:0] r_data  ,
output wire                  r_empty  
);

// Internal connections
wire [ADDR_WIDTH-1:0] waddr, raddr;
wire [ADDR_WIDTH:0] wptr    , //out of ptr module
                    rptr    , ////
                    sync_wptr,  //out of sync
                    sync_rptr;  ////


///////////////////// FIFO Memory /////////////////////
fifo_memory #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))
fifomem_0 (
    .w_clk(w_clk)  ,
    .w_en(w_en)    ,
    .w_full(w_full),
    .w_data(w_data),
    .w_addr(waddr),
    .r_addr(raddr),
    .r_data(r_data)
);

///////////////////////////////////////////////////////
//////////////////// Write Domain /////////////////////
///////////////////////////////////////////////////////

/******* write pointer and full *******/
w_ptr_full #(.ADDR_WIDTH(ADDR_WIDTH))
w_ptr_full_0 (
    // inputs
    .w_clk(w_clk)     ,
    .w_rst_n(w_rst_n) ,
    .w_en(w_en)       ,
    .r_ptr(sync_rptr),
    // outputs
    .w_full(w_full)   ,
    .w_addr(waddr)   ,
    .w_ptr(wptr)
);

/******* write synchronizer *******/
synchronizer #(.ADDR_WIDTH(ADDR_WIDTH), .NUM_OF_STAGES(2))
w_sync_0 ( 
    .i_clk(w_clk)          ,
    .i_rst_n(w_rst_n)      ,
    .unsync_ptr(rptr)   ,
    .sync_ptr(sync_rptr)
);

     
///////////////////////////////////////////////////////
///////////////////// Read Domain /////////////////////
///////////////////////////////////////////////////////

/******* read counter *******/
r_ptr_empty #(.ADDR_WIDTH(ADDR_WIDTH)) 
r_ptr_empty_0 ( 
    // inputs
    .r_clk(r_clk)         ,
    .r_rst_n(r_rst_n)     ,
    .r_en(r_en)           ,
    .w_ptr(sync_wptr),
    // outputs
    .r_addr(raddr)     ,
    .r_empty(r_empty)  ,
    .r_ptr(rptr)
);


/******* read synchronizer *******/
synchronizer #(.ADDR_WIDTH(ADDR_WIDTH), .NUM_OF_STAGES(2))  
r_sync (
    .i_clk(r_clk)          , 
    .i_rst_n(r_rst_n)      ,
    .unsync_ptr(wptr)   ,   
    .sync_ptr(sync_wptr)
);


endmodule