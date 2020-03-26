FUNCTION ZEIT2_MESSAGE_SELECTOR.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IS_FILTER) TYPE  ZST_EIT1_AMM_MSG_LIST_FILTER
*"     REFERENCE(IV_SYSTEM_NAME) TYPE  ZDE_EITT_SYSTEM_NAME
*"  EXPORTING
*"     REFERENCE(ES_SELECTED_MSG) TYPE  ZST_EIT1_MSG_LIST_RESULT
*"     REFERENCE(ET_SELECTED_MSGS) TYPE  ZTT_EIT1_AMM_MSG_LIST_RESULT
*"----------------------------------------------------------------------
  gs_filter = is_filter.
  gv_system_name = iv_system_name.
  CALL SCREEN 100 STARTING AT 10 08.

  IF go_amm_msg_list IS BOUND.
    es_selected_msg =  go_amm_msg_list->ms_selected_msg.
    et_selected_msgs = go_amm_msg_list->mt_selected_msgs.
  ENDIF.
ENDFUNCTION.
