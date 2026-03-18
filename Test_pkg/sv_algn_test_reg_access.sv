`ifndef SV_ALGN_TEST_BASE_SV
 `define SV_ALGN_TEST_BASE_SV

class sv_algn_test_base extends uvm_test;
  
  // Environment handler
   sv_algn_env env ;
  `uvm_component_utils(sv_algn_test_base)
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env = sv_algn_env::type_id::create("env",this);
    
   endfunction
    
  
  
endclass

`endif
