`ifndef SV_APB_COVERAGE_SV
 `define SV_APB_COVERAGE_SV

  `uvm_analysis_imp_decl(_item)

 class sv_apb_cover_index_wrapper(int unsigned max_value_plus_one = 16) extends uvm_component;

 `uvm_component_param_utils#(sv_apb_cover_index_wrapper(max_value_plus_one))

 covergroup cover_index with function sample(int unsigned value);

  index : coverpoint value{
    option.per_instance=1;

    bins indexes[max_value_plus_one] = {{0:max_value_plus_one-1}}
  }

  virtual function new(string name="",uvm_component parent);
  super.new(name,parent);

  cover_index=new();
  cover_index.set_inst_name($sformatf("%s_%s"),get_full_name(),"cover_index");
  endfunction 

  virtual function void sample(int unsigned value);
  cover_index.sample(value);
    
  endfunction
 endgroup


 endclass


 class sv_apb_coverage extends uvm_component;
  
  //port to connect from monitor
  uvm_analysis_imp_item#(sv_apb_item_mon,sv_apb_coverage) port_item;

  //index wraper objects to sample toggling of each index 
  sv_apb_cover_index_wrapper#(`SV_APB_MAX_ADDR_WIDTH)  wrap_cover_addr_0; 

  sv_apb_cover_index_wrapper#(`SV_APB_MAX_ADDR_WIDTH)  wrap_cover_addr_1;

  sv_apb_cover_index_wrapper#(`SV_APB_MAX_DATA_WIDTH)  wrap_cover_pwdata_0;

  sv_apb_cover_index_wrapper#(`SV_APB_MAX_DATA_WIDTH)  wrap_cover_pwdata_1;

  sv_apb_cover_index_wrapper#(`SV_APB_MAX_DATA_WIDTH)  wrap_cover_prdata_0;

  sv_apb_cover_index_wrapper#(`SV_APB_MAX_DATA_WIDTH)  wrap_cover_prdata_1; 
  
  `uvm_component_utils(sv_apb_coverage)

  covergroup cover_item with function sample(sv_apb_item_mon item);
 option.per_instance =1;

  direction : coverpoint item.dir{
    option.comment = "direction of APB_ACCESS"
  } 

  response : coverpoint item.response {
    option.comment="response of APB_ACCESS"
  }

  length : coverpoint item.length{
    option.comment="length of APB_ACCESS"

    bins equal_2 = {2}; //shortest item possible
    bins less_than_ten[8] = {[3:10]};
    bins greater_than_ten= {[10:$]};
  }


  prev_item_delay : coverpoint item.prev_item_delay {
    option.comment= "delay prior to APB_ACCESS"

    bins back_to_back = {0};
    bins delay_less_5[5]= {[1:5]};
    bins delay_greater_6 = {[6:$]};
  }

 endgroup
      

    function new(string name="",uvm_component parent);
    super.new(name,parent);
        cover_item=new();
        cover_item.set_inst_name($sformatf("%s_%s",get_full_name(),"cover_item"));

        wrap_cover_addr_0   = sv_apb_cover_index_wrapper#(`SV_APB_MAX_ADDR_WIDTH)::type_id::create("wrap_cover_addr_0");
        wrap_cover_addr_1   = sv_apb_cover_index_wrapper#(`SV_APB_MAX_ADDR_WIDTH)::type_id::create("wrap_cover_addr_1"); 
        wrap_cover_pwdata_0 = sv_apb_cover_index_wrapper#(`SV_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_pwdata_0");
        wrap_cover_pwdata_1 = sv_apb_cover_index_wrapper#(`SV_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_pwdata_1"); 
        wrap_cover_prdata_0 = sv_apb_cover_index_wrapper#(`SV_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_prdata_0");
        wrap_cover_prdata_1 = sv_apb_cover_index_wrapper#(`SV_APB_MAX_DATA_WIDTH)::type_id::create("wrap_cover_prdata_1"); 


    endfunction 

    
 virtual function void write_item(sv_apb_item_mon item);
  
  cover_item.sample(item);
   
 //sampling of address index toggling
 for(int i=0;i<`SV_APB_MAX_ADDR_WIDTH;i++) begin
    if(item.addr[i]) begin
    wrap_cover_addr_1.sample(i);
    end
    else begin
        wrap_cover_addr_0.sample(i);
 end
 end

 //sampling of data index toggiling
 for(int i=0;i<`SV_APB_MAX_DATA_WIDTH,i++) begin
    
    case(item.dir)
       SV_APB_WRITE : begin
    if(item.pwdata[i]) begin
    wrap_cover_pwdata_1.sample(i);
          end
    else begin
        wrap_cover_pwdata_0.sample(i);
          end
       end

    SV_APB_READ : begin
    if(item.prdata[i]) begin
    wrap_cover_prdata_1.sample(i);
          end
    else begin
        wrap_cover_prdata_0.sample(i);
          end
     end
     default : begin
        `uvm_error("ALOGRITHM ISSUE",$sformatf("item.dir:%0s not supported",item.dir.name()))
     end
    endcase
    

 end

 endfunction


 endclass 

 

 `endif