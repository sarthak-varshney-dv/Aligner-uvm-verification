`ifndef SV_ALGN_REG_PREDICTOR_SV
 `define SV_ALGN_REG_PREDICTOR_SV

 class sv_algn_reg_predictor#(type BUS_TYPE = uvm_sequencce_item) extends uvm_reg_predictor#(.BUS_TYPE(BUS_TYPE)) ;

   sv_algn_env_config env_config ; //for data_width related checks
 
    `uvm_component_param_utils(cfs_algn_reg_predictor#(BUSTYPE))
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction

 
    virtual function uvm_reg_data_t get_reg_field_value(uvm_reg_field field , uvm_reg_data_t reg_data);

    mask = (('h1<<field.get_n_bits())-1) << field.get_lsb_pos() ;

    return (mask & reg_data) >>field.get_lsb_pos ;
    endfunction

    
    virtual function uvm_status_e get_expected_response(uvm_reg_bus_op operation);
     uvm_reg register;

     register = map.get_reg_by_offset(operation.addr , (operation.kind == UVM_READ));

     if(register == null) begin
        return UVM_NOT_OKAY ;
     end
     
     uvm_reg_map_info info ;

     info = get_reg_map_info(register);

     if(operation.kind ==UVM_WRITE) begin
        if(info.rights == "RO") begin
            return UVM_NOT_OKAY ; 
        end
     end

     else if (operation.kind ==UVM_READ) begin
         if(info.rights == "WO") begin
            return UVM_NOT_OKAY ; 
        end
        
     end

     // check if write to ctrl is illegal
     int unsigned data_width = env_config.get_algn_data_width();

     if(operation.kind == UVM_WRITE) begin
        sv_algn_reg_ctrl ctrl ;
        if($cast(ctrl,register)) begin
            uvm_reg_data_t offest = get_reg_field_value(ctrl.OFFSET , operation.data) ;
            uvm_reg_data_t size = get_reg_field_value(ctrl.SIZE , operation.data) ;

            if(size == 0) begin
                return UVM_NOT_OKAY ;
            end

            if(size+offset > data_width) begin
                return UVM_NOT_OKAY ;
            end

            if (((data_width/8)+offset)%size != 0 ) begin
                return UVM_NOT_OKAY ;
                
            end

        end
     end

     return UVM_IS_OK ;   //if non of the checks triggered


    endfunction

    virtual function void write(BUS_TYPE tr);

    uvm_reg_bus_op operation ;

    adapter.bus2reg(tr,operation) ;


    uvm_status_e tr_legality = get_expected_response(operation);

    if(tr_legality == UVM_IS_OK) begin  //only send legal transactions to the model 
        super.write(tr);
    end

    endfunction


 endclass
 `endif 
 