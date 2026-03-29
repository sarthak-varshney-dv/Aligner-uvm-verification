`ifndef SV_MD_SEQUENCE_BASE_SV
 `define SV_MD_SEQUENCE_BASE_SV

 class sv_md_sequence_base(type ITEM_DRV = sv_md_item_drv ) extends uvm_sequence(.REQ(ITEM_DRV));

 `uvm_object_param_utils(sv_md_sequence_base(ITEM_DRV))

 function new(string name = "")
 super.new(name);

 endfunction
 
 endclass
 `endif