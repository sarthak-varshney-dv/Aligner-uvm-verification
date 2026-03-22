`ifndef SV_APB_ITEM_BASE_SV
 `define SV_APB_ITEM_BASE_SV

class sv_apb_item_base extends uvm_sequence_item;
  
  
rand sv_apb_data data;

rand sv_apb_addr addr;

rand sv_apb_dir dir;
  
  
  `uvm_object_utils(sv_apb_item_base)
  
  function new(string name="");
    super.new(name);
  endfunction
  
  virtual function string convert2string();
    string result = $sformatf("dir: %0s , ADDR: %0x",dir.name(), addr);
    
    return result;
  endfunction
endclass




`endif