`ifndef SV_APB_REG_ADAPTER_SV
 `define SV_APB_REG_ADAPTER_SV

 class sv_apb_reg_adapter extends uvm_reg_adapter ;

 `uvm_object_utils(sv_apb_reg_adapter)

 function new(string name="")
 super.new(name)
 endfunction

 virtual function void bus2reg(uvm_sequence_item bus_item,ref uvm_reg_bus_op rw);
sv_apb_item_mon item_mon;

if($cast(item_mon,bus_item) )begin
    rw.kind = item_mon.dir == SV_APB_WRITE ? UVM_WRITE : UVM_READ ;

    rw.data = item_mon.data ;
    rw.addr = item_mon.addr ;
    rw.kind = item_mon.response == SV_APB_OKAY ? UVM_IS_OK : UVM_NOT_OKAY ;
end

 endfunction

 endclass
 `endif
