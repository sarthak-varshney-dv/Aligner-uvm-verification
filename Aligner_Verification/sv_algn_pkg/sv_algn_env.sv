`ifndef SV_ALGN_ENV_SV
 `define SV_ALGN_ENV_SV

class sv_algn_env extends uvm_env;
  
  sv_apb_agent apb_agent;

  sv_md_agent_master#(32) md_rx_agent;

  sv_md_agent_slave#(32) md_tx_agent;
  
  `uvm_component_utils(sv_algn_env)
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    apb_agent=   sv_apb_agent::type_id::create("apb_agent",this);

    md_rx_agent= sv_md_agent_master#(32)::type_id::create("md_rx_agent",this);
    md_tx_agent= sv_md_agent_slave#(32)::type_id::create("md_tx_agent",this);
    
  endfunction

  virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  

  endfunction
  
endclass

`endif
