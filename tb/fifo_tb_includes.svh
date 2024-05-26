parameter DATA_WIDTH      = 8;
parameter ADDR_WIDTH      = 3;
parameter FAST_CLK_PERIOD = 20;
parameter SLOW_CLK_PERIOD = 100;

typedef virtual fifo_if#(.DATA_WIDTH(DATA_WIDTH)) fifo_if_t;
`include "fifo_item/fifo_item.svh"

`include "fifo_r_agent/fifo_r_agent_cfg.svh"
typedef fifo_r_agent_cfg#(.DATA_WIDTH(DATA_WIDTH)) fifo_r_agent_cfg_t;
`include "fifo_r_agent/fifo_r_monitor.svh"
`include "fifo_r_agent/fifo_r_agent_seqr.svh"
`include "fifo_r_agent/fifo_r_driver.svh"
`include "fifo_r_agent/fifo_r_agent.svh"
typedef fifo_r_agent#(.DATA_WIDTH(DATA_WIDTH)) fifo_r_agent_t;

`include "fifo_w_agent/fifo_w_agent_cfg.svh"
typedef fifo_w_agent_cfg#(.DATA_WIDTH(DATA_WIDTH)) fifo_w_agent_cfg_t;
`include "fifo_w_agent/fifo_w_monitor.svh"
`include "fifo_w_agent/fifo_w_agent_seqr.svh"
`include "fifo_w_agent/fifo_w_driver.svh"
`include "fifo_w_agent/fifo_w_agent.svh"
typedef fifo_w_agent#(.DATA_WIDTH(DATA_WIDTH)) fifo_w_agent_t;

`include "rst_driver_c.svh"

`include "fifo_checkers/fifo_coverage.svh"
`include "fifo_checkers/fifo_sb_r_comparator.svh"
`include "fifo_checkers/fifo_sb_w_comparator.svh"
`include "fifo_checkers/fifo_sb_predictor.svh"
`include "fifo_checkers/fifo_scoreboard.svh"

`include "fifo_env_cfg.svh"
`include "fifo_vsequencer.svh"	
`include "fifo_env.svh"    

`include "seq_lib/fifo_rand_seq.svh"
`include "seq_lib/fifo_vseq_base.svh"
`include "seq_lib/fifo_rand_vseq.svh"  

`include "test_lib/fifo_base_test.svh"    
`include "test_lib/fifo_rand_test.svh"

`include "test_lib/active_reset_test.svh"
`include "test_lib/idle_reset_test.svh"