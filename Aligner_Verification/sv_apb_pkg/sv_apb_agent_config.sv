`ifndef SV_APB_AGENT_CONGIG_SV
 `define SV_APB_AGENT_CONGIG_SV

class sv_apb_agent_config extends uvm_component;
  
  local sv_apb_vif vif;

  local uvm_active_passive_enum active_passive;

  local bit has_checks;
  
  `uvm_component_utils(sv_apb_agent_config)
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);

      active_passive = UVM_ACTIVE;
      has_checks=1;
   endfunction
  
 virtual function void set_vif(sv_apb_vif value);
    if(vif==null) begin
    vif=value;
    end
    else begin
      `uvm_fatal("ALGORITHM_ISSUE","trying to set interface more than once")
    end
  endfunction
  
  virtual function sv_apb_vif get_vif();
     return vif;
  endfunction

  virtual function uvm_active_passive_enum get_active_passive()
     return active_passive;
  endfunction

  virtual function void set_active_passive(uvm_active_passive_enum value);
     active_passive=value;
  endfunction

  virtual function void set_has_checks(bit value);
  has_checks=value;
  endfunction

  virtual function bit get_has_checks()
  return has_checks;
  endfunction
  
endclass

`endif