`ifndef SV_ALGN_TEST_RANDOM_SV
 `define SV_ALGN_TEST_RANDOM_SV

class sv_algn_test_random extends sv_algn_test_base;
  
  `uvm_component_utils(sv_algn_test_random)
  
  function new(string name= "" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  
endclass

`endif