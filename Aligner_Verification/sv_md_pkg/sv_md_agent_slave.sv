`ifndef SV_MD_AGENT_SLAVE_SV
 `define SV_MD_AGENT_SLAVE_SV

 class sv_md_agent_slave(int unsigned DATA_WIDTH = 32) extends sv_md_agent#(.DATA_WIDTH(DATA_WIDTH), .ITEM_DRV(sv_md_item_drv_slave)) implements sv_md_reset_handler;

  //handler of agent config
  sv_md_agent_config_slave#(DATA_WIDTH) agent_config;

  `uvm_component_param_utils(sv_md_agent_slave#(DATA_WIDTH))
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
      //overriding base with master config in constructor .
      agent_config = sv_md_agent_config#(DATA_WIDTH)::type_id::
                    set_inst_override(sv_md_agent_config_slave#(DATA_WIDTH)::get_type(),"agent_config",this);
                     
   endfunction
  

 endclass
  `endif