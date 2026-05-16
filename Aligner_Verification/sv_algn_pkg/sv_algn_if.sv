`ifndef SV_ALGN_IF_SV
 `define SV_ALGN_IF_SV

 interface sv_algn_if(input clk);

  logic irq ;

  logic reset_n;

  logic rx_fifo_push ;
  
  logic rx_fifo_pop ;

  logic tx_fifo_push ;

  logic tx_fifo_pop ;

    
 endinterface

 `endif