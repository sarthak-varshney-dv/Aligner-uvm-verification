`ifndef SV_MD_SEQUENCE_BASE_MASTER_SV
 `define SV_MD_SEQUENCE_BASE_MASTER_SV

 class sv_md_sequence_base_master extends sv_md_sequence_base(.ITEM_DRV(sv_md_item_drv_master));

 `uvm_declare_p_sequencer(sv_md_sequencer_master_base)

 `uvm_object_utils(sv_md_sequence_base_master)

 function new(string name = "")
 super.new(name);

 endfunction
 
 endclass
 `endif