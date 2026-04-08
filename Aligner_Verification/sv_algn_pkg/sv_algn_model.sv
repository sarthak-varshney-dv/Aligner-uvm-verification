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



virtual function void handle_reset(uvm_phase phase);

    reg_block.handle_reset("HARD");
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

virtual function void inc_cnt_drop();
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
  
virtual function void write_in_rx(sv_md_item_mon item);

endfunction

virtual function void write_in_tx(sv_md_item_mon item);

endfunction


endclass

 `endif 