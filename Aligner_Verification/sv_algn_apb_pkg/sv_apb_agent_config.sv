`ifndef SV_APB_AGENT_CONGIG_SV
 `define SV_APB_AGENT_CONGIG_SV

class sv_apb_agent_config extends uvm_component;
  
  local sv_apb_vif vif;
  
  `uvm_component_utils(sv_apb_agent_config)
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
 virtual function void set_vif(sv_apb_vif value);
    if(vif==null) begin
    vif=value;
    end
    else 
      `uvm_fatal("ALGORITHM_ISSUE","trying to set interface more than once")
  endfunction
  
  virtual function sv_apb_vif get_vif();
     return vif;
  endfunction
endclass

`endif