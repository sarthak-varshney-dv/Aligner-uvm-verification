`ifndef SV_MD_RESET_HANDLER_SV
 `define SV_MD_RESET_HANDLER_SV

 interface class cfs_md_reset_handler;

 //function to handle reset
 pure virtual function void handle_reset(uvm_phase phase);

 endclass
 `endif