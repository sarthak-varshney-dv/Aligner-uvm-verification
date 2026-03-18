`ifndef SV_ALGN_ENV_SV
 `define SV_ALGN_ENV_SV

class sv_algn_env extends uvm_env;
  
  sv_apb_agent apb_agent;
  
  `uvm_component_utils(sv_algn_env)
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    apb_agent=sv_apb_agent::type_id::create("apb_agent",this);
    
  endfunction
  
endclass

`endif
