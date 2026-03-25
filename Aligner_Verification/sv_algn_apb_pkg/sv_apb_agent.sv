`ifndef SV_APB_AGENT_SV
 `define SV_APB_AGENT_SV

class sv_apb_agent extends uvm_agent;
  
  //handler of agent config
  sv_apb_agent_config agent_config;
  
  //interface handler
  sv_apb_vif vif;
  
  //sequencer handler
  sv_apb_sequencer sequencer;
  
  //driver handler
  sv_apb_driver driver;
  
  `uvm_component_utils(sv_apb_agent)
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agent_config = sv_apb_agent_config::type_id::create("agent_config",this);
    sequencer    = sv_apb_sequencer::type_id::create("sequencer",this)
    driver       = sv_apb_driver::type_id::create("driver",this)


  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if( uvm_config_db#(sv_apb_vif)::get(this,"","vif",vif) == 0 ) begin
      `uvm_fatal("APB_NO_VIF","interfacenot received from testbench");
    end
      else begin
        agent_config.set_vif(vif);
      end
 sequencer.seq_item_export.connect(driver.seq_item_port);
  driver.agent_config=agent_config;

  endfunction
  
endclass

`endif

