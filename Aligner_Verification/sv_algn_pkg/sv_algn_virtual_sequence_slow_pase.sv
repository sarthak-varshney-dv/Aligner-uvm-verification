`ifndef SV_ALGN_VIRTUAL_SEQUENCE_SLOW_PACE_SV
 `define SV_ALGN_VIRTUAL_SEQUENCE_SLOW_PACE_SV

 class sv_algn_virtual_sequence_slow_pace extends sv_algn_virtual_sequence_base ;

  `uvm_object_utils(sv_algn_virtual_sequence_slow_pace)

  function new(string name = "");
   super.new(name);
  endfunction

  virtual task body();

   fork
     sv_md_sequence_simple_master rx_sequence = sv_md_sequence_simple_master::type_id::create("rx_sequence");

    begin
        int unsigned algn_data_width =  p_sequencer.model.env_config.get_algn_data_width();
        int unsigned ctrl_size = p_sequencer.model.reg_block.CTRL.SIZE.get_mirrored_value();

        `uvm_do_on_with(rx_sequence , p_sequencer.apb_sequencer ,{
            ((algn_data_width/8) + item.offset ) % item.data.size() == 0 ;
            item.data.size() + item.offset <= (algn_data_width/8);
            item.data.size() >= ctrl_size;  //to ensure trxn dosen't get stuck in rx controller
        })
        
    end
    begin
        int unsigned num_tx_items;
        int unsigned tx_item_idx ;

        do begin
            sv_md_sequence_simple_slave tx_sequence = sv_md_sequence_simple_slave::type_id::create("tx_sequence");

            num_tx_items = rx_sequence.item.data.size() / p_sequencer.model.reg_block.CTRL.SIZE.get_mirrored_value() ;

            sv_md_item_mon item_mon ;

            p_sequencer.md_tx_sequencer.pending_items.get(item_mon); //mandatory else error

            `uvm_do_on_with(tx_sequence,p_sequencer.md_tx_sequencer,{
              num_tx_items == 1                                     -> item.response = SV_MD_OKAY ;
              num_tx_items > 1 && tx_item_idx < (num_tx_items - 1)   -> item.response = SV_MD_OKAY ;
              num_tx_items > 1 && tx_item_idx += (num_tx_items - 1)   -> item.response = SV_MD_error ;


            })
            num_tx_items ++ ;
        end
        while(tx_item_idx < num_tx_items);
        
    end
   join
  endtask
 endclass

 `endif 