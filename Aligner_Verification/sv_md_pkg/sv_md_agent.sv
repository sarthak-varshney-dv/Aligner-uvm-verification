`ifndef SV_MD_AGENT_SV
 `define SV_MD_AGENT_SV

class sv_md_agent(int unsigned DATA_WIDTH = 32 , type ITEM_DRV = sv_md_item_drv) extends uvm_agent implements sv_md_reset_handler;
  
   typedef virtual sv_md_if#(DATA_WIDTH) sv_md_vif ;

  //handler of agent config
  sv_md_agent_config#(DATA_WIDTH) agent_config;
  
  //interface handler
  sv_md_vif vif;
  
  sv_md_sequencer_base#(ITEM_DRV) sequencer;

  `uvm_component_param_utils(sv_md_agent#(DATA_WIDTH))
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agent_config = sv_md_agent_config#(DATA_WIDTH)::type_id::create("agent_config",this);

  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if( uvm_config_db#(sv_md_vif)::get(this,"","vif",vif) == 0 ) begin
      `uvm_fatal("MD_NO_VIF","interface not received from testbench");
    end
      else begin
        agent_config.set_vif(vif);
      end
  endfunction
  
virtual function void handle_reset(uvm_phase phase) 

 uvm_component children[$];

 get_children(children);

  sv_md_reset_handler handler;
  foreach(children[idx]) begin
    if($cast(handler,children[idx])) begin
      handler.handle_reset();
    end
  end
endfunction

  virtual task wait_reset_start()  //Asynchronous reset 
    agent_config.wait_reset_start();
  endtask

  virtual task wait_reset_end() //synchronous
    agent_config.wait_reset_end();
  
  endtask

virtual task run_phase(uvm_phase phase)
forever begin

  wait_reset_start();
  handle_reset();
  wait_reset_end();

end
endtask
endclass

`endif

