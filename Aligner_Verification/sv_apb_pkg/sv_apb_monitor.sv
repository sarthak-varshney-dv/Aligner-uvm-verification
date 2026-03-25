`ifndef SV_APB_MONITOR_SV
 `define SV_APB_MONITOR_SV

   class sv_apb_monitor extends uvm_monitor;

   sv_apb_agent_config agent_config;

   uvm_analysis_port#(sv_apb_item_mon) output_port;

   protected process process_collect_transaction;

   `uvm_component_utils(sv_apb_monitor)

   function new (string name="",uvm_component parent)
   super.new(name,parent);
   endfunction
  
  virtual task run_phase(uvm_phase phase);
   
   forever begin
     fork 
        begin
        wait_reset_end();
        collect_transactions();
        disable fork;
        end
     join

   end

  endtask

  
  protected virtual task collections();
    fork
        process_collect_transaction = process::self(); 

        forever begin
            collect_transaction();
        end
    join

  endtask

  protected virtual task collection();

    sv_apb_vif vif = agent_config.get_vif();

    sv_apb_item_mon item = sv_apb_item_mon::type_id::create("item");

    while(vif.psel != 1) begin
        @(posedge vif.pclk);
        item.prev_item_delay++;
    end
    

   item.addr = vif.addr;
   item.dir = sv_apb_dir'(vif.write);
   item.length=1;

   if(item.dir==SV_APB_WRITE) begin
    item.data = vif.pwdata; 
   end

   @(posedge vif.pclk);
   item.length++;

   while(vif.pready !=1) begin
    @(posedge pclk);
    item.length++;
   end
   
   item.response=sv_apb_response'(vif.pslverr);

  if(item.dir==SV_APB_READ) begin
    item.data = vif.prdata; 
   end

   output_port.write(item);

   `uvm_info("DEBUG",$sformatf("Monitored item : %0s", item.convert2string()),UVM_NONE)

   @(posedge vif.pclk);

  endtask


  protected task wait_reset_end();

  agent_config.wait_reset_end();

endtask


    
   endclass
`endif