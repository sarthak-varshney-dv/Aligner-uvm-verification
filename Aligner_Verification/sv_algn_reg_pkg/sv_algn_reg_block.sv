`ifndef SV_ALGN_REG_BLOCK_SV
 `define SV_ALGN_REG_BLOCK_SV

class sv_algn_reg_block extends uvm_reg_block ;

rand sv_algn_reg_ctrl CTRL ;

rand sv_algn_reg_status STATUS ;

rand sv_algn_reg_irq IRQ ;
 
rand sv_algn_reg_irqen IRQEN ;  

`uvm_object_utils(sv_algn_reg_block)

function new(string name = "");

super.new(.name(name))
endfunction


endclass

 `endif 
 