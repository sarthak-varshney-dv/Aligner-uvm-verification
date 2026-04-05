`ifndef SV_ALGN_MODEL_SV
 `define SV_ALGN_MODEL_SV

class sv_algn_model extends uvm_component 

sv_algn_reg_block reg_block ;

`uvm_component_utils(sv_algn_model)

function new(string name = "",uvm_component parent);
  super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase)
super.build_phase(phase);

if(reg_block == null) begin
    reg_block = sv_algn_reg_block::type_id::create("reg_block");

    
reg_block.build();
reg_block.lock_model();


end


endfunction
endclass

 `endif 