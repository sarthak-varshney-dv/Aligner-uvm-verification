`ifndef SV_APB_TYPES_SV
 `define SV_APB_TYPES_SV

typedef virtual sv_apb_interface sv_apb_vif;

typedef bit[`SV_APB_MAX_DATA_WIDTH-1:0] sv_apb_data;

typedef bit[`SV_APB_MAX_ADDR_WIDTH-1:0] sv_apb_addr;

typedef enum {SV_APB_READ=0 , SV_APB_WRITE=1} sv_apb_dir;

typedef enum {SV_APB_ERR=0 , SV_APB_OK=1}  sv_apb_response;

`endif