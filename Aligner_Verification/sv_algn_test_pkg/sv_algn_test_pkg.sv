`ifndef SV_ALGN_TEST_PKG_SV
 `define SV_ALGN_TEST_PKG_SV

`include "uvm_macros.svh"
`include "sv_algn_pkg.sv"

package sv_algn_test_pkg;

 import uvm_pkg::*;
 import sv_algn_pkg::*;
 import sv_apb_pkg::*;
 

 `include "sv_algn_test_base.sv"
 `include "sv_algn_test_reg_access.sv"
 `include "sv_algn_test_random.sv"
 `include "sv_algn_test_illegal_access.sv"
 


endpackage



`endif