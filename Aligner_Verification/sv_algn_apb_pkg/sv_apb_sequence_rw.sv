`ifndef SV_APB_SEQUENCE_RW_SV
 `define SV_APB_SEQUENCE_RW_SV

class sv_apb_sequence_rw extends sv_apb_sequence_base;

rand sv_apb_data data;

rand sv_apb_addr addr;

`uvm_object_utils(sv_apb_sequence_rw)

function new(string name="");
super.new(name);

endfunction

task body()

sv_apb_item_drv item; //since uvm_do , no need to instantiate.

`uvm_do_with (item,{
    item.dir == sv_apb_read;
    item.addr== local::addr;
});

`uvm_do_with (item,{
    item.dir  == sv_apb_write;
    item.addr == local::addr;
    item.data == local::data;
});

endtask
endclass


`endif