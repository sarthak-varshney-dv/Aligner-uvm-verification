`ifndef SV_ALGN_REG_CTRL_SV
 `define SV_ALGN_REG_CTRL_SV

 class  sv_algn_reg_ctrl extends uvm_reg;

 rand uvm_reg_field SIZE;

 rand uvm_reg_field OFFSET;

 rand uvm_reg_field CLR;

 `uvm_object_utils(sv_algn_reg_ctrl)

 function new(string name ="")
 supre.new(.name(), .n_bits(32), .has_coverage(UVM_NO_COVERAGE));
 endfunction


virtual function void build()

SIZE = uvm_reg_field::type_id::create(.name("SIZE"), .parent(null), .comtext(get_full_name()));
OFFSET = uvm_reg_field::type_id::create(.name("OFFSET"), .parent(null), .comtext(get_full_name()));
CLR = uvm_reg_field::type_id::create(.name("CLEAR"), .parent(null), .comtext(get_full_name()));

SIZE.configure(
    .parent(this),
    .size(3),
    .lsb_pos(0),
    .access("RW"),
    .volatile(0),
    .reset(3'b001),
    .has_reset(1),
    is_rand(1),
    .individually_accessible(0)
);

OFFSET.configure(
    .parent(this),
    .size(2),
    .lsb_pos(8),
    .access("RW"),
    .volatile(0),
    .reset(2'b00),
    .has_reset(1),
    is_rand(1),
    .individually_accessible(0)
);

CLR.configure(
    .parent(this),
    .size(1),
    .lsb_pos(16),
    .access("RO"),
    .volatile(0),
    .reset(1'b0),
    .has_reset(1),
    is_rand(1),
    .individually_accessible(0)
);

endfunction


 endclass
 `endif 
 
