`ifndef SV_APB_INTERFACE_SV
 `define SV_APB_INTERFACE_SV

 `ifndef SV_APB_MAX_DATA_WIDTH
 `define SV_APB_MAX_DATA_WIDTH 32
   `endif

 `ifndef SV_APB_MAX_ADDR_WIDTH
 `define SV_APB_MAX_ADDR_WIDTH 16
   `endif

interface sv_apb_interface(input pclk);
  
  logic preset_n;
  
  logic [`SV_APB_MAX_DATA_WIDTH-1:0] pwdata;
  
  logic [`SV_APB_MAX_DATA_WIDTH-1:0] prdata; 
  
  logic [`SV_APB_MAX_ADDR_WIDTH-1:0] paddr;
  
  logic pwrite;
  
  logic psel;
  
  logic penable;
  
  logic pready;
  
  logic pslverr;
  
  
  bit has_checks;

  initial begin
    has_checks = 1;
  end


sequence setup_phase_s;
  
   ((psel == 1) && ($past(psel)==0)) || ((psel == 1) && ($past(pready)==1));
endsequence

sequence access_phase_s;
   
   (psel==1) && (penable == 1);
endsequence

property penable_at_setup_phase_p;
   
   @(posedge pclk) disable iff (!preset_n || !has_checks)
   setup_phase_s |-> (penable ==0);
endproperty

PENABLE_AT_SETUP_PHASE_A : assert property(penable_at_setup_phase_p) else
             $error("PENABLE at \"Setup Phase\" is not equal to 0");

property penable_entering_access_phase_p;
   
   @(posedge pclk) disable iff (!preset_n || !has_checks)
   setup_phase_s |=> (penable == 1);
endproperty

PENABLE_ENTERING_ACCESS_PHASE_A : assert property(penable_entering_access_phase_p) else
            $error("PENABLE when entering \"Access Phase\" is not equal to 1");


property penable_exiting_access_phase;
   @(posedge pclk) disable iff (!preset_n || !has_checks)
   access_phase_s and (pready == 1) |=> (penable == 0);
endproperty

PENABLE_EXITING_ACCESS_PHASE_A : assert property(penable_exiting_access_phase_p) else
           $error("PENABLE when exiting \"Access Phase\" is not equal to 0");



// MASTER DRIVEN SIGNALS SHOULD REMAIN CONSTANT THROUGHOUT THE TRANSFER

property paddr_stable_at_access_phase_p;

   @(posedge pclk) disable iff (!preset_n || !has_checks)
   access_phase_s |-> $stable(paddr);
endproperty

PADDR_STABLE_AT_ACCESS_PHASE_A : asert property(paddr_stable_at_access_phase_p) else 
             $error("Paddr did not remain stable in \"Access Phase\" ");

property pwdata_stable_at_access_phase_p;

   @(posedge pclk) disable iff (!preset_n || !has_checks)
   access_phase_s and (pwrite == 1) |-> $stable(pwdata);
endproperty

PWDATA_STABLE_AT_ACCESS_PHASE_A : asert property(pwdata_stable_at_access_phase_p) else 
             $error("Pwdata did not remain stable in \"Access Phase\" ");             
  
  property pwrite_stable_at_access_phase_p;

   @(posedge pclk) disable iff (!preset_n || !has_checks)
   access_phase_s |-> $stable(pwrite);
endproperty

PWRITE_STABLE_AT_ACCESS_PHASE_A : asert property(pwrite_stable_at_access_phase_p) else 
             $error("Pwrite did not remain stable in \"Access Phase\" ");


//Assertions for unknown values.

property unknown_value_psel_p ;
 @(posedge pclk) disable iff (!preset_n || !has_checks)
 $isunknown(psel) == 0 ;
endproperty

UNKNOWN_VALUE_PSEL_A : assert property (unknown_value_psel_p) else
                   $error("Detected unknown value of APB signal PSEL");

property unknown_value_penable_p ;
 @(posedge pclk) disable iff (!preset_n || !has_checks)
 psel ==1 |-> $isunknown(penable) == 0 ;   //we just care about it when in access phase.
endproperty

UNKNOWN_VALUE_PENABLE_A : assert property (unknown_value_penable_p) else
                   $error("Detected unknown value of APB signal PENABLE");                    


property unknown_value_paddr_p ;
 @(posedge pclk) disable iff (!preset_n || !has_checks)
 psel ==1 |-> $isunknown(paddr) == 0 ;   //we just care about it when in data or access phase.
endproperty

UNKNOWN_VALUE_PADDR_A : assert property (unknown_value_paddr_p) else
                   $error("Detected unknown value of APB signal PENABLE");  

property unknown_value_pwdata_p ;
 @(posedge pclk) disable iff (!preset_n || !has_checks)
 (psel ==1) && (pwrite == 1) |-> $isunknown(pwdata) == 0 ;   //we just care about it when in access phase and pwrite =1.
endproperty

UNKNOWN_VALUE_PWDATA_A : assert property (unknown_value_pwdata_p) else
                   $error("Detected unknown value of APB signal PWDATA");  


property unknown_value_prdata_p ;
 @(posedge pclk) disable iff (!preset_n || !has_checks)
 (psel ==1) && (pwrite == 0) &&(pready == 1 ) && (pslverr == 0) |-> $isunknown(prdata) == 0 ;   //we just care about it when in access phase ,pwrite =0 ,pready =1 and pslverr=0 .
endproperty

UNKNOWN_VALUE_PRDATA_A : assert property (unknown_value_prdata_p) else
                   $error("Detected unknown value of APB signal PRDATA");  



property unknown_value_pready_p ;
 @(posedge pclk) disable iff (!preset_n || !has_checks)
 psel ==1 |-> $isunknown(pready) == 0 ;   //we just care about it when in data or access phase.
endproperty

UNKNOWN_VALUE_PREADY_A : assert property (unknown_value_pready_p) else
                   $error("Detected unknown value of APB signal PREADY");  


property unknown_value_pslverr_p ;
 @(posedge pclk) disable iff (!preset_n || !has_checks)
 (psel ==1) && (pready == 1) |-> $isunknown(pslverr) == 0 ;   //we just care about it when in access phase when pready =1.
endproperty

UNKNOWN_VALUE_PSLVERR_A : assert property (unknown_value_pslverr_p) else
                   $error("Detected unknown value of APB signal PSLVERR");  




endinterface

`endif