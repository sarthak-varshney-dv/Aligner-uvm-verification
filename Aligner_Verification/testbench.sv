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
    #3;
    apb_if.preset_n=0;
    #30;
    apb_if.preset_n=1;
  end
  
  //APB INTERFACE HANDLE
    sv_apb_interface apb_if(.pclk(clk));

  //MD RX INTERFACE HANDLE
    sv_md_interface#(32) md_rx_if(.clk(clk)) ;

  //MD TX INTERFACE HANDLE
    sv_md_interface#(32) md_tx_if(.clk(clk)) ;
  

  assign md_rx_if.reset_n = apb_if.preset_n ;
  assign md_tx_if.reset_n = apb_if.preset_n ;
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
     
  uvm_config_db#(virtual sv_apb_interface)::set(null,"uvm_test_top.env.apb_agent","vif",apb_if);
  //when instantiate apb_agent, use name apb_agent 
    
  uvm_config_db#(virtual md_rx_if#(32))::set(null,"uvm_test_top.env.md_rx_agent","vif",md_rx_if);

  uvm_config_db#(virtual md_tx_if#(32))::set(null,"uvm_test_top.env.md_tx_agent","vif",md_tx_if);
    
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
    .pslverr(apb_if.pslverr),

    .md_rx_valid(md_rx_if.valid),
    .md_rx_ready(md_rx_if.ready),
    .md_rx_size(md_rx_if.size),
    .md_rx_data(md_rx_if.data),
    .md_rx_offset(md_rx_if.offset),
    .md_rx_err(md_rx_if.err),
    
    .md_tx_valid(md_tx_if.valid),
    .md_tx_ready(md_tx_if.ready),
    .md_tx_size(md_tx_if.size),
    .md_tx_data(md_tx_if.data),
    .md_tx_offset(md_tx_if.offset),
    .md_tx_err(md_tx_if.err)
  );
  
  
  
endmodule