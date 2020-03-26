CLASS zcl_eit1_amm_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_eit1_amm_service.
    METHODS constructor
      IMPORTING
        iv_log_port_name TYPE prx_logical_port_name
        io_amm_proxy     TYPE REF TO zif_eit1_amm_proxy OPTIONAL.
    METHODS: get_payload_by_id
      IMPORTING
        iv_message_id         TYPE string OPTIONAL
        iv_reference_id       TYPE string OPTIONAL
        iv_version            TYPE string
      RETURNING
        VALUE(rs_msg_payload) TYPE zst_eit1_content
      RAISING
        zcx_eit1_exception .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_log_port_name TYPE  prx_logical_port_name.
    DATA mo_amm_proxy TYPE REF TO zif_eit1_amm_proxy.
ENDCLASS.



CLASS zcl_eit1_amm_service IMPLEMENTATION.


  METHOD constructor.

    me->mv_log_port_name = iv_log_port_name.
    me->mo_amm_proxy = io_amm_proxy.

    IF mo_amm_proxy IS NOT BOUND.
      me->mo_amm_proxy = NEW zcl_eit1_amm_proxy( "zeit9_co_adapter_message_monit(
           logical_port_name = mv_log_port_name
      ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_eit1_amm_service~get_message_list.
    DATA: ls_input  TYPE zeit9_get_message_list_in_doc,
          ls_output TYPE zeit9_get_message_list_out_doc.

    ls_input-filter-archive = abap_false.
    CONVERT DATE is_filter-from_date TIME is_filter-from_time
        INTO TIME STAMP ls_input-filter-from_time TIME ZONE sy-zonlo.
    CONVERT DATE is_filter-to_date TIME is_filter-to_time
        INTO TIME STAMP  ls_input-filter-to_time TIME ZONE sy-zonlo.
    ls_input-filter-interface-name = is_filter-interface_name.
    ls_input-filter-interface-namespace = is_filter-interface_namespace.
    ls_input-filter-sender_name = is_filter-sender_name.
    "ls_input-filter-date_type = 0.
    "ls_input-filter-sender_interface-name
    ls_input-max_messages = 100.

    mo_amm_proxy->get_message_list(
      EXPORTING
        input                         = ls_input
      IMPORTING
        output                        = ls_output
    ).

    LOOP AT ls_output-response-list-adapter_framework_data INTO DATA(ls_msg).
      APPEND INITIAL LINE TO rt_result ASSIGNING FIELD-SYMBOL(<ls_result>).
      <ls_result>-message_id = ls_msg-message_id.
      <ls_result>-message_key = ls_msg-message_key.
      <ls_result>-interface_name = ls_msg-interface-name.
      <ls_result>-interface_namespace = ls_msg-interface-namespace.
      <ls_result>-sender_name = ls_msg-sender_name.

      CONVERT TIME STAMP ls_msg-end_time TIME ZONE sy-zonlo INTO
       DATE <ls_result>-end_date TIME <ls_result>-end_time.
      <ls_result>-integration_identifier = ls_msg-scenario_identifier.
    ENDLOOP.

    IF rt_result IS NOT INITIAL.
      DATA ls_flows_input TYPE zeit9_get_integration_flows_in.
      DATA ls_flows_output TYPE zeit9_get_integration_flows_ou.

      ls_flows_input-language = 'EN'.
      mo_amm_proxy->get_integration_flows(
        EXPORTING
          input   = ls_flows_input
        IMPORTING
          output  = ls_flows_output
      ).

      LOOP AT rt_result ASSIGNING <ls_result>.
        <ls_result>-integration_scenario = VALUE #( ls_flows_output-response-integration_flow[
                                                id = <ls_result>-integration_identifier ]-name OPTIONAL ).
      ENDLOOP.
*          CATCH cx_ai_system_fault.    "
*          CATCH zeit9_cx_get_integration_flows.    "
    ENDIF.


*      CATCH cx_ai_system_fault.    "
*      CATCH zeit9_cx_get_message_list_com.    "
  ENDMETHOD.


  METHOD get_payload_by_id.
    DATA: ls_messages_by_ids_input  TYPE zeit9_get_messages_by_ids_in_d,
          ls_messages_by_ids_output TYPE zeit9_get_messages_by_ids_out,
          ls_message_bytes_input    TYPE zeit9_get_message_bytes_java_1,
          ls_message_bytes_output   TYPE zeit9_get_message_bytes_java_l,
          lx_exc                    TYPE REF TO zcx_eit1_exception.
    lx_exc = NEW #( ).
    DATA(lv_message_id) = iv_message_id.
    IF lv_message_id IS NOT INITIAL.
      ls_messages_by_ids_input-message_ids = VALUE #( string = VALUE #( ( lv_message_id ) ) ).
    ENDIF.
    IF iv_reference_id IS NOT INITIAL.
      ls_messages_by_ids_input-reference_ids = VALUE #( string = VALUE #( ( iv_reference_id ) ) ).
    ENDIF.
    ls_messages_by_ids_input-archive = abap_false.

    mo_amm_proxy->get_messages_by_ids(
      EXPORTING
        input                          = ls_messages_by_ids_input
      IMPORTING
        output                         = ls_messages_by_ids_output
    ).

    DATA(lv_message_key) = VALUE #(
        ls_messages_by_ids_output-response-list-adapter_framework_data[ 1 ]-message_key OPTIONAL ).
