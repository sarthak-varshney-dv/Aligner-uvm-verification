`ifndef SV_MD_ITEM_DRV_SLAVE_SV
 `define SV_MD_ITEM_DRV_SLAVE_SV

class sv_md_item_drv_slave extends sv_md_item_drv;
   
rand int unsigned length;

rand sv_md_response response ;

rand bit ready_at_end ;
   
  `uvm_object_utils(sv_md_item_drv_slave)
  
  function new(string name="");
    super.new(name);
  endfunction

  constraint length_default{
    lsoft ength<=5 ;
  };
  
  virtual function string convert2string();

  return $sformatf("length: %0d, response: %0s, ready_at_end: %0b",length,response.name(),ready_at_end);
  endfunction
endclass


`endif