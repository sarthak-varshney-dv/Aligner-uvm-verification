`ifndef SV_ALGN_ENV_CONFIG_SV
 `define SV_ALGN_ENV_CONFIG_SV

class sv_algn_env_config extends uvm_component ;

local int unsigned algn_data_width ;      //md interface width will be passed in the env build phase

`uvm_component_utils(sv_algn_env_config)

function new(string name= "", uvm_component parent)
  super.new(name,parent)
endfunction

virtual function void set_algn_data_width(int unsigned value);
  //The minimum legal value for this field is 8.
      if(value < 8) begin
        `uvm_fatal("ALGORITHM_ISSUE", $sformatf("The minimum legal value for ALGN_DATA_WIDTH is 8 but user tried to set it to %0d", value))
      end
      
      //The value must be a power of 2
      if($countones(value) != 1) begin
        `uvm_fatal("ALGORITHM_ISSUE", $sformatf("Thevalue for ALGN_DATA_WIDTH must be a power of 2 but user tried to set it to %0d", value))
      end

algn_data_width=value;
endfunction

virtual function int unsigned get_algn_data_width();


return algn_data_width ;
endfunction


endclass
 `endif
