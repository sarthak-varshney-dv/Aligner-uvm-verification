`include "sv_algn_test_pkg.sv"

module testbench();
  
  import uvm_pkg::*;
  import sv_algn_test_pkg::*;
  
  
  reg clk;
  
 // always #5 clk=~clk;   //for clock. cristan has declared clong in a long form
  
  initial begin
    clk =0;
    forever begin
      clk= #5ns ~clk;
    end
  end
  
  
  initial begin
    apb_if.preset_n=1;
    #6;
    apb_if.preset_n=0;
    #30;
    apb_if.preset_n=1;
  end
  
  //INTERFACE HANDLE
    sv_apb_interface apb_if(.pclk(clk));

  
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
     
  uvm_config_db#(virtual sv_apb_interface)::set(null,"uvm_test_top.env.apb_agent","vif",apb_if);
  //when instantiate apb_agent, use name apb_agent 
    
    
    
    run_test("  ");
  end
  
  cfs_aligner dut(
    .clk(clk) ,
    .reset_n(apb_if.preset_n),
    
    .paddr(apb_if.paddr),
    .pwrite(apb_if.pwrite),
    .psel(apb_if.psel),
    .penable(apb_if.penable),
    .pwdata(apb_if.pwdata),
    .pready(apb_if.pready),
    .prdata(apb_if.prdata),
    .pslverr(apb_if.pslverr)
    
  );
  
  
  
endmodule