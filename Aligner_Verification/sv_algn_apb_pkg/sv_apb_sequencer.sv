`ifndef SV_APB_SEQUENCER_BASE_SV
 `define SV_APB_SEQUENCER_BASE_SV

 class sv_apb_sequencer extends uvm_sequencer#(.REQ(sv_apb_item_drv));
    
    `uvm_component_utils(sv_apb_sequencer)

    function new(string name="", uvm_component parent);
     super.new(name,parent);
        
    endfunction 
 endclass 

 endif