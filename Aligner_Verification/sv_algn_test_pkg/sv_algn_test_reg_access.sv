`ifndef SV_ALGN_TEST_REG_ACCESS_SV
 `define SV_ALGN_TEST_REG_ACCESS_SV

class sv_algn_test_reg_access extends uvm_test;
  
 
  `uvm_component_utils(sv_algn_test_reg_access)
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
    
  virtual task run_phase(uvm_phase phase);
 phase.raise_objection(this,"test_done");

  #(100ns);
  fork
    begin   //to drive reset
      sv_apb_vif vif = env.apb_agent.agent_config.get_vif();
    

      //now we drive reset after 3 apb transfers

      repeat(3) begin
        @(posedge vif.psel);
      end

      #(10ns)  ;
      vif.preset_n<=0 ;

      //driving reset back low

      repeat(4) begin
        @(posedge vif.pclk);
      end

      vif.preset_n <= 1;

    end
    begin
      sv_apb_sequence_simple seq_simple = sv_apb_sequence_simple::type_id::create("seq");

      void'(seq_simple.randomize());

      seq_simple.start(env.apb_agent.sequencer);
    end

    begin
      sv_apb_sequence_rw seq_rw = sv_apb_sequence_rw::type_id::create("seq");

      void'(seq_rw.randomize() with {
        item.addr='h0;
        item.data='h0011;
      });
    end
  join

  phase.drop_objection(this,"test_done");
  endtask
  
endclass

`endif
