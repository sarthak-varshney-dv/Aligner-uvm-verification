`ifndef SV_ALGN_COVERAGE_SV
  `define SV_ALGN_COVERAGE_SV

  `uvm_analysis_imp_decl(in_split_info)

  class sv_algn_coverage extends uvm_component implements sv_algn_reset_handler ;

  uvm_analysis_imp_in_split_info#(sv_algn_split_info , sv_algn_coverage) port_in_split_info ;

  `uvm_component_utils(sv_algn_coverage) 

  function new(string name = "" , uvm_component parent) ;
    super.new(name , parent);
  endfunction

 virtual function void write_in_split_info();

    

 endfunction


  endclass

`endif 