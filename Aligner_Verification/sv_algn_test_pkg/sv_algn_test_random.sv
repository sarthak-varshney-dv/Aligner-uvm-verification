`ifndef SV_ALGN_TEST_RANDOM_SV
 `define SV_ALGN_TEST_RANDOM_SV

class sv_algn_test_random extends sv_algn_test_base;
  
  `uvm_component_utils(sv_algn_test_random)
  
  function new(string name= "" , uvm_component parent);
      super.new(name,parent);
      
   endfunction
  
  virtual task run_phase(uvm_phase phase);
 
  phase.raise_objection(this."test_done");

  #(100ns);
   begin
      sv_md_sequence_base_master seq= sv_md_sequence_base_master::type_id::create("seq");
      seq.set_sequencer(env.md_rx_agent.sequencer);

      repeat(10) begin
         void'(randomize(seq));

      seq.start(env.md_rx_agent.sequencer);

      end
   end

  phase.drop_objection(this."test_done");


  endtask
endclass

`endif