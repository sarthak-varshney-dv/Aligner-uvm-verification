`ifndef SV_ALGN_ENV_CONFIG_SV
 `define SV_ALGN_ENV_CONFIG_SV

class sv_algn_env_config extends uvm_component ;

local int unsigned algn_data_width ;      //md interface width will be passed in the env build phase

`uvm_component_utils(sv_algn_env_config)

function new(string name= "", uvm_component parent)
  super.new(name,parent)
endfunction

virtual function void set_algn_data_width(int unsigned value);

algn_data_width=value;
endfunction

virtual function int unsigned set_algn_data_width();

return algn_data_width ;
endfunction


endclass
 `endif
