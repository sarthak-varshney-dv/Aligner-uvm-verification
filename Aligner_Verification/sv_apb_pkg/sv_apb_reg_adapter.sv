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
    rw.status = item_mon.response == SV_APB_OKAY ? UVM_IS_OK : UVM_NOT_OKAY ;
end
  else if($cast(item_drv, bus_item)) begin  //used by reg2bus in the background
        rw.kind = item_drv.dir == CFS_APB_WRITE? UVM_WRITE : UVM_READ;
        
        rw.addr   = item_drv.addr;
        rw.data   = item_drv.data;
        rw.status = UVM_IS_OK;
      end
      else begin
        `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Class not supported: %0s", bus_item.get_type_name()))
      end

 endfunction

virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
sv_apb_item_drv item_drv ;

void'(item_drv.randomize with{ 
     
     item.dir == (rw.kind == UVM_WRITE) ? SV_APB_WRITE : SV_APB_READ ;
     item.data == rw.data ;
     item.addr = rw.addr ; 

});
endfunction
 endclass
 `endif
