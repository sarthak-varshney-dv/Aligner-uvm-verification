`ifndef SV_APB_SEQUENCE_SIMPLE_SV
 `define SV_APB_SEQUENCE_SIMPLE_SV

class sv_apb_sequence_simple extends sv_apb_sequence_base;

rand sv_apb_item_drv item ;
`uvm_object_utils(sv_apb_sequence_simple)

function new(string name="");
super.new(name);

 item= sv_apb_item_drv::type_id::create("item");
 
endfunction

task body();


`uvm_send(item)

endtask

endclass


`endif