`ifndef SV_ALGN_REG_PKG_SV
 `define SV_ALGN_REG_PKG_SV

`include "uvm_macros.svh"


package sv_algn_reg_pkg;

 import uvm_pkg::*;


 `include "sv_algn_reg_ctrl.sv"
 `include "sv_algn_reg_status.sv"
 `include "sv_algn_reg_irqen.sv"
 `include "sv_algn_reg_irq.sv"


endpackage



`endif