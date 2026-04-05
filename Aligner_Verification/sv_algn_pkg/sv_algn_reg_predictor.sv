`ifndef SV_ALGN_REG_PREDICTOR_SV
 `define SV_ALGN_REG_PREDICTOR_SV

 class sv_algn_reg_predictor#(type BUS_TYPE = uvm_sequencce_item) extends uvm_reg_predictor#(.BUS_TYPE(BUS_TYPE)) ;

 
    `uvm_component_param_utils(cfs_algn_reg_predictor#(BUSTYPE))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction

    virtual function void write(BUS_TYPE tr);

    uvm_reg_bus_op operation ;

    adapter.bus2reg(tr,operation) ;

    if(operation.stutus == UVM_IS_OK) begin  //only send legal transactions to the model 
        super.write(tr);
    end

    endfunction


 endclass
 `endif 
 