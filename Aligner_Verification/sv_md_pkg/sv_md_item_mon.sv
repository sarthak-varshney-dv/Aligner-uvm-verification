`ifndef SV_MD_ITEM_MON_SV
 `define SV_MD_ITEM_MON_SV

class sv_md_item_mon extends sv_md_item_base ;

int unsigned length ;

int unsigned prev_item_delay ;

bit [7:0] data[$] ;

int unsigned offset ;

int unsigned size ;

sv_md_response response ;

`uvm_object_utils(sv_md_item_mon)

function new(string name ="");
    super.new(name);
    
endfunction

virtual function void string convert2string();

string data_as_string = "{";

foreach(data[idx]) begin

data_as_string = $sformatf(" %0s'h%02x%0s",data_as_string,data[idx],idx==data.size()-1?"":",");

data_as_string = $sformatf("%0s }",data_as_string);

end

return $sformatf("[%0t..%0s] data: %0s, offset: %0d, response: %0s, length: %0d, prev_item_delay= %0d ",
                      get_begin_time(),is_active()?"":$sformatf("%0t",get_end_time()),
                      data_as_string,offset,response.name(),length,prev_item_delay);

endfunction


endclass

 `endif