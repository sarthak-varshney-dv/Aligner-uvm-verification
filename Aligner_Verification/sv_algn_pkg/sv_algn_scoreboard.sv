`ifndef SV_ALGN_SCOREBOARD_SV
 `define SV_ALGN_SCOREBOARD_SV

`uvm_analysis_imp_decl(_port_in_model_rx)
`uvm_analysis_imp_decl(_port_in_model_tx)
`uvm_analysis_imp_decl(_port_in_model_irq)
`uvm_analysis_imp_decl(_port_in_agent_rx)
`uvm_analysis_imp_decl(_port_in_agent_tx)

  class sv_algn_scoreboard extends uvm_component implements sv_algn_reset_handler ;

  uvm_analysis_imp_port_in_model_rx#(sv_md_response ,sv_algn_scoreboard ) port_in_model_rx ;
  uvm_analysis_imp_port_in_model_tx#(sv_md_item_mon ,sv_algn_scoreboard ) port_in_model_tx ;
  uvm_analysis_imp_port_in_model_irq#(bit ,sv_algn_scoreboard ) port_in_model_irq ;
  uvm_analysis_imp_port_in_agent_rx#(sv_md_item_mon ,sv_algn_scoreboard ) port_in_agent_rx ;
  uvm_analysis_imp_port_in_agent_tx#(sv_md_item_mon ,sv_algn_scoreboard ) port_in_agent_tx ;

   
   `uvm_component_utils(sv_algn_scoreboard)

   function new(string name ="", uvm_component parent);
     super.new(name,parent);
   endfunction
     
   virtual function void write_port_in_model_rx(sv_md_response response);
   endfunction
     
    virtual function void write_port_in_model_tx(sv_md_item_mon item);
   endfunction

    virtual function void write_port_in_model_irq(bit irq);
   endfunction

    virtual function void write_port_in_agent_rx(sv_md_item_mon item);
   endfunction

    virtual function void write_port_in_agent_tx(sv_md_item_mon item);
   endfunction



  endclass

`endif 