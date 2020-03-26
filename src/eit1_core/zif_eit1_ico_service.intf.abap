INTERFACE zif_eit1_ico_service
  PUBLIC .
  METHODS send
    IMPORTING iv_payload         TYPE string
    RETURNING VALUE(rs_response) TYPE zst_eit1_ico_service_res
    RAISING   zcx_eit1_exception.
ENDINTERFACE.
