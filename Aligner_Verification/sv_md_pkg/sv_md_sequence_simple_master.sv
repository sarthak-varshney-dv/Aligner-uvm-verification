`ifndef SV_MD_SEQUENCE_SIMPLE_MASTER_SV
 `define SV_MD_SEQUENCE_SIMPLE_MASTER_SV

 class sv_md_sequence_simple_master extends sv_md_sequence_base_master);

 rand sv_md_item_drv_master item;

 constraint legal_values_default{

    item.data.size() >0 ;

    item.data.size() <= (p_sequencer.get_data_width()/8);

    item.offset  < (p_sequencer.get_data_width()/8);

    item.data.size() + item.offset <=  (p_sequencer.get_data_width()/8);


 }
 
 `uvm_object_utils(sv_md_sequence_simple_master)

 function new(string name = "")
 super.new(name);
 
 item= sv_md_item_drv_master::type_id::create("item");
 endfunction
 
 virtual task body();
 `uvm_send(item)
 endtask

 endclass
 `endif