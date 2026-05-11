`ifndef SV_ALGN_SCOREBOARD_SV
 `define SV_ALGN_SCOREBOARD_SV

`uvm_analysis_imp_decl(_port_in_model_rx)
`uvm_analysis_imp_decl(_port_in_model_tx)
`uvm_analysis_imp_decl(_port_in_model_irq)
`uvm_analysis_imp_decl(_port_in_agent_rx)
`uvm_analysis_imp_decl(_port_in_agent_tx)

  class sv_algn_scoreboard extends uvm_component implements sv_algn_reset_handler ;

  uvm_analysis_imp_port_in_model_rx#(sv_md_response ,sv_algn_scoreboard ) port_in_model_rx ;
  uvm_analysis_imp_port_in_model_tx#(sv_md_item_mon ,sv_algn_scoreboard ) port_in_model_tx ;
  uvm_analysis_imp_port_in_model_irq#(bit ,sv_algn_scoreboard ) port_in_model_irq ;
  uvm_analysis_imp_port_in_agent_rx#(sv_md_item_mon ,sv_algn_scoreboard ) port_in_agent_rx ;
  uvm_analysis_imp_port_in_agent_tx#(sv_md_item_mon ,sv_algn_scoreboard ) port_in_agent_tx ;
  
  //queue to store Expected rx_item respomses
  protected sv_md_response exp_rx_responses[$];
 
  //queue of process pointers
  local process process_exp_response_watchdog[$];

  sv_algn_env_config env_config ;
   
   `uvm_component_utils(sv_algn_scoreboard)

   function new(string name ="", uvm_component parent);
     super.new(name,parent);

     port_in_model_rx = new("port_in_model_rx",this);
     port_in_model_tx = new("port_in_model_tx",this);
     port_in_model_irq = new("port_in_model_irq",this);
     port_in_agent_rx = new("port_in_agent_rx",this);
     port_in_agent_tx = new("port_in_agent_tx",this);

   endfunction
   
   virtual function void handle_reset(uvm_phase phase);

   exp_rx_responses.delete();

   kill_processes_from_queue(process_exp_response_watchdog);
   endfunction

   //function to kill all processes in a queue
   virtual function void kill_processes_from_queue(ref process processes[$]);
    while(processes.size()>0) begin
      processes[0].kill();

      void'(processes.pop_front());
    end

   endfunction

   virtual function void write_port_in_model_rx(sv_md_response response);

   if(exp_rx_responses.size()>=1) begin
    `uvm_error("ALGORITHM ISSUE",$sformatf("Something went wrong as there are %0d entries in exp_rx_responses queue and just received one more",exp_rx_responses.size()))
   end
   
   //if everything is alright ,push the response and start the task
   exp_rx_responses.put(response);
   exp_rx_response_watchdog_nb(response);
     
   endfunction
     
    virtual function void write_port_in_model_tx(sv_md_item_mon item_mon);
   endfunction

    virtual function void write_port_in_model_irq(bit irq);
   endfunction

    virtual function void write_port_in_agent_rx(sv_md_item_mon item_mon);
      if(!item_mon.is_active()) begin
        sv_md_response exp_response = exp_rx_responses.pop_front();

      process_exp_response_watchdog[0].kill();

      void'(process_exp_response_watchdog.pop_front());

      if(item_mon.response != exp_response) begin
        `uvm_error("DUT_ERROR" , $sformatf("Mismatch detectedvfor the RX response -> expected: %0s ,received: %0s , item: %0s",exp_response.name(),item_mon.response.name(),item_mon.convert2string()))
      end

      end

   endfunction

    virtual function void write_port_in_agent_tx(sv_md_item_mon item_mon);
   endfunction

  protected virtual task exp_rx_response_watchdog(sv_md_response response);
     sv_algn_vif vif = env_config.get_vif();
     int unsigned threshold = env_config.get_exp_rx_response_threshold();
     time start_time =$time();

     repeat(threshold) begin
      @(posedge vif.clk);
     end
      //if control is able to come out of repeat loop implies error 
     `uvm_error("DUT_ERROR",$sformatf("The rx response, with value %0s , expectedfrom time %0t , was not received after %0d clock cycles",response.name(),start_time,threshold))
  endtask

   protected virtual function void exp_rx_response_watchdog_nb(sv_md_response response);
    
    fork begin
       
       process p = process::self();

       process_exp_response_watchdog.push_back(p);

       exp_rx_response_watchdog(response);

       void'(process_exp_response_watchdog.pop_front());

    end 
    join_none

   endfunction


  endclass

`endif 