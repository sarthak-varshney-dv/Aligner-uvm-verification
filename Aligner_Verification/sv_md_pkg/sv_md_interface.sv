`ifndef SV_MD_INTERFACE_SV
 `define SV_MD_INTERFACE_SV

interface sv_md_if#(int unsigned  data_width = 32) (input clk);

 localparam OFFSET_WIDTH = ;

 localparam SIZE_WIDTH = ;

 logic reset_n;

 logic  ready;

 logic valid;

 logic [OFFSET_WIDTH-1 : 0] offset ;

 logic [data_width - 1 : 0] data ;

 logic {SIZE_WIDTH -1 : 0 } size ;

 logic err ; 





endinterface

 `endif