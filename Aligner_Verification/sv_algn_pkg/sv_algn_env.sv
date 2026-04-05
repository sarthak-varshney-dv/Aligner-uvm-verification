`ifndef SV_ALGN_ENV_SV
 `define SV_ALGN_ENV_SV

class sv_algn_env extends uvm_env;
  
  sv_apb_agent apb_agent;

  sv_md_agent_master#(32) md_rx_agent;

  sv_md_agent_slave#(32) md_tx_agent;

  sv_algn_reg_predictor#(sv_apb_item_mon) predictor ;
  
  `uvm_component_utils(sv_algn_env)
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    apb_agent=   sv_apb_agent::type_id::create("apb_agent",this);

    md_rx_agent= sv_md_agent_master#(32)::type_id::create("md_rx_agent",this);
    md_tx_agent= sv_md_agent_slave#(32)::type_id::create("md_tx_agent",this);

    predictor = sv_algn_reg_predictor#(sv_apb_item_mon)::type_id::create("predictor",this);
    
  endfunction

  virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  sv_apb_reg_adapter adapter= sv_apb_reg_adapter::type_id::create("adapter");;

  predictor.adapter = adapter;

  predictor.map = model.reg_block.default_map ;

  apb_agent.output_port.connect(predictor.bus_in);


  endfunction
  
endclass

`endif
