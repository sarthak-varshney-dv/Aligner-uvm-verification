`ifndef SV_MD_AGENT_CONFIG_SLAVE_SV
 `define  SV_MD_AGENT_CONFIG_SLAVE_SV

 class sv_md_agent_config_slave#(int unsigned DATA_WIDTH = 32) extends sv_md_agent_config#(DATA_WIDTH) ;
   
   local bit ready_at_reset ;

   `uvm_component_param_utils(sv_md_agent_config_slave#(DATA_WIDTH))

     function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
      ready_at_reset=1;
      
   endfunction

   virtual function bit get_ready_at_reset();
   return ready_at_reset ;
   endfunction

   virtual function void set_ready_at_reset(bit value);
   ready_at_reset=value;
   endfunction

 endclass
`endif
