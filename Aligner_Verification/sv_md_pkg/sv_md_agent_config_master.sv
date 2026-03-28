`ifndef SV_MD_AGENT_CONFIG_MASTER_SV
 `define  SV_MD_AGENT_CONFIG_MASTER_SV

 class sv_md_agent_config_master#(int unsigned DATA_WIDTH = 32) extends sv_md_agent_config#(DATA_WIDTH) ;
   
   `uvm_component_param_utils(sv_md_agent_config_master#(DATA_WIDTH))

     function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
 endclass
`endif
