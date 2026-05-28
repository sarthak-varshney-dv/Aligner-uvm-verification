`ifndef SV_ALGN_COVERAGE_SV
  `define SV_ALGN_COVERAGE_SV

  `uvm_analysis_imp_decl(in_split_info)

  class sv_algn_coverage extends uvm_component implements sv_algn_reset_handler ;

  uvm_analysis_imp_in_split_info#(sv_algn_split_info , sv_algn_coverage) port_in_split_info ;

  covergroup cover_split with function sample(sv_algn_split_info info);
    
    option.per_instance = 1 ;

    ctrl_offset : coverpoint info.ctrl_offset {
        option.comment=" Value of ctrl_offset";

        bins value[] = {[1:4]};
    }
    
       ctrl_size : coverpoint info.ctrl_size {
        option.comment=" Value of ctrl_size";

        bins value[] = {[1:4]};
    }

       item_offset : coverpoint info.item_offset {
        option.comment=" Value of item_offset";

        bins value[] = {[1:4]};
    }

       item_size : coverpoint info.item_size {
        option.comment=" Value of item_size";

        bins value[] = {[1:4]};
    }

       num_bytes_needed : coverpoint info.num_bytes_needed {
        option.comment=" Value of num_bytes_needed";

        bins value[] = {[1:3]};
    }

   cross ctrl_offset,ctrl_size,item_offset,item_size,num_bytes_needed {
    ignore_bins = 
   }
  endgroup

  `uvm_component_utils(sv_algn_coverage) 

  function new(string name = "" , uvm_component parent) ;
    super.new(name , parent);

    cover_split = new("cover_split");
    cover_split.set_inst_name($sformatf(%s_%s,get_full_name(),"cover_split"));
  endfunction

 virtual function void write_in_split_info();

    

 endfunction


  endclass

`endif 