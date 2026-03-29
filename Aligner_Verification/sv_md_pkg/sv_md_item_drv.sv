`ifndef SV_MD_ITEM_DRV_SV
 `define SV_MD_ITEM_DRV_SV

class sv_md_item_drv extends sv_md_item_base;
  
   
  `uvm_object_utils(sv_md_item_drv)
  
  function new(string name="");
    super.new(name);
  endfunction
  
endclass


`endif