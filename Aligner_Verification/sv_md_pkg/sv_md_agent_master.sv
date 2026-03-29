`ifndef SV_MD_AGENT_MASTER_SV
 `define SV_MD_AGENT_MASTER_SV

 class sv_md_agent_master(int unsigned DATA_WIDTH = 32) extends sv_md_agent#(.DATA_WIDTH(DATA_WIDTH), .ITEM_DRV(sv_md_item_drv_master)) implements sv_md_reset_handler;

  

  `uvm_component_param_utils(sv_md_agent_master#(DATA_WIDTH))
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
      //overriding base with master config in constructor .
     sv_md_agent_config#(DATA_WIDTH)::type_id::
         set_inst_override(sv_md_agent_config_master#(DATA_WIDTH)::get_type(),"agent_config",this);

     sv_md_sequencer_base#(ITEM_DRV)::type_id::
         set_inst_override(sv_md_sequencer_master#(DATA_WIDTH)::get_type(),"sequencer",this);
                                    
   endfunction
  

 endclass
  `endif 