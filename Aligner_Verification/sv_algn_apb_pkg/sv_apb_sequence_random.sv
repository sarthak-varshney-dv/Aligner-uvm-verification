`ifndef SV_APB_SEQUENCE_RANDOM_SV
 `define SV_APB_SEQUENCE_RANDOM_SV

class sv_apb_sequence_random extends sv_apb_sequence_base;

rand int unsigned num_items;

constraint num_items_default{
    soft num_items inside {[1:10]};
}

`uvm_object_utils(sv_apb_sequence_simple)

function new(string name="");
super.new(name);

 item= sv_apb_item_drv::type_id::create("item");
 
endfunction

task body();
for(int i=0;i<num_items;i++) begin
    sv_apb_sequence_simple seq = sv_apb_sequence_simple::type_id::create("seq");

    `uvm_send(seq)
end

endtask

endclass


`endif