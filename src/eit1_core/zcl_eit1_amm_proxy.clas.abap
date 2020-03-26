CLASS zcl_eit1_amm_proxy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_eit1_amm_proxy.
    METHODS constructor
      IMPORTING
        logical_port_name TYPE prx_logical_port_name OPTIONAL
      RAISING
        cx_ai_system_fault .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mo_amm_proxy TYPE REF TO zeit9_co_adapter_message_monit.
ENDCLASS.

CLASS zcl_eit1_amm_proxy IMPLEMENTATION.
  METHOD zif_eit1_amm_proxy~get_messages_by_ids.
    mo_amm_proxy->get_messages_by_ids(
      EXPORTING
        input = input
      IMPORTING
        output = output
    ).
  ENDMETHOD.

  METHOD zif_eit1_amm_proxy~get_message_bytes_java_lang_st.
    mo_amm_proxy->get_message_bytes_java_lang_st(
      EXPORTING
        input = input
      IMPORTING
        output = output
    ).

  ENDMETHOD.

  METHOD zif_eit1_amm_proxy~get_logged_message_bytes.
    mo_amm_proxy->get_logged_message_bytes(
      EXPORTING
        input = input
      IMPORTING
        output = output
    ).

  ENDMETHOD.

  METHOD zif_eit1_amm_proxy~get_message_list.
    mo_amm_proxy->get_message_list(
      EXPORTING
        input = input
      IMPORTING
        output = output
    ).

  ENDMETHOD.

  METHOD zif_eit1_amm_proxy~get_integration_flows.
    mo_amm_proxy->get_integration_flows(
      EXPORTING
        input = input
      IMPORTING
        output = output
    ).
  ENDMETHOD.

  METHOD constructor.
    mo_amm_proxy = NEW zeit9_co_adapter_message_monit(
        logical_port_name = logical_port_name
    ).
  ENDMETHOD.

ENDCLASS.
