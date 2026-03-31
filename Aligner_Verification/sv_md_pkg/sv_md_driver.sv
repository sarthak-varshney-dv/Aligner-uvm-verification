`ifndef SV_MD_DRIVER_SV
 `define SV_MD_DRIVER_SV

class sv_md_driver#(int unsigned DATA_WIDTH=32,type ITEM_DRV=sv_md_item_drv) extends uvm_driver#(.REQ(ITEM_DRV)) implements sv_md_reset_handler;

   sv_md_agent_config#(DATA_WIDTH) agent_config;

 protected process process_drive_transaction;
 
    `uvm_component_param_utils(sv_md_driver#(DATA_WIDTH,ITEM_DRV))

    function new(string name="",uvm_component parent);
    super.new(name,parent);
        
    endfunction 

virtual task run_phase(uvm_phase phase);
 forever begin 
    fork 
        begin
            wait_reset_end();
            drive_transactions(); 
            disable fork;
        end
    join
 end

  endtask
  
protected virtual task drive_transactions();

fork
    begin
        process_drive_transaction=process::self();
        
        forever begin 
            ITEM_DRV item ;
            
             seq_item_port.get_next_item(item);

              drive_transaction(item);

             seq_item_port.item_done();
        end
       
    end

join

endtask

protected virtual task drive_transaction(ITEM_DRV item);

`uvm_fatal("ALGORITHM_ISSUE","implement drive_transaction")
endtask

virtual task wait_reset_end();

  agent_config.wait_reset_end();

endtask

virtual function void handle_reset(uvm_phase phase);

  if(process_drive_transaction != null) begin
    process_drive_transaction.kill();

    process_drive_transaction = null;
  end


endfunction


endclass 
 `endif