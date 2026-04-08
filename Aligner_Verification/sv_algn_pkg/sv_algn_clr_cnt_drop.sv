`ifndef SV_ALGN_CLR_CNT_DROP_SV
 `define SV_ALGN_CLR_CNT_DROP_SV

 class sv_algn_clr_cnt_drop extends uvm_reg_cbs ;

 uvm_reg_field cnt_drop ;  //handler for CNT_DROP field

 `uvm_object_utils(sv_algn_clr_cnt_drop)

 function new(string name="");
 super.new(name);
  
 endfunction
 
 virtual function void post_predict(
    input uvm_reg_field fld,
    input uvm_reg_data_t previous,
    inout uvm_reg_data_t value,
    input uvm_predict_e kind ,
    input uvm_path_e path ,
    input uvm_reg_map map 
 );

 if(kind == UVM_PREDICT_WRITE) begin
    if(value ==1) begin
        void'(cnt_drop.predict(0));
    end
    value= 0 ;
 end
 endfunction
 
 endclass

 `endif  