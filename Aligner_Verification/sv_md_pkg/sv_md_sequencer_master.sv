`ifndef SV_MD_SEQUENCER_MASTER_SV
 `define SV_MD_SEQUENCER_MASTER_SV

 class sv_md_sequencer_master(int unsigned DATA_WIDTH=32) extends sv_md_sequencer_master_base  implements sv_md_reset_handler;

    
    `uvm_component_param_utils(sv_md_sequencer_master#(DATA_WIDTH))

    function new(string name="", uvm_component parent);
     super.new(name,parent);
        
    endfunction 

    virtual function int unsigned get_data_width()
    return DATA_WIDTH ;
    endfunction

 endclass 

 `endif
 