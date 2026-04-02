`ifndef SV_MD_DRIVER_SLAVE_SV
 `define SV_MD_DRIVER_SLAVE_SV

class sv_md_driver_slave#(int unsigned DATA_WIDTH = 32) extends sv_md_driver#(.DATA_WIDTH(DATA_WIDTH),.ITEM_DRV(sv_md_item_drv_master))) implements sv_md_reset_handler;

   typedef virtual sv_md_if#(DATA_WIDTH) sv_md_vif ;

   sv_md_agent_config_slave#(DATA_WIDTH) agent_config;   //handler(to access ready_at_reset) to be casted by base agent config handler
 
    `uvm_component_param_utils(sv_md_driver_slave#(DATA_WIDTH))

function new(string name="",uvm_component parent);
      super.new(name,parent);
endfunction    
    
virtual function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);

  if(super.agent_config == null) begin
    `uvm_fatal("ALGORITHM_ISSUE",$sformatf("At this point the pointer to agent_config from %0s should not be null",get_full_name()))
  end
  if($cast(agent_config,super.agent_config)==0) begin
    `uvm_fatal("ALGORITHM_ISSUE","could not cast agent_config handlers in driver slave")
  end
endfunction


protected virtual task drive_transaction(sv_md_item_drv_slave item);
  sv_apb_vif = agent_config.get_vif();
  
  `uvm_info("DEBUG",$sformatf("Driving \"%0s\" : %0s",item.get_full_name(),item.convert2string(),UVM_NONE))

  // A check
  if(vif.valid !==1)begin
   `uvm_error("ALGORITHM_ISSUE",$sformatf("Trying to drive slave item when no item started by master - item:  %0s."
                     item.convert2string ())) 
  end

  vif.ready<=0;

  for(int i=0;i<length;i++) begin
     @(posedge vif.clk);
  end

  ready =1 ;
  vif.err<=bit'(item.response);

  @(posedge vif.clk);

  vif.ready <= item.ready_at_end ; 
  vif.err   <=0 ;
  

endtask 

virtual function void handle_reset(uvm_phase phase);

  sv_apb_vif = agent_config.get_vif();

  super.handle_reset(phase);

 vif.ready<=agent_config.getready_at_reset;
 vif.err<=0 ;

endfunction

endclass
`endif 