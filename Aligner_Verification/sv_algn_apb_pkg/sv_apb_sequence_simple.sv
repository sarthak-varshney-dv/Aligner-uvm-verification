`ifndef SV_APB_SEQUENCE_SIMPLE_SV
 `define SV_APB_SEQUENCE_SIMPLE_SV

class sv_apb_sequence_simple extends sv_apb_sequence_base;


`uvm_object_utils(sv_apb_sequence_simple)

function new(string name="");
super.new(name);

endfunction


endclass


`endif