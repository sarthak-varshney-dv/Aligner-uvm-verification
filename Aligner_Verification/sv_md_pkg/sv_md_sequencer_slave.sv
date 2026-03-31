`ifndef SV_MD_SEQUENCER_SLAVE_SV
 `define SV_MD_SEQUENCER_SLAVE_SV



class sv_md_sequencer_slave#(int unsigned DATA_WIDTH=32) extends sv_md_sequencer_alave_base implements sv_md_reset_handler ;


`uvm_component_param_utils(sv_md_sequencer_slave)


function new(string name ="",uvm_component parent);
super.new(name,parent);

endfunction

virtual function int insigned get_data_width();
 
 return DATA_WIDTH ;

endfunction

endclass

 `endif 