`ifndef SV_MD_SEQUENCER_MASTER_BASE_SV
 `define SV_MD_SEQUENCER_MASTER_BASE_SV

 class sv_md_sequencer_master_base extends sv_md_sequencer_base#(.REQ(sv_md_item_drv_master))  implements sv_md_reset_handler;

    
    `uvm_component_utils(sv_md_sequencer_master_base)

    function new(string name="", uvm_component parent);
     super.new(name,parent);
        
    endfunction 

 endclass 

 `endif
 