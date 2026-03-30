`ifndef SV_MD_AGENT_CONFIG_SV
 `define  SV_MD_AGENT_CONFIG_SV

 class sv_md_agent_config#(int unsigned DATA_WIDTH = 32) extends uvm_component ;

  typedef virtual sv_md_if#(DATA_WIDTH) sv_md_vif ;
  
  local sv_md_vif vif;

  local uvm_active_passive_enum active_passive;

  local bit has_checks;

  local bit has_coverage;
  
  local 
  `uvm_component_param_utils(sv_md_agent_config#(DATA_WIDTH))
  
  function new(string name="" , uvm_component parent);
      super.new(name,parent);

      active_passive = UVM_ACTIVE;
      has_checks=1;
      has_coverage=1;
      
   endfunction
  
 virtual function void set_vif(sv_md_vif value);
    if(vif==null) begin
    vif=value;
    set_has_checks(get_has_checks());      //to set the has checks value in the interface only when vif is not null.
    
    end
    else begin
      `uvm_fatal("ALGORITHM_ISSUE","trying to set interface more than once")
    end
  endfunction
  
  virtual function sv_md_vif get_vif();
     return vif;
  endfunction

  virtual function uvm_active_passive_enum get_active_passive()
     return active_passive;
  endfunction

  virtual function void set_active_passive(uvm_active_passive_enum value);
     active_passive=value;
  endfunction

  virtual function void set_has_checks(bit value);
  has_checks=value;
   if(vif != null) begin                 // To synchronize has_cheks of agent config and the interface.
    vif.has_checks = has_checks;
  end
  endfunction

  virtual function bit get_has_checks()
  return has_checks;
  endfunction

  virtual function void set_has_coverage(bit value);
  has_coverage=value;

  endfunction

  virtual function bit get_has_coverage()
  return has_coverage;
  endfunction


  virtual task wait_reset_start()  //Asynchronous reset 
  if(vif.reset_n !=0)begin
   @(negedge vif.reset_n);
  end
  endtask

  virtual task wait_reset_end() //synchronous
  while(vif.reset_n == 0) begin
   @(posedge vif.clk) ;
  end
  endtask

  virtual function void run_phase(uvm_phase phase);
    forever begin
    @(vif.has_checks) ;

    if(vif.has_checks != has_checks) begin
      `uvm_error("ALOGORITHM_ISSUE","can't chage value of has checks directly from the interface")
    end

    end
  


  endfunction



 endclass

 `endif