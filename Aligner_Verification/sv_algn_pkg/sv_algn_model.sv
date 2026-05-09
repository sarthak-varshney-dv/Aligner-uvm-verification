`ifndef SV_ALGN_MODEL_SV
 `define SV_ALGN_MODEL_SV

`uvm_analysis_imp_decl(_in_rx)
`uvm_analysis_imp_decl(_in_tx)



class sv_algn_model extends uvm_component implements sv_algn_reset_handler ;

sv_algn_env_config env_config ;

sv_algn_reg_block reg_block ;

//analysis ports and imp 

uvm_analysis_imp_in_rx#(sv_md_item_mon,sv_algn_model) port_in_rx ;

uvm_analysis_imp_in_tx#(sv_md_item_mon,sv_algn_model) port_in_tx ;

uvm_analysis_port#(sv_md_response) port_out_rx ;

uvm_analysis_port#(sv_md_response) port_out_tx ;

uvm_analysis_port#(bit) port_out_irq ;

protected bit exp_irq;


local process process_push_to_rx_fifo ;

local process process_build_buffer ;

local process process_align ;

protected uvm_tlm_fifo#(sv_md_item_mon) rx_fifo ;

protected uvm_tlm_fifo#(sv_md_item_mon) tx_fifo ;


// intermediate buffer containing information ready to be aligned 
protected sv_md_item_mon buffer[$];

`uvm_component_utils(sv_algn_model)

function new(string name = "",uvm_component parent);
  super.new(name,parent);

  port_in_rx   = new("port_in_rx",this);
  port_in_tx   = new("port_in_tx",this);
  port_out_rx  = new("port_out_rx",this);
  port_out_tx  = new("port_out_tx",this);
  port_out_irq = new("port_out_irq",this);

endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(reg_block == null) begin
    reg_block = sv_algn_reg_block::type_id::create("reg_block");

    
reg_block.build();
reg_block.lock_model();

 rx_fifo = new("rx_fifo",this,8);
 tx_fifo = new("tx_fifo",this,8);


end
endfunction

virtual function void connect_phase(uvm_phase phase)
 super.connect_phase(phase);

 sv_algn_clr_cnt_drop cbs= sv_algn_clr_cnt_drop::type_id::create("cbs");

 cbs.cnt_drop = reg_block.STATUS.CNT_DROP ;

 uvm_callbacks(uvm_reg_field , sv_algn_clr_cnt_drop)::add(reg_block.CTRL.CLR , cbs) ;
endfunction

virtual function void end_of_elaboration_phase(uvm_phase phase);
super.end_of_elaboration_phase(phase);

  reg_block.CTRL.SET_ALGN_DATA_WIDTH(env_config.get_algn_data_width());

endfunction

virtual function void kill_process(ref process p);

if( p != null) begin
  p.kill();

  p=null ;
end
endfunction

virtual function void handle_reset(uvm_phase phase);

    reg_block.handle_reset("HARD");

    rx_fifo.flush();
    tx_fifo.flush();
    buffer = {};

    kill_process(process_push_to_rx_fifo);
    kill_process(process_build_buffer);
    kill_process(process_align);


    build_buffer_nb();
    align_nb();

  endfunction

virtual function sv_md_response get_exp_response(sv_md_item_mon item);
    if(item.data.size() == 0) begin
                return SV_MD_ERR ;
           end

    elseif(item.data.size() + item.offset() > (env_config.get_algn_data_width()/8)) begin
                return SV_MD_ERR ;
            end

    elseif (((env_config.get_algn_data_width()/8)+ item.offset)%(item.data.size()) != 0 ) begin
            return SV_MD_ERR ;
                
            end
    else begin
      return SV_MD_OKAY ; 
    end   

endfunction

virtual function void set_max_drop();

  void'(reg_block.IRO.MAX_DROP.predict(1));

  
      `uvm_info("CNT_DROP", $sformatf("Drop counter reached max value - %0s: %0d",
                                   reg_block.IRQEN.MAX_DROP.get_full_name(),
                                      reg_block.IRQEN.MAX_DROP.get_mirrored_value()), UVM_MEDIUM)
      
      if(reg_block.IRQEN.MAX_DROP.get_mirrored_value() == 1) begin
        exp_irq = 1;
      end

endfunction

