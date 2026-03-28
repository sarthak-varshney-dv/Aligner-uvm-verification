`ifndef SV_APB_SEQUENCER_SV
 `define SV_APB_SEQUENCER_SV

 class sv_apb_sequencer extends uvm_sequencer#(.REQ(sv_apb_item_drv))  implements cfs_apb_reset_handler;

  rand sv_apb_item_drv item;
    
    `uvm_component_utils(sv_apb_sequencer)

    function new(string name="", uvm_component parent);
     super.new(name,parent);
        
       item= sv_apb_item_drv::type_id::create("item"); 
    endfunction 

   virtual task body();
      `uvm_send(item)
    endtask


     virtual function void handle_reset(uvm_phase phase);
        int objections_count;
        stop_sequences();

        objections_count = uvm_test_done.get_objection_count(this);

        if(objections_count > 0) begin
          uvm_test_done.drop_objection(this, $sformatf("Dropping %0d objections at reset", objections_count), objections_count);
        end

        start_phase_sequence(phase); //restart
      endfunction
 endclass 

 endif