`ifdef SV_ALGN_VIRTUAL_SEQUENCER_SV
 `define SV_ALGN_VIRTUAL_SEQUENCER_SV

  class sv_algn_virtual_sequencer extends uvm_sequencer ;

  sv_apb_sequencer apb_sequencer ;

  sv_md_sequencer_master_base md_rx_sequencer;

  sv_md_sequencer_slave_base md_tx_sequencer ;

  sv_algn_model model ;

    `uvm_component_utils(sv_algn_virtual_sequencer)

    function new(string name ="", uvm_component parent);
     super.new(name , parent);
    endfunction

  endclass


`endif