`ifndef SV_ALGN_TEST_BASE_SV
 `define SV_ALGN_TEST_BASE_SV

class sv_algn_test_base extends uvm_test;
  
  // Environment handler
   sv_algn_env env ;
  `uvm_component_utils(sv_algn_test_base)
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env = sv_algn_env::type_id::create("env",this);
    
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