*       CATCH cx_ai_system_fault.    "
*       CATCH zeit9_cx_get_messages_by_ids_c.    "
    IF lv_message_key IS INITIAL.
      RETURN.
    ENDIF.

    DO 5 TIMES.
      "IF iv_version EQ '0' OR iv_version EQ '-1'.
*        ls_message_bytes_input-archive = abap_false.
*        ls_message_bytes_input-message_key = lv_message_key.
*        ls_message_bytes_input-version = iv_version.
*
*
*        mo_amm_proxy->get_message_bytes_java_lang_st(
*          EXPORTING
*            input                          = ls_message_bytes_input
*          IMPORTING
*            output                         = ls_message_bytes_output
*        ).
      "ELSE.
      DATA ls_logged_message_input TYPE zeit9_get_logged_message_byte1.
      DATA ls_logged_message_output TYPE zeit9_get_logged_message_bytes.
      ls_logged_message_input-archive = abap_false.
      ls_logged_message_input-message_key = lv_message_key.
      ls_logged_message_input-version = iv_version.
      TRY.
          mo_amm_proxy->get_logged_message_bytes(
            EXPORTING
              input                          = ls_logged_message_input
            IMPORTING
              output                         = ls_logged_message_output
          ).


        CATCH zeit9_cx_get_logged_message_by  INTO DATA(lx_fault_operation_failed).

        CATCH zeit9_cx_get_logged_message_b1  INTO DATA(lx_fault_invalid_key).

        CATCH cx_ai_system_fault INTO DATA(lx_system_fault).
          IF lx_system_fault->code CS `SoapFaultCode:4`.
            "No operation found using
            "operation get_logged_message_bytes is not available in this PI system
            "following solution is workaround and PI version snould be updated
            ls_message_bytes_input-archive = abap_false.
            ls_message_bytes_input-message_key = lv_message_key.
            IF iv_version EQ 'BI'.
              ls_message_bytes_input-version = 0.
            ELSE.
              ls_message_bytes_input-version = -1.
            ENDIF.
            WAIT UP TO 4 SECONDS.
            mo_amm_proxy->get_message_bytes_java_lang_st(
              EXPORTING
                input                          = ls_message_bytes_input
              IMPORTING
                output                         = ls_message_bytes_output
            ).
          ENDIF.
      ENDTRY.
*      CATCH zeit9_cx_get_logged_message_by.    "
*      CATCH zeit9_cx_get_logged_message_b1.    "
      "ENDIF.
      IF ls_logged_message_output-response IS NOT INITIAL
       OR ls_message_bytes_output-response IS NOT INITIAL.
        EXIT.
      ELSE.
        WAIT UP TO 1 SECONDS.
      ENDIF.
    ENDDO.



    DATA lv_response TYPE xstring.
    IF ls_logged_message_output-response IS NOT INITIAL.
      lv_response = ls_logged_message_output-response.
    ELSE.
      lv_response = ls_message_bytes_output-response.
    ENDIF.

    IF lv_response IS INITIAL.
      MESSAGE e003(zeit1) WITH lv_message_key INTO DATA(lv_msg).
      lx_exc->append_sy_message( ).
      RAISE EXCEPTION lx_exc.
    ENDIF.

    DATA lo_conv TYPE REF TO cl_abap_conv_in_ce.

    lo_conv = cl_abap_conv_in_ce=>create(
               encoding                      = 'UTF-8' ).

    DATA lv_output_str TYPE string.
    lo_conv->convert(
        EXPORTING input = lv_response
        IMPORTING data = lv_output_str ).

*      CATCH cx_sy_conversion_codepage.    "
*      CATCH cx_sy_codepage_converter_init.    "
*      CATCH cx_parameter_invalid_type.    "
    DATA(lo_parser) = NEW zcl_eit1_amm_msg_parser(
                    iv_data = lv_output_str ).


    DATA(ls_msg_payload) = lo_parser->parse( ).

*      CATCH cx_ai_system_fault.    "
*      CATCH zeit9_cx_get_message_bytes_jav.    "
*      CATCH zeit9_cx_get_message_bytes_ja1.    "
    rs_msg_payload = ls_msg_payload.

  ENDMETHOD.
  METHOD zif_eit1_amm_service~get_payload_by_msg_id.
    rs_msg_payload = me->get_payload_by_id(
        iv_message_id      = iv_message_id
*        iv_reference_id    =
        iv_version         = iv_version ).
  ENDMETHOD.

  METHOD zif_eit1_amm_service~get_payload_by_ref_id.
    rs_msg_payload = me->get_payload_by_id(
*        iv_message_id      = iv_message_id
     iv_reference_id    = iv_reference_id
     iv_version         = iv_version ).
  ENDMETHOD.

ENDCLASS.
