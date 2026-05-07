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

protected uvm_tlm_fifo#(sv_md_item_mon) rx_fifo ;

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

    kill_process(process_push_to_rx_fifo);

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

  
      `uvm_info("RX_FIFO_FULL", $sformatf("Rx FiFO reached max value - %0s: %0d",
                                   reg_block.IRQEN.RX_FIFO_FULL.get_full_name(),
                                      reg_block.IRQEN.RX_FIFO_FULL.get_mirrored_value()), UVM_MEDIUM)
      
      if(reg_block.IRQEN.RX_FIFO_FULL.get_mirrored_value() == 1) begin
        exp_irq = 1;
      end

endfunction

virtual function void set_rx_fifo_empty();

  void'(reg_block.IRO.RX_FIFO_EMPTY.predict(1));

  
      `uvm_info("RX_FIFO_EMPTY", $sformatf("Rx FiFO reached min value - %0s: %0d",
                                   reg_block.IRQEN.RX_FIFO_EMPTY.get_full_name(),
                                      reg_block.IRQEN.RX_FIFO_EMPTY.get_mirrored_value()), UVM_MEDIUM)
      
      if(reg_block.IRQEN.RX_FIFO_EMPTY.get_mirrored_value() == 1) begin
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
  
virtual



protected virtual task push_to_rx_fifo(sv_md_item_mon item);
  rx_fifo.put(item);

  inc_rx_level();

  `uvm_info("DEBUG" , $sformatf("RX FIFO push- new level : %0d , Pushed entry : %0s",reg_block.STATUS.RX_LVL.get_mirrored_value(),
                                              item.convert2string()),UVM_NONE);

  port_out_rx.write(SV_MD_OKAY);
endtask

local function push_to_rx_fifo_nb(sv_md_item_mon item);

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