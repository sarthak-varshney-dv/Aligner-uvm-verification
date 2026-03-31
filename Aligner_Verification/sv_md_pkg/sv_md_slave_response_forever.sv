`ifndef SV_MD_SEQUENCE_SLAVE_RESPONSE_FOREVER_SV
 `ifndef SV_MD_SEQUENCE_SLAVE_RESPONSE_FOREVER_SV

class sv_md_sequence_slave_response_forever extends sv_md_sequence_base_slave;

`uvm_object_utils(sv_md_sequence_slave_response_forever)

function new (string name = "")
super.new(name);

endfunction

virtual task body();

forever begin
    
begin
  sv_md_sequence_simple_slave_response seq_response ;

  `uvm_do_on(seq_response , p_sequencer)
    
  
end
end

endtask



endclass

 `endif 