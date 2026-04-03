`ifndef SV_MD_COVERAGE_SV
 `define SV_MD_COVERAGE_SV

 `uvm_analysis_imp_decl(_item)

 class sv_md_index_cover_wrapper#(int unsigned max_value_plus_1 = 32) extends uvm_component;

 covergroup cover_index with function sample(int unsigned value);
 option.per_instance=1;

 index : coverpoint value{
 bins[] = {[0,max_value_plus_1-1]};
 }
 endgroup

 virtual function new(string name="",uvm_component parent);
  super.new(name,parent);

  cover_index=new();
  cover_index.set_inst_name($sformatf("%s_%s"),get_full_name(),"cover_index");
  endfunction 

  virtual function void sample(int unsigned idx);
  cover_index.sample(idx);
  endfunction
  
 endclass

 class sv_md_coverage#(int unsigned DATA_WIDTH = 32) extends uvm_component implements sv_md_reset_handler ;

 typedef virtual sv_md_if#(DATA_WIDTH) sv_md_vif ;

 //port to connect from monitor
  uvm_analysis_imp_item#(sv_md_item_mon,sv_md_coverage) port_item;

  sv_md_agent_config agent_config#(DATA_WIDTH);

  sv_md_index_cover_wrapper#(DATA_WIDTH) cover_data_index_1 ;

  sv_md_index_cover_wrapper#(DATA_WIDTH) cover_data_index_0 ;

  
  `uvm_component_param_utils(sv_md_coverage#(DATA_WIDTH))

  covergroup cover_item with function sample(sv_md_item_mon item);

  option.per_instance=1;

  offset : coverpoint item.offset {
    option.comment = "offest of transaction"

    bins[] = {[0:DATA_WIDTH/8-1]}
  }

  size : coverpoint item.data.size() {
    option.comment = "size of transaction"

    bins[] = {[1:DATA_WIDTH/8]}
  }

 response : coverpoint item.response {
    option.comment="response of MD_ACCESS";
  }
  length :  coverpoint item.length{
    option.comment="length of MD_ACCESS";

    bins equal_1 = {1}; 
    bins less_than_ten[8] = {[2:10]};
    bins greater_than_ten= {[10:$]};

    illegal_bins length_0={0};
  }

  prev_item_delay : coverpoint item.prev_item_delay {
    option.comment= "delay prior to MD_ACCESS";

    bins back_to_back = {0};
    bins delay_less_5[5]= {[1:5]};
    bins delay_greater_6 = {[6:$]};
  }

  sizeXoffset :cross size , offset ;
  endgroup

  covergroup cover_reset with function sample(bit valid);
  option.per_instance=1;

  access_ongoing : coverpoint valid {
    option.comment="An MD ACCESS was ongoing at reset"
  }
  endgroup
function new(string name="",uvm_component parent)
super.new(name,parent);
  port_item = new("port_item",this);

cover_item =  new();
cover_reset=  new();
cover_item.set_inst_name($sformatf("%s_%s",get_full_name(),"cover_item"));

cover_data_index_1= sv_md_index_cover_wrapper::type_id::create("cover_data_index_1",this);
cover_data_index_0= sv_md_index_cover_wrapper::type_id::create("cover_data_index_2",this);



endfunction


  virtual function void write(sv_md_item_mon item):
  cover_item.sample(item);

  foreach(item.data[byte_idx]) begin
    for(int bit_idx=0;i<8,i++) begin
        if(item.data[byte_idx][bit_idx]) begin
            cover_data_index_1.sample((item.offset *8) + (byte_idx *8) + bit_idx);
        end
        else begin
            cover_data_index_0.sample((item.offset *8) + (byte_idx *8) + bit_idx);

            
        end
    end
  end


  endfunction

  virtual function void handle_reset(uvm_phase phase);
  sv_md_vif vif = agent_congfig.get_vif();

  cover_reset.sample(vif.valid);
  
  endfunction


 endclass
 `endif 