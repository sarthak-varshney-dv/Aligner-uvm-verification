`ifndef SV_APB_MONITOR_SV
 `define SV_APB_MONITOR_SV

   class sv_apb_monitor extends uvm_monitor implements sv_apb_reset_handler;

   sv_apb_agent_config agent_config;

   uvm_analysis_port#(sv_apb_item_mon) output_port;

   protected process process_collect_transaction;

   `uvm_component_utils(sv_apb_monitor)

   function new (string name="",uvm_component parent)
   super.new(name,parent);

   output_port = new("output_port",this);

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

    while(vif.psel !== 1) begin
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

   while(vif.pready !==1) begin
    @(posedge pclk);
    item.length++;
   end

   if(agent_config.get_has_checks() == 1) begin
     if(item.length >= agent_config.get_stuck_threshold()) begin
        `uvm_error("PROTOCOL ERROR", $sformatf("The APB transfer reached the stuck threshold of %0d clock cycles",item.length))
     end
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

virtual function void handle_reset(uvm_phase phase);

  if(process_drive_transaction != null) begin
    process_collect_transaction.kill();

    process_collect_transaction = null;
  end


endfunction
    
   endclass
`endif