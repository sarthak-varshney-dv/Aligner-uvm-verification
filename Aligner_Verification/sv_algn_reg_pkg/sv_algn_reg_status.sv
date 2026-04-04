`ifndef SV_ALGN_REG_STATUS_SV
 `define SV_ALGN_REG_STATUS_SV

 class  sv_algn_reg_status extends uvm_reg;

 rand uvm_reg_field CNT_DROP;

 rand uvm_reg_field RX_LVL;

 rand uvm_reg_field TX_LVL;

 `uvm_object_utils(sv_algn_reg_ctrl)

 function new(string name ="")
 supre.new(.name(), .n_bits(32), .has_coverage(UVM_NO_COVERAGE));
 endfunction


virtual function void build()

CNT_DROP = uvm_reg_field::type_id::create(.name("CNT_DROP"), .parent(null), .comtext(get_full_name()));
RX_LVL = uvm_reg_field::type_id::create(.name("RX_LVL"), .parent(null), .comtext(get_full_name()));
TX_LVL = uvm_reg_field::type_id::create(.name("TX_LVL"), .parent(null), .comtext(get_full_name()));

CNT_DROP.configure(
    .parent(this),
    .size(8),
    .lsb_pos(0),
    .access("RO"),
    .volatile(0),
    .reset(8'h00),
    .has_reset(1),
    is_rand(1),
    .individually_accessible(0)
);

RX_LVL.configure(
    .parent(this),
    .size(4),
    .lsb_pos(8),
    .access("RO"),
    .volatile(0),
    .reset(4'h0),
    .has_reset(1),
    is_rand(1),
    .individually_accessible(0)
);

TX_LVL.configure(
    .parent(this),
    .size(4),
    .lsb_pos(16),
    .access("RO"),
    .volatile(0),
    .reset(4'h0),
    .has_reset(1),
    is_rand(1),
    .individually_accessible(0)
);

endfunction


 endclass
 `endif 
 
