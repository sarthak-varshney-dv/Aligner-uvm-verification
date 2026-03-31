`ifndef SV_MD_SEQUENCE_SLAVE_RESPONSE_SV
 `ifndef SV_MD_SEQUENCE_SLAVE_RESPONSE_SV

class sv_md_sequence_slave_response extends sv_md_sequence_base_slave;

`uvm_object_utils(sv_md_sequence_slave_response)

function new (string name = "")
super.new(name);

endfunction

virtual task body();
sv_md_item_mon item_mon ;

p_sequencer.pending_items.get(item_mon);

begin
  sv_md_sequence_simple_slave seq_simple ;

  `uvm_do_with(seq_simple, { 
   // item_mon.data[0] == 'h85 -> seq.item.response == SV_MD_ERR ;
    // item_mon.data[0] != 'h85 -> seq.item.response == SV_MD_OKAY;

  })     //sending an error response for data =85.rest responses are okay.

end



endtask



endclass

 `endif 