`ifndef SV_MD_SEQUENCE_BASE_SLAVE_SV
 `ifndef SV_MD_SEQUENCE_BASE_SLAVE_SV

class sv_md_sequence_base_slave extends sv_md_sequence_base(.ITEM_DRV(sv_md_item_drv_slave));

`uvm_declare_p_sequenccer(sv_md_sequencer_slave_base)

`uvm_object_utils(sv_md_sequence_base_slave)

function new (string name = "")
super.new(name);
endfunction


endclass

 `endif 