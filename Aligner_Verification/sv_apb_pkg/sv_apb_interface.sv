`ifndef SV_APB_INTERFACE_SV
 `define SV_APB_INTERFACE_SV

 `ifndef SV_APB_MAX_DATA_WIDTH
 `define SV_APB_MAX_DATA_WIDTH 32
   `endif

 `ifndef SV_APB_MAX_ADDR_WIDTH
 `define SV_APB_MAX_ADDR_WIDTH 16
   `endif

interface sv_apb_interface(input pclk);
  
  logic preset_n;
  
  logic [`SV_APB_MAX_DATA_WIDTH-1:0] pwdata;
  
  logic [`SV_APB_MAX_DATA_WIDTH-1:0] prdata; 
  
  logic [`SV_APB_MAX_ADDR_WIDTH-1:0] paddr;
  
  logic pwrite;
  
  logic psel;
  
  logic penable;
  
  logic pready;
  
  logic pslverr;
  
  
  bit has_checks;

  initial begin
    has_checks = 1;
  end
  
endinterface

`endif