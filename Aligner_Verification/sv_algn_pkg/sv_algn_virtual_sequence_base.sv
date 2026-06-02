`ifndef SV_ALGN_VIRTUAL_SEQUENCE_BASE_SV
 `define SV_ALGN_VIRTUAL_SEQUENCE_BASE_SV

 class sv_algn_virtual_sequence_base extends uvm_sequence ;

 `uvm_declare_p_sequencer(sv_algn_virtual_sequencer);
  
  `uvm_object_utils(sv_algn_virtual_sequence_base);

  function new(string name = "");
   super.new(name);
  endfunction

   
 endclass


 `endif