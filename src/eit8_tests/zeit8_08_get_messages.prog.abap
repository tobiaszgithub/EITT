*&---------------------------------------------------------------------*
*& Report  zeit8_08_get_messages
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_08_get_messages.

DATA lo_amm TYPE REF TO zcl_eit1_amm_service.

DATA lo_system TYPE REF TO zcl_eit1_conf_system.

lo_system = NEW zcl_eit1_conf_system( iv_system_name = 'DEV_PXD_EXD' ).

lo_amm = NEW zcl_eit1_amm_service( iv_log_port_name = lo_system->ms_system-amm_logical_port ).

DATA ls_filter TYPE zst_eit1_amm_msg_list_filter.

ls_filter-from_date = sy-datum.
ls_filter-from_time = '000000'.
ls_filter-to_date = sy-datum.
ls_filter-to_time = '235959'.
"ls_filter-interface_name = 'LookupValueMessage_Out'.
ls_filter-sender_name = 'BS_EXD_200'.
DATA(lt_msgs) = lo_amm->zif_eit1_amm_service~get_message_list( is_filter = ls_filter ).

LOOP AT lt_msgs INTO DATA(ls_msg).
  WRITE: / 'message_id: ', ls_msg-message_id.
  WRITE: / 'message_key: ', ls_msg-message_key.
  "WRITE: / 'end_time: ', ls_msg-end_time.
  WRITE: / 'sender_name: ', ls_msg-sender_name.
  WRITE: / 'interface-name', ls_msg-interface_name.
  WRITE: / 'interface-namespace', ls_msg-interface_namespace.
  WRITE: / '==Message End=='.
  WRITE: /.
ENDLOOP.
