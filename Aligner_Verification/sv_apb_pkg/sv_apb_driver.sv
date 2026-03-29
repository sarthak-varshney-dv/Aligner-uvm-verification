`ifndef SV_APB_DRIVER_SV
 `define SV_APB_DRIVER_SV

class sv_apb_driver extends uvm_driver#(.REQ(sv_apb_item_drv)) implements sv_apb_reset_handler;

   sv_apb_agent_config agent_config;

 protected process process_drive_transaction;
 
    `uvm_component_utils(sv_apb_driver)

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
            sv_apb_item_drv item ;

             seq_item_port.get_next_item(item);

              drive_transaction(item);

             seq_item_port.item_done();
        end
       
    end

join

endtask

protected virtual task drive_transaction(sv_apb_item_drv item);

//drive all signals zero (done in reset)
sv_apb_vif = agent_config.get_vif();

`uvm_info("DEBUG", $sformatf("Driving \"%0s\": %0s"item.get_full_name(),item.convert2string()) UVM_NONE)

for(int i=0; i<pre_drive_delay;i++) begin
    @(posedge vif.pclk);
end

vif.psel   <=  1;
vif.paddr  <=  item.addr;
vif.write  <=  bit'(item.dir);

if(item.dir == SV_APB_WRITE) begin
    vif.pwdata <= item.data;
end
@(posedge vif.pclk);

penable <=1 ;

@(posedge vif.pclk);

while(vif.pready !=1) begin
    @(posedge vif.pclk);
end

vif.psel <= 0;
vif.penable <= 0;
vif.write <= 0;
vif.paddr <= 0;
vif.pwdata <= 0;

for(int i=0; i<post_drive_delay;i++) begin
    @(posedge vif.pclk);
end

endtask

virtual task wait_reset_end();

  agent_config.wait_reset_end();

endtask

virtual function void handle_reset(uvm_phase phase);
  sv_apb_vif = agent_config.get_vif();

  if(process_drive_transaction != null) begin
    process_drive_transaction.kill();

    process_drive_transaction = null;
  end

  vif.psel <= 0;
  vif.penable <= 0;
  vif.write <= 0;
  vif.paddr <= 0;
  vif.pwdata <= 0;

endfunction


endclass 
 `endif