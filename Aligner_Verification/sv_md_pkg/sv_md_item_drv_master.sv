`ifndef SV_MD_ITEM_DRV_MASTER_SV
 `define SV_MD_ITEM_DRV_MASTER_SV

class sv_md_item_drv_master extends sv_md_item_drv;
  
  rand bit[7:0] data[$] ;

  rand int unsigned offset ;

  rand int unsigned pre_drive_delay ;

  rand int unsigned post_drive_delay ;

  constraint pre_drive_delay_default{
    soft pre_drive_delay<=5;
  }

  constraint post_drive_delay_default{
    soft post_drive_delay<=5;
  }
   
  `uvm_object_utils(sv_md_item_drv_master)
  
  function new(string name="");
    super.new(name);
  endfunction

  virtual function string convert2string()
   
   string data_as_string = "{"
     
   foreach(data[idx]) begin
     data_as_string = $sformatf(%0s'h%02x%0s,data_as_string,data[idx],idx==data.size()?"":",");
   end

   data_as_string =  $sformatf("%0s}", data_as_string);

    return $sformatf("data: %0s, offset: %0d, pre_drive_delay: %0d, post_drive_delay: %0d", data_as_string, offset, pre_drive_delay, post_drive_delay);



  endfunction
  
endclass


`endif