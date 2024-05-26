`timescale 1ns / 1ps

module fifo_tb();
// data width = 8, memory depth = 2^(4-1), addr width = 4

////////////////////////////////////////////////////////
////////////          TB Signals           /////////////
////////////////////////////////////////////////////////

// Inputs
reg             write_clk   ;
reg             write_rst_n ;
reg             write_en    ;
reg   [7:0]     write_data  ;

reg             read_clk   ;
reg             read_rst_n ;
reg             read_en    ;

// Outputs
wire            w_full     ;
wire  [7:0]     read_data  ;
wire            r_empty    ;

////////////////////////////////////////////////////////
/////////////     DUT Instantiation        /////////////
////////////////////////////////////////////////////////

beh_fifo dut (
.wclk(write_clk)    , 
.wrst_n(write_rst_n), 
.winc(write_en)    , 
.wdata(write_data) ,  
.rclk(read_clk)    , 
.rrst_n(read_rst_n), 
.rinc(read_en)     , 
.rdata(read_data)  ,
.wfull(w_full),  
.rempty(r_empty)
);

////////////////////////////////////////////////////////
////////////       Clock Generator         /////////////
////////////////////////////////////////////////////////

// Write Clock Generator
always #10 write_clk = ~write_clk ;

// Read Clock Generator
always #50 read_clk = ~read_clk ;

////////////////////////////////////////////////////////
////////////            INITIAL             ////////////
////////////////////////////////////////////////////////

initial 
 begin

// Initialize Inputs
write_clk   = 1'b0 ;
read_clk    = 1'b0 ;
write_rst_n = 1'b0 ;    // reset 
read_rst_n  = 1'b0 ;    // is activated
write_data  = 8'd0;
write_en    = 1'b0 ;
read_en     = 1'b0 ;

#20;        
write_rst_n = 1'b0 ;    // reset 
read_rst_n  = 1'b0 ;    // is de-activated

#20;
write_rst_n = 1'b1 ;    // reset 
read_rst_n  = 1'b1 ;    // is deactivated

write_data = 8'd1 ;
write_en   = 1'b1 ;

#20;
write_data = 8'd2 ;

#20;
write_data = 8'd3 ;

#20;
write_data = 8'd4 ;

#20;
write_data = 8'd5 ;
read_en = 1'b1 ;

#20;
write_data = 8'd6 ;

#20;
write_data = 8'd7 ;

#20;
write_en = 1'b0;

#60;
write_en = 1'b1 ;
write_data = 8'd9 ;

#20;
write_data = 8'd10 ;

#20;
write_data = 8'd11;

#20;
write_data = 8'd12 ;

#20;
write_data = 8'd13 ;
 
#20;
write_data = 8'd14 ;
 
#20;
write_data = 8'd15 ;

#20;
write_data = 8'd16;
 
#20;
write_data = 8'd17 ;
  
#20;
write_data = 8'd18 ;
  
#20;
write_data = 8'd19 ;
  
#20;
write_data = 8'd20 ;

#20;
read_en = 1'b0;
  
#20;
write_data = 8'd21 ;
  
#20;
write_data = 8'd22 ;
  
#20;
write_data = 8'd23 ;
  
#20;
write_data = 8'd24 ;
  
#20;
write_data = 8'd25 ;
  
#200;
read_en = 1'b1 ;
 
#500;
$stop();

end 

endmodule