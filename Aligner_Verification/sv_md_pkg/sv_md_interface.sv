`ifndef SV_MD_INTERFACE_SV
 `define SV_MD_INTERFACE_SV

interface sv_md_interface#(int unsigned  DATA_WIDTH = 32) (input clk);

 localparam OFFSET_WIDTH = $clog2(DATA_WIDTH / 8) > 1 ? $clog2(data_width / 8) : 1  ;

 localparam SIZE_WIDTH =   $clog2(DATA_WIDTH / 8) + 1 ;

 logic reset_n;

 logic  ready;

 logic valid;

 logic [OFFSET_WIDTH-1 : 0] offset ;

 logic [DATA_WIDTH - 1 : 0] data ;

 logic {SIZE_WIDTH -1 : 0 } size ;

 logic err ; 



endinterface

 `endif