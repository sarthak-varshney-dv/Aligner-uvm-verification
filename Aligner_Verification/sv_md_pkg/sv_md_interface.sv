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

 bit has_checks ;

 initial begin
    has_checks = 1 ; 
 end

  //DATA_WIDTH must be power of 2
  initial begin
    if($countones(DATA_WIDTH) !=1) begin
      $error($sformatf("DATA_WIDTH is not a power of two"));
    end
  end

  //Minimum value 


 property valid_not_unknown;
   @(posedge clk) disable iff (!has_checks || !reset_n)
   
   is_unknown(valid) == 0;

 endproperty
 
 VALID_NOT_UNKNOWN: assert property(valid_not_unknown) else 
                   begin
                     `uvm_error("ALGORITHM_ISSUE","valid had a unknown value")
                   end

endinterface

 `endif