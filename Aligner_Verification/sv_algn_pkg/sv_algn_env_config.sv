`ifndef SV_ALGN_ENV_CONFIG_SV
 `define SV_ALGN_ENV_CONFIG_SV

class sv_algn_env_config extends uvm_component ;

local int unsigned algn_data_width ;      //md interface width will be set in the env build phase

//virtual interface
protected sv_algn_vif vif ;

local int unsigned exp_rx_response_threshold ;

local int unsigned exp_tx_item_threshold ;

local int unsigned exp_irq_threshold ;

local bit has_coverage ;


`uvm_component_utils(sv_algn_env_config)

function new(string name= "", uvm_component parent)
  super.new(name,parent);

  exp_rx_response_threshold=10 ;
  exp_tx_item_threshold=10;
  exp_irq_threshold=10 ;

  has_coverage= 1 ;
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

//getter for virtual interface
virtual function sv_algn_vif get_vif();

   return vif ;
endfunction

//setter for virtual interface
virtual function void get_vif(sv_algn_vif value);
  if(vif == null) begin
    vif =value;
  end
  else begin
    `uvm_fatal("ALGORITHM_ISSUE","Trying to set algn virtual interface more than once")
  end
endfunction

//getter for exp_rx_response_threshold
virtual function int unsigned get_exp_rx_response_threshold();

   return exp_rx_response_threshold ;
endfunction

//setter for exp_rx_response_threshold
virtual function void get_exp_rx_response_threshold(int unsigned value);
  
    exp_rx_response_threshold =value;
  
endfunction

//getter for exp_tx_item_threshold
virtual function int unsigned get_exp_tx_item_threshold();

   return exp_tx_item_threshold ;
endfunction

//setter for exp_tx_item_threshold
virtual function void get_exp_tx_item_threshold(int unsigned value);
  
    exp_tx_item_threshold =value;
  
endfunction

//getter for exp_irq_threshold
virtual function int unsigned get_exp_irq_threshold();

   return exp_irq_threshold ;
endfunction

//setter for exp_irq_threshold
virtual function void get_exp_irq_threshold(int unsigned value);
  
    exp_irq_threshold =value;
  
endfunction

virtual function void start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
     
     if(get_vif() == null) begin
      `uvm_fatal("ALGORITHM_ISSUE","The aligner virtual interface is not set at \"Start Of Simulation Phase \" phase")
     end
     else begin
      `uvm_info("ALGN_CONFIG","The aligner virtual interface is configured at  \"Start Of Simulation Phase \" phase",UVM_DEBUG)
     end

endfunction

virtual function void set_has_coverage(bit value);

  has_coverage = value ;
  
endfunction

virtual function void set_has_coverage(bit value);

  has_coverage = value ;
  
endfunction

virtual function bit get_has_coverage();

  return has_coverage ;
  
endfunction

endclass
 `endif
