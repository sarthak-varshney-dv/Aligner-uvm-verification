`ifndef SV_APB_RESET_HANDLER_SV
 `define SV_APB_RESET_HANDLER_SV

 interface class sv_apb_reset_handler;

 //function to handle reset
 pure virtual function void handle_reset(uvm_phase phase);

 endclass
 `endif