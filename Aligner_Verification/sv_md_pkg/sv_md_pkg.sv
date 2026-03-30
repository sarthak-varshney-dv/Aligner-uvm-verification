`ifndef SV_MD_PKG_SV
 `define SV_MD_PKF_SV
 
 `include "sv_md_interface.sv"
 `include "uvm_macros.svh"

package sv_md_pkg ; 

import uvm_pkg::*;

`include "sv_md_agent_config.sv"
`include "sv_md_agent_config_master.sv"
`include "sv_md_agent_config_slave.sv"
`include "sv_md_item_base.sv"
`include "sv_md_item_drv.sv"
`include "sv_md_item_drv_master.sv"
`include "sv_md_item_mon.sv"
`include "sv_md_item_drv_slave.sv"

`include "sv_md_sequencer_base.sv"
`include "sv_md_sequencer_master_base.sv"
`include "sv_md_sequencer_master.sv"
//`include "sv_md_sequencer_slave_base.sv"
//`include "sv_md_sequencer_slave.sv"




`include "sv_md_driver_master.sv"
//`include "sv_md_driver_slave.sv"
`include "sv_md_driver.sv"

`include "sv_md_monitor.sv"


`include "sv_md_agent_master.sv"
`include "sv_md_agent_slave.sv"
`include "sv_md_agent.sv"
`include "sv_md_reset_handler.sv"

`include "sv_md_sequence_base.sv"
`include "sv_md_sequence_base_master.sv"
`include "sv_md_sequence_simple_master.sv"


 
endpackage
 `endif