virtual function void set_rx_fifo_full();

  void'(reg_block.IRO.RX_FIFO_FULL.predict(1));

  
      `uvm_info("RX_FIFO_FULL", $sformatf("Rx FiFO became full - %0s: %0d",
                                   reg_block.IRQEN.RX_FIFO_FULL.get_full_name(),
                                      reg_block.IRQEN.RX_FIFO_FULL.get_mirrored_value()), UVM_NONE)
      
      if(reg_block.IRQEN.RX_FIFO_FULL.get_mirrored_value() == 1) begin
        exp_irq = 1;
      end

endfunction

virtual function void set_rx_fifo_empty();

  void'(reg_block.IRO.RX_FIFO_EMPTY.predict(1));

  
      `uvm_info("RX_FIFO_EMPTY", $sformatf("Rx FiFO became empty - %0s: %0d",
                                   reg_block.IRQEN.RX_FIFO_EMPTY.get_full_name(),
                                      reg_block.IRQEN.RX_FIFO_EMPTY.get_mirrored_value()), UVM_NONE)
      
      if(reg_block.IRQEN.RX_FIFO_EMPTY.get_mirrored_value() == 1) begin
        exp_irq = 1;
      end

endfunction

virtual function void set_tx_fifo_full();

  void'(reg_block.IRO.TX_FIFO_FULL.predict(1));

  
      `uvm_info("TX_FIFO_FULL", $sformatf("Tx FiFO became full - %0s: %0d",
                                   reg_block.IRQEN.TX_FIFO_FULL.get_full_name(),
                                      reg_block.IRQEN.TX_FIFO_FULL.get_mirrored_value()), UVM_NONE)
      
      if(reg_block.IRQEN.TX_FIFO_FULL.get_mirrored_value() == 1) begin
        exp_irq = 1;
      end

endfunction

virtual function void inc_cnt_drop(sv_md_response response);
uvm_reg_data_t max_value = ('h1 << reg_block.STATUS.CNT_DROP.get_n_bits()) - 1;
  
      if(reg_block.STATUS.CNT_DROP.get_mirrored_value() < max_value) begin
        void'(reg_block.STATUS.CNT_DROP.predict(reg_block.STATUS.CNT_DROP.get_mirrored_value() + 1));
        
        `uvm_info("CNT_DROP", $sformatf("Increment %9s: %0d due to: %0s",
                                     reg_block.STATUS.CNT_DROP.get_full_name(),
                                     reg_block.STATUS.CNT_DROP.get_mirrored_value,
                                        response.name()), UVM_LOW)
        
        if(reg_block.STATUS.CNT_DROP.get_mirrored_value() == max_value) begin
          set_max_drop();
        end
      end

endfunction

virtual function void inc_rx_level();
  
        void'(reg_block.STATUS.RX_LVL.predict(reg_block.STATUS.RX_LVL.get_mirrored_value() + 1));
        
        
        if(reg_block.STATUS.RX_LVL.get_mirrored_value() == rx_fifo.size()) begin
          set_rx_fifo_full();
        
      end

endfunction

virtual function void dec_rx_level();
  
        void'(reg_block.STATUS.RX_LVL.predict(reg_block.STATUS.RX_LVL.get_mirrored_value() - 1));
        
        
        if(reg_block.STATUS.RX_LVL.get_mirrored_value() == 0) begin
          set_rx_fifo_empty();
        
      end

endfunction
  
virtual function void inc_tx_level();
  
        void'(reg_block.STATUS.TX_LVL.predict(reg_block.STATUS.TX_LVL.get_mirrored_value() + 1));
        
        
        if(reg_block.STATUS.TX_LVL.get_mirrored_value() == tx_fifo.size()) begin
          set_tx_fifo_full();
        
      end

endfunction  

protected virtual task push_to_rx_fifo(sv_md_item_mon item);
  rx_fifo.put(item);

  inc_rx_level();

  `uvm_info("DEBUG" , $sformatf("RX FIFO push- new level : %0d , Pushed entry : %0s",reg_block.STATUS.RX_LVL.get_mirrored_value(),
                                              item.convert2string()),UVM_NONE);

  port_out_rx.write(SV_MD_OKAY);
endtask

protected virtual task pop_from_rx_fifo(ref sv_md_item_mon item);
  rx_fifo.get(item);

  dec_rx_level();

  `uvm_info("DEBUG" , $sformatf("RX FIFO pop- new level : %0d , Popped entry : %0s",reg_block.STATUS.RX_LVL.get_mirrored_value(),
                                              item.convert2string()),UVM_NONE);

endtask

