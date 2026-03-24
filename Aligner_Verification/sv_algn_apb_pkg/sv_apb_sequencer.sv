`ifndef SV_APB_SEQUENCER_SV
 `define SV_APB_SEQUENCER_SV

 class sv_apb_sequencer extends uvm_sequencer#(.REQ(sv_apb_item_drv));

  rand sv_apb_item_drv item;
    
    `uvm_component_utils(sv_apb_sequencer)

    function new(string name="", uvm_component parent);
     super.new(name,parent);
        
       item= sv_apb_item_drv::type_id::create("item"); 
    endfunction 

   virtual task body();
      `uvm_send(item)
    endtask
 endclass 

 endif