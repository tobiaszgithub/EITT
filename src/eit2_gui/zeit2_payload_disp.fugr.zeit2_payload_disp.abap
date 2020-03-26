FUNCTION ZEIT2_PAYLOAD_DISP.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PRI) TYPE  STRING
*"     REFERENCE(IV_SEC) TYPE  STRING
*"     REFERENCE(IV_PAYLOAD_GUID) TYPE  ZDE_EITT_MSGGUID
*"----------------------------------------------------------------------

gv_pri = iv_pri.
gv_sec = iv_sec.
gv_payload_guid = iv_payload_guid.

CALL SCREEN 100 STARTING AT 10 08.



ENDFUNCTION.
