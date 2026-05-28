`ifndef SV_ALGN_SPLIT_INFO_SV
 `define SV_ALGN_SPLIT_INFO_SV

 class sv_algn_split_info extends uvm_object ;

   int unsigned ctrl_offset ;

   int unsigned ctrl_size ;

   int unsigned item_offset ;

   int unsigned item_size ;

   int unsigned num_bytes_needed ;

  
  `uvm_object_utils(sv_algn_split_info)

  function new(string name = "")
   super.new(name);

  endfunction


   
 endclass

 `endif