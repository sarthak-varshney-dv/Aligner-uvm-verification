`ifndef SV_MD_SEQUENCE_SIMPLE_SLAVE_SV
 `ifndef SV_MD_SEQUENCE_SIMPLE_SLAVE_SV

class sv_md_sequence_simple_slave extends sv_md_sequence_base_slave;

rand sv_md_item_drv_slave item;

`uvm_object_utils(sv_md_sequence_simple_slave)

function new (string name = "")
super.new(name);

item = sv_md_item_drv_slave::type_id::create("item");
endfunction

virtual task body();

`uvm_send(item) 

endtask



endclass

 `endif 