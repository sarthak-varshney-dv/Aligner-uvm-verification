`ifndef SV_APB_SEQUENCE_BASE_SV
 `define SV_APB_SEQUENCE_BASE_SV

class sv_apb_sequence_base extends uvm_sequence#(.REQ(sv_apb_item_drv));

`uvm_declare_p_sequencer(sv_apb_sequencer)

`uvm_object_utils(sv_apb_sequence_base)

function new(string name="");
super.new(name);

endfunction
    
endclass


`endif