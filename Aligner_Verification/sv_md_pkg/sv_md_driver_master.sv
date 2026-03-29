`ifndef SV_MD_DRIVER_SV
 `define SV_MD_DRIVER_SV

class sv_md_driver_master#(int unsigned DATA_WIDTH = 32) extends sv_md_driver#(.ITEM_DRV(sv_md_item_drv_master))) implements sv_md_reset_handler;

   typedef virtual sv_md_if#(DATA_WIDTH) sv_md_vif ;

   protected process process_drive_transaction;
 
    `uvm_component_param_utils(sv_md_driver_master#(DATA_WIDTH))

    function new(string name="",uvm_component parent);
    super.new(name,parent);
        
    endfunction 

    
protected virtual task drive_transaction(ITEM_DRV item);

  sv_md_if vif = agent_config.get_vif();

  int unsigned data_width_in_bytes = DATA_WIDTH/8 ;

  

endtask

endclass