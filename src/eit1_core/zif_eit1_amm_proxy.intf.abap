INTERFACE zif_eit1_amm_proxy
  PUBLIC .
  METHODS get_messages_by_ids
    IMPORTING
      input  TYPE zeit9_get_messages_by_ids_in_d
    EXPORTING
      output TYPE zeit9_get_messages_by_ids_out
    RAISING
      cx_ai_system_fault
      zeit9_cx_get_messages_by_ids_c .

  METHODS get_message_bytes_java_lang_st
    IMPORTING
      !input  TYPE zeit9_get_message_bytes_java_1
    EXPORTING
      !output TYPE zeit9_get_message_bytes_java_l
    RAISING
      cx_ai_system_fault
      zeit9_cx_get_message_bytes_jav
      zeit9_cx_get_message_bytes_ja1 .

  METHODS get_logged_message_bytes
    IMPORTING
      !input  TYPE zeit9_get_logged_message_byte1
    EXPORTING
      !output TYPE zeit9_get_logged_message_bytes
    RAISING
      cx_ai_system_fault
      zeit9_cx_get_logged_message_by
      zeit9_cx_get_logged_message_b1 .

  METHODS get_message_list
    IMPORTING
      !input  TYPE zeit9_get_message_list_in_doc
    EXPORTING
      !output TYPE zeit9_get_message_list_out_doc
    RAISING
      cx_ai_system_fault
      zeit9_cx_get_message_list_com .

  METHODS get_integration_flows
    IMPORTING
      !input  TYPE zeit9_get_integration_flows_in
    EXPORTING
      !output TYPE zeit9_get_integration_flows_ou
    RAISING
      cx_ai_system_fault
      zeit9_cx_get_integration_flows .
ENDINTERFACE.
