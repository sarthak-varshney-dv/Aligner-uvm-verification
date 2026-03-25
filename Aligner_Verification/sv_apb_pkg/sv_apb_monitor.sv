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
  endtask

    
   endclass
`endif