protected virtual task push_to_tx_fifo(sv_md_item_mon item);
  tx_fifo.put(item);

  inc_tx_level();

  `uvm_info("DEBUG" , $sformatf("TX FIFO push- new level : %0d , Pushed entry : %0s",reg_block.STATUS.TX_LVL.get_mirrored_value(),
                                              item.convert2string()),UVM_NONE);

endtask


//Task to build the intermediate buffer 
protected virtual task build_buffer();
  sv_algn_vif vif = get_vif();

  forever begin
    int unsigned ctrl_size = reg_block.CTRL.SIZE.get_mirrored_value();

    if((buffer.sum() with (item.data.size())) < ctrl_size) begin
       sv_md_item_mon rx_item ;
        
       pop_from_rx_fifo(rx_item) ;

       buffer.push_back(rx_item);

    end
    else begin
      @(posedge vif.clk);
    end
  end
endtask

protected virtual task align () ;
  sv_algn_vif vif= agent_config.get_vif();
  
  forever begin
  uvm_reg_data_t ctrl_size = reg_block.CTRL.SIZE.get_mirrored_value();
  uvm_reg_data_t ctrl_offset = reg_block.CTRL.OFFSET.get_mirrored_value();

  uvm_wait_for_nba_region();
  
 if(ctrl_size <= (buffer.sum() with item.data.size())) begin
  while(ctrl_size <= (buffer.sum() with item.data.size() )) begin
    sv_md_item_mon tx_item = sv_md_item_mon::type_id::create("tx_item",this);

    tx_item.offset = ctrl_offset ;

    void'(tx_item.begin_tr(buffer[0].get_begin_tr()));

    while(tx_item.data.size() != ctrl_size) begin
      sv_md_item_mon buffer_item = buffer.pop_front();

      if(tx_item.data.size() + buffer_item.data.size() <= ctrl_size) begin
        foreach buffer_item.data[idx] begin
         tx_item.data.push_back(buffer_item.data[idx]) ;
        end
      
      if(tx_item.data.size() == ctrl_size) begin
        
        void'(tx_item.end_tr(buffer_item.get_end_time()));

        push_to_tx_fifo(tx_item);
      end
      end
    else begin      //if we need to split the item
      int unsigned num_bytes_needed = ctrl_size - tx_item.size();
      sv_md_item_mon splitted_items[$];

      split(num_bytes_needed,buffer_item,splitted_items);
      buffer.push_back(splitted_items[1]);
      buffer.push_back(splitted_items[0]);
    end
    end
  end
  end
  else begin
    @(posedge vif.clk);
  end
  end
endtask

protected virtual function void split(int unsigned num_bytes , sv_md_item_mon item , ref sv_md_item_mon items[$]);
   if(num_bytes ==0 || num_bytes >= item.data.size()) begin
    `uvm_fatal("ALGORITHM_ISSUE","cannot split the item : invalid num_bytes_needed value")
   end

   for(int i=0 ; i<2 ; i++) begin
    sv_md_item_mon splitted_item = sv_md_item_mon::type_id::create("splitted_item",this);

    if(i == 0) begin
      splitted_item.offset = item.offset ;

      
      for(int j=0 ; j<num_bytes;j++) begin
        splitted_item.data.push_back(item.data[j]);
      end
    end
    else begin
      splitted_item.offset = item.offset + num_bytes ;

      for(int j=num_bytes ; j<item.data.size();j++) begin
        splitted_item.data.push_back(item.data[j]);
      end
      
    end

      splitted_item.prev_item_delay = item.prev_item_delay ; 
      splitted_item.length = item.length ; 
      splitted_item.response = item.response ; 
     
      void'(splitted_item.begin_tr(item.get_begin_tr()));    

      if(!item.is_active()) begin
        void'(splitted_item.end_tr(item.get_end_tr()));    
      end

      items.push_back(splitted_item) ;
   end


endfunction

local virtual function push_to_rx_fifo_nb(sv_md_item_mon item);

if(process_push_to_rx_fifo != null) begin
  `uvm_fatal("ALGORITHM_ISSUE","cannot start two instances of push_to_rx_fifo() task")
end

fork 
  begin
    process_push_to_rx_fifo  = process::self();

    push_to_rx_fifo(item);

    process_push_to_rx_fifo = null;
  end
join_none
endfunction

local virtual function build_buffer_nb();

if(process_build_buffer != null) begin
  `uvm_fatal("ALGORITHM_ISSUE","cannot start two instances of build_buffer() task")
end

fork 
  begin
    process_build_buffer  = process::self();

    build_buffer();

    process_build_buffer = null;
  end
join_none
endfunction

local virtual function align_nb();

if(process_align != null) begin
  `uvm_fatal("ALGORITHM_ISSUE","cannot start two instances of process_align() task")
end

fork 
  begin
    process_align  = process::self();

    align();

    process_align = null;
  end
join_none
endfunction



virtual function void write_in_rx(sv_md_item_mon item_mon);

//`uvm_info("DEBUG", $sformatf("Model received information from RX agent : %0s",item.convert2string()),UVM_NONE);

if(item_mon.is_active()) begin
sv_md_response exp_response = get_exp_response(item_mon);

case(exp_response)
   SV_MD_ERR : begin
    inc_cnt_drop(exp_response);

    port_out_rx.write(exp_response); //informing the scoreboard
   end

   SV_MD_OKAY : begin
    push_to_rx_fifo_nb(item_mon)
   end
   default : begin
    `uvm_fatal("DEBUG", $sformatf("Unsupported value for response : %0s",exp_response.name()),UVM_NONE);
   end
endcase

end

endfunction

virtual function void write_in_tx(sv_md_item_mon item);

endfunction


endclass

 `endif 