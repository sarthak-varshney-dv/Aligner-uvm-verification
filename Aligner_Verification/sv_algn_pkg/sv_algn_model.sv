`ifndef SV_ALGN_MODEL_SV
 `define SV_ALGN_MODEL_SV

class sv_algn_model extends uvm_component implements sv_algn_reset_handler ;

sv_algn_env_config env_config ;

sv_algn_reg_block reg_block ;

`uvm_component_utils(sv_algn_model)

function new(string name = "",uvm_component parent);
  super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(reg_block == null) begin
    reg_block = sv_algn_reg_block::type_id::create("reg_block");

    
reg_block.build();
reg_block.lock_model();


end
endfunction

virtual function void connect_phase(uvm_phase phase)
 super.connect_phase(phase);

 sv_algn_clr_cnt_drop cbs= sv_algn_clr_cnt_drop::type_id::create("cbs");

 cbs.cnt_drop = reg_block.STATUS.CNT_DROP ;

 uvm_callbacks(uvm_reg_field , sv_algn_clr_cnt_drop)::add(reg_block.CTRL.CLR , cbs) ;
endfunction

virtual function void end_of_elaboration_phase(uvm_phase phase);
super.end_of_elaboration_phase(phase);

  reg_block.CTRL.SET_ALGN_DATA_WIDTH(env_config.get_algn_data_width());

endfunction



virtual function void handle_reset(uvm_phase phase);

    reg_block.handle_reset("HARD");
  endfunction
  


endclass

 `endif 