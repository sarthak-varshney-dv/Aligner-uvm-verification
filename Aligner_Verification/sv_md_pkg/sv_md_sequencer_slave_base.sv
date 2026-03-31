`ifndef SV_MD_SEQUENCER_SLAVE_BASE_SV
 `define SV_MD_SEQUENCER_SLAVE_BASE_SV

  `uvm_analysis_imp_decl(_port_from_mon)


class sv_md_sequencer_slave_base extends sv_md_sequencer_base#(.ITEM_DRV(sv_md_item_drv_slave)) implements sv_md_reset_handler ;

uvm_analysis_imp_port_from_mon#(sv_md_item_mon,sv_md_sequencer_slave_base) port_from_mon ;

uvm_tlm_fifo#(sv_md_item_mon) pending_items ;

`uvm_component_utils(sv_md_sequencer_slave_base)


function new(string name ="",uvm_component parent);
super.new(name,parent);

port_from_mon = new("port_from_mon",this) ;

pending_items = new("pending_items",this,1);
endfunction

virtual function void write_port_from_mon(sv_md_item_mon item);

 if (item.is_active()) begin  
     if(pending_items.is_full()) begin
        `uvm_fatal("ALGORITHM_ISSUE",$sformatf("FIFO %0s is full.A possible reason is no sequence started which pulls item",pending_items.get_full_name()))

     end
   it(pending_items.try_put(item) == 0) begin
    `uvm_fatal("ALGORITHM_ISSUE",$sformatf("failed to push item into FIFO %0s",pending_items.get_full_name()))
   end
 end

endfunction

virtual function void handle_reset(uvm_phase phase);
super.handle_reset(phase);
 pending_items.flush();
endfunction


endclass

 `endif 