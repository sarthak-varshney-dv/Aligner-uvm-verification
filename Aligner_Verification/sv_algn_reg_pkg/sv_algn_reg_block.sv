`ifndef SV_ALGN_REG_BLOCK_SV
 `define SV_ALGN_REG_BLOCK_SV

class sv_algn_reg_block extends uvm_reg_block ;

rand sv_algn_reg_ctrl CTRL ;

rand sv_algn_reg_status STATUS ;

rand sv_algn_reg_irq IRQ ;
 
rand sv_algn_reg_irqen IRQEN ;  

`uvm_object_utils(sv_algn_reg_block)

function new(string name = "");

super.new(name,UVM_NO_COVERAGE)
endfunction

virtual function void build();

default_map = create_map(
    .name("APB_MAP"),
    .base_addr('h0000),
    .n_bytes(4),
    .endian(UVM_LITTLE_ENDIAN),
    .byte_addressing(1)

);

default_map.set_check_on_read(1);

CTRL = sv_algn_reg_ctrl::type_id::create(.name("CTRL"), .parent(null), .comtext(get_full_name()));
STATUS = sv_algn_reg_ctrl::type_id::create(.name("STATUS"), .parent(null), .comtext(get_full_name()));
IRQ = sv_algn_reg_ctrl::type_id::create(.name("IRQ"), .parent(null), .comtext(get_full_name()));
IRQEN = sv_algn_reg_ctrl::type_id::create(.name("IRQEN"), .parent(null), .comtext(get_full_name()));

CTRL.configure(.blk_parent(this));
STATUS.configure(.blk_parent(this));
IRQ.configure(.blk_parent(this));
IRQEN.configure(.blk_parent(this));

CTRL.build();
STATUS.build();
IRQ.build();
IRQEN.build();

default_map.add_reg(.rg(CTRL),.offest('h0000),.rights("RW"));
default_map.add_reg(.rg(STATUS),.offest('h000C),.rights("RO"));
default_map.add_reg(.rg(IRQ),.offest('h00F0),.rights("RW"));
default_map.add_reg(.rg(IRQEN),.offest('h00F4),.rights("RW"));



endfunction


endclass

 `endif 
 