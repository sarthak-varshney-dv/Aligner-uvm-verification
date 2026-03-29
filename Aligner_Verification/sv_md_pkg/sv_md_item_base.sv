`ifndef SV_MD_ITEM_BASE_SV
 `define SV_MD_ITEM_BASE_SV

class sv_md_item_base extends uvm_sequence_item;
  
   
  `uvm_object_utils(sv_md_item_base)
  
  function new(string name="");
    super.new(name);
  endfunction
  
endclass


`endif