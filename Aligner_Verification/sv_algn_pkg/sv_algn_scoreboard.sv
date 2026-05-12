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

  //queue to store Expected tx_item respomses
  protected sv_md_item_mon exp_tx_items[$];

  //queue to store Expected interuppts
  protected bit exp_irqs[$];

 
  //queue of process pointers
  local process process_exp_rx_response_watchdog[$];

  local process process_exp_tx_item_watchdog[$];

  local process process_exp_irq_watchdog[$];

  local process process_rcv_irq[$];


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
   exp_tx_items.delete();
   exp_irqs.delete();

   kill_processes_from_queue(process_exp_rx_response_watchdog);
   kill_processes_from_queue(process_exp_tx_item_watchdog);
   kill_processes_from_queue(process_exp_irq_watchdog);

   if(process_rcv_irq !=null) begin
    process_rcv_irq.kill();

    process_rcv_irq = null ;

    rcv_irq_nb();
   end


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
   exp_rx_responses.push_back(response);
   exp_rx_response_watchdog_nb(response);
     
   endfunction
     
    virtual function void write_port_in_model_tx(sv_md_item_mon item_mon);
    if(exp_rx_responses.size()>=1) begin
    `uvm_error("ALGORITHM ISSUE",$sformatf("Something went wrong as there are %0d entries in exp_tx_items queue and just received one more",exp_tx_responses.size()))
   end
   
   //if everything is alright ,push the response and start the task
   exp_tx_items.push_back(item_mon);
   exp_tx_item_watchdog_nb(item_mon);
     
    
   endfunction

    virtual function void write_port_in_model_irq(bit irq);

      if(exp_irqs.size()>=5) begin
    `uvm_error("ALGORITHM ISSUE",$sformatf("Something went wrong as there are %0d entries in exp_irqs queue and just received one more",exp_irqs.size()))
   end
   
   //if everything is alright ,push the response and start the task
   exp_irqs.push_back(irq);
   exp_irq_watchdog_nb(irq);
     
   endfunction

    virtual function void write_port_in_agent_rx(sv_md_item_mon item_mon);
      if(!item_mon.is_active()) begin
        sv_md_response exp_response = exp_rx_responses.pop_front();

      process_exp_rx_response_watchdog[0].kill();

      void'(process_exp_rx_response_watchdog.pop_front());

      if(item_mon.response != exp_response) begin
        `uvm_error("DUT_ERROR" , $sformatf("Mismatch detected for the RX response -> expected: %0s ,received: %0s , item: %0s",exp_response.name(),item_mon.response.name(),item_mon.convert2string()))
      end

      end

   endfunction

    virtual function void write_port_in_agent_tx(sv_md_item_mon item_mon);
      if(!item_mon.is_active()) begin
        sv_md_item_mon exp_item = exp_tx_items.pop_front();

      process_exp_rx_response_watchdog[0].kill();

      void'(process_exp_tx_item_watchdog.pop_front());
      
      //check data and size
      if(item_mon.data != exp_item.data) begin
        `uvm_error("DUT_ERROR" , $sformatf("Mismatch detected for the tX item -> expected: %0s ,received: %0s ",exp_item.convert2string(),item_mon.convert2string()))
      end
         //check offset
      if(item_mon.offset != exp_item.offset) begin
        `uvm_error("DUT_ERROR" , $sformatf("Mismatch detected for the tX item -> expected: %0s ,received: %0s ",exp_item.convert2string(),item_mon.convert2string()))
      end

      end
   endfunction

   //Task to collect irq information fromthe dut
   protected virtual task rcv_irq();
      sv_algn_vif vif = env_config.get_vif();

      forever begin
        @(posedge vif.clk iff (vif.irq && vif.reset_n));

        if(exp_irqs.size()==0) begin
          `uvm_error("DUT_ERROR","unexpectedirq detected")
        end
        else begin
          void'(exp_irq.pop_front());

          process_exp_irq_watchdog[0].kill();

          void'(process_exp_irq_watchdog.pop_front());
        end
      end
   endtask

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

       process_exp_rx_response_watchdog.push_back(p);

       exp_rx_response_watchdog(response);

       void'(process_exp_rx_response_watchdog.pop_front());

    end 
    join_none

   endfunction

    protected virtual task exp_tx_item_watchdog(sv_md_item_mon item);
     sv_algn_vif vif = env_config.get_vif();
     int unsigned threshold = env_config.get_exp_tx_item_threshold();
     time start_time =$time();

     repeat(threshold) begin
      @(posedge vif.clk);
     end
      //if control is able to come out of repeat loop implies error 
     `uvm_error("DUT_ERROR",$sformatf("The tx item, with value %0s , expectedfrom time %0t , was not received after %0d clock cycles",item.convert2string(),start_time,threshold))
  endtask

   protected virtual function void exp_tx_item_watchdog_nb(sv_md_item_mon item);
    
    fork begin
       
       process p = process::self();

       process_exp_tx_item_watchdog.push_back(p);

       exp_rx_response_watchdog(item);

       void'(process_exp_tx_item_watchdog.pop_front());

    end 
    join_none

   endfunction

   protected virtual task exp_irq_watchdog(bit irq);
     sv_algn_vif vif = env_config.get_vif();
     int unsigned threshold = env_config.get_exp_irq_threshold();
     time start_time =$time();

     repeat(threshold) begin
      @(posedge vif.clk);
     end
      //if control is able to come out of repeat loop implies error 
     `uvm_error("DUT_ERROR",$sformatf("The irq , expectedfrom time %0t , was not received after %0d clock cycles",start_time,threshold))
  endtask

   protected virtual function void exp_irq_watchdog_nb(bit irq );
    
    fork begin
       
       process p = process::self();

       process_exp_irq_watchdog.push_back(p);

       exp_irq_watchdog(irq);

       void'(process_exp_irq_watchdog.pop_front());

    end 
    join_none

   endfunction

   protected virtual function void rcv_irq_nb();

   if(process_rcv_irq != null) begin
    `uvm_fatal("ALGORITHM_ISSUE", "cannot starttwo instances of rcv_irq() task")
   end
    
    fork begin
       
       process process_rcv_irq = process::self();

       rcv_irq();

       process_rcv_irq.kill();

    end 
    join_none

   endfunction


  endclass

`endif 