`ifndef SV_MD_MONITOR_SV
 `define SV_MD_MONITOR_SV

   class sv_md_monitor#(int unsigned DATA_WIDTH) extends uvm_monitor implements sv_md_reset_handler;

   typedef virtual sv_md_if#(DATA_WIDTH) sv_md_vif ;

   sv_md_agent_config#(DATA_WIDTH) agent_config;

   uvm_analysis_port#(sv_md_item_mon) output_port;

   protected process process_collect_transaction;

   `uvm_component_param_utils(sv_md_monitor#(DATA_WIDTH))

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

    sv_md_vif vif = agent_config.get_vif();

    sv_md_item_mon item = sv_md_item_mon::type_id::create("item");

    @(get_sample_delay_start_tr());

    while(vif.valid !== 1) begin
        @(posedge vif.clk);
        @(get_sample_delay_start_tr());

        item.prev_item_delay++;
    end
    
 
   item.offset = vif.offset;

    //Pushing data into queue
   for(int i =0 ; i<vif.size ; i++) begin
    data.push_back(vif.data>>((item.offset+idx)*8) & 'hFF );
   end

   item.length=1;

   void'(begin_tr(item));

   `uvm_info("DEBUG",$sformatf("Monitoring started : %0s", item.convert2string()),UVM_NONE)
   
   output_port.write(item);
   

   @(posedge vif.clk);
   item.length++;

   while(vif.ready !==1) begin
    @(posedge clk);
    item.length++;

    if(item.length>agent_config.get_stuck_threshold()) begin
    `uvm_fatal("PROTOCOL_ERROR",$sformatf("%0sg Transaction: %0s length exceeded the threshold",get_full_name(),item.convert2string() ))
   end
   end

   

   item.response=sv_md_response'(vif.err);

   void'(end_tr(item));

   `uvm_info("DEBUG",$sformatf("Monitored item : %0s", item.convert2string()),UVM_NONE)
    
    output_port.write(item);
    
   @(posedge vif.clk);

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