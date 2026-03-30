`ifndef SV_MD_DRIVER_MASTER_SV
 `define SV_MD_DRIVER_MASTER_SV

class sv_md_driver_master#(int unsigned DATA_WIDTH = 32) extends sv_md_driver#(.ITEM_DRV(sv_md_item_drv_master))) implements sv_md_reset_handler;

   typedef virtual sv_md_if#(DATA_WIDTH) sv_md_vif ;

 
    `uvm_component_param_utils(sv_md_driver_master#(DATA_WIDTH))

    function new(string name="",uvm_component parent);
    super.new(name,parent);
        
    endfunction 

    
protected virtual task drive_transaction(sv_md_item_drv_master item);

  sv_md_if vif = agent_config.get_vif();

  int unsigned data_width_in_bytes = DATA_WIDTH/8 ;

  //a check for driving item
  if(item.data.size() + item.offset > data_width_in_bytes) begin
    `uvm_fatal ("ALGORITHM_ISSUE","driving item exceeds data_width");
  end

  `uvm_info("DEBUG",$sformatf("Driving \"%0s\" : %0s",item.get_full_name(),item.convert2string(),UVM_NONE))

  for(int i=0;i<item.pre_drive_delay,i++) begin
    @(posedge vif.clk) ;
  end

  vif.valid<=1 ;
 begin
  bit[DATA_WIDTH-1:0] data=0;

  foreach(item.data[idx]) begin
     bit[DATA_WIDTH-1:0] temp = item.data[idx] <<((item.offset+ idx) * 8);

     data = data | temp ; 
  end

  vif.data <= data ;
 end

 vif.offset<=offset ;
 vif.size<=item.size ;

 @(posedge vif.clk) ;

 while(vif.ready !=1) begin
     @(posedge vif.clk) ;
 end

 vif.data<=0;
 vif.offset<=0;
 vif.size<=0;
 vif.valid<=0;


for(int i=0; i<post_drive_delay;i++) begin
    @(posedge vif.pclk);
end

endtask

virtual function void handle_reset(uvm_phase phase);

  sv_apb_vif = agent_config.get_vif();

  super.handle_reset(phase);

 vif.data<=0;
 vif.offset<=0;
 vif.size<=0;
 vif.valid<=0;

endfunction

endclass

`endif 