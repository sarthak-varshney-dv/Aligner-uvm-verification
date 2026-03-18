`ifndef SV_ALGN_TEST_ILLEGAL_ACCESS_SV
 `define SV_ALGN_TEST_ILLEGAL_ACCESS_SV

class sv_algn_test_illegal_access extends sv_algn_test_base;
  
  `uvm_component_utils(sv_algn_test_illegal_access)
  
  function new(string name= "" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  
endclass

`endif