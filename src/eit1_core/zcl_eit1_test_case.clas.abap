CLASS zcl_eit1_test_case DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: BEGIN OF c_status,
                 success TYPE zteit_test_cases-test_status VALUE '1',
                 failure TYPE zteit_test_cases-test_status VALUE '2',
                 warning TYPE zteit_test_cases-test_status VALUE '4',
               END OF c_status.
    CONSTANTS: BEGIN OF c_test_type,
                 pm TYPE zteit_test_cases-test_type VALUE 'PM',
                 es TYPE zteit_test_cases-test_type VALUE 'ES',
                 ed TYPE zteit_test_cases-test_type VALUE 'ED',
               END OF c_test_type.

    DATA: ms_test_case TYPE zteit_test_cases READ-ONLY.
    METHODS: constructor
      IMPORTING
                is_test_case   TYPE zteit_test_cases
                io_ico_srv     TYPE REF TO zif_eit1_ico_service OPTIONAL
                io_amm_srv     TYPE REF TO zif_eit1_amm_service OPTIONAL
                io_payload_rep TYPE REF TO zif_eit1_payload_repository OPTIONAL
      RAISING   zcx_eit1_exception,

      execute RAISING zcx_eit1_exception,
      set_status
        IMPORTING
          iv_status TYPE zteit_test_cases-test_status,
      download_payloads  RAISING zcx_eit1_exception.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mo_ico_srv TYPE REF TO zif_eit1_ico_service.
    DATA: mo_amm_srv TYPE REF TO  zif_eit1_amm_service.
    DATA: mo_payload_rep TYPE REF TO zif_eit1_payload_repository,
          mo_logger      TYPE REF TO zif_logger,
          mv_dummy       TYPE string.
    METHODS get_payload
      IMPORTING iv_guid           TYPE zde_eitt_msgguid
      RETURNING
                VALUE(ro_payload) TYPE REF TO zcl_eit1_payload.
    METHODS execute_pm RAISING zcx_eit1_exception.
    METHODS execute_es RAISING zcx_eit1_exception.
    METHODS generate_test_case_id
      RETURNING
                VALUE(rv_id) TYPE zteit_test_cases-test_case_id
      RAISING   zcx_eit1_exception .
    METHODS compare_payloads
      IMPORTING
                io_payload_exp TYPE REF TO zcl_eit1_payload
                io_payload_act TYPE REF TO zcl_eit1_payload
      RETURNING
                VALUE(rt_diff) TYPE zif_eit1_texts_diff=>tt_vxabapstring
      RAISING   zcx_eit1_exception .
ENDCLASS.



CLASS zcl_eit1_test_case IMPLEMENTATION.

  METHOD constructor.
    mo_logger = zcl_eit1_logger=>get( ).
    me->ms_test_case = is_test_case.
    IF io_ico_srv IS INITIAL.
      DATA(lo_system) = NEW zcl_eit1_conf_system( iv_system_name = ms_test_case-system_name ).
      DATA(lo_interface) = NEW zcl_eit1_conf_interface( iv_system_name = ms_test_case-system_name
                                                   iv_interface_name = ms_test_case-interface_name ).
      mo_ico_srv = NEW zcl_eit1_ico_service(
          iv_destination         = lo_system->ms_system-ico_rfc_dest
          iv_sender_service      = CONV #( lo_interface->ms_interface-sender_service )
          iv_interface_namespace = CONV #( lo_interface->ms_interface-interface_namespace )
          iv_interface           = CONV #( lo_interface->ms_interface-interface_ext )
          iv_quality_of_service = SWITCH #( ms_test_case-test_type
                                                WHEN c_test_type-es THEN zcl_eit1_ico_service=>c_qos-besteffort
                                                ELSE zcl_eit1_ico_service=>c_qos-exactly_once )
      ).
    ELSE.
      mo_ico_srv = io_ico_srv.
    ENDIF.

    IF io_amm_srv IS INITIAL.
      mo_amm_srv = NEW zcl_eit1_amm_service( iv_log_port_name = lo_system->ms_system-amm_logical_port ).
    ELSE.
      mo_amm_srv = io_amm_srv.
    ENDIF.

    IF io_payload_rep IS INITIAL.
      mo_payload_rep = NEW zcl_eit1_payload_repository( ).
    ELSE.
      mo_payload_rep = io_payload_rep.
    ENDIF.

    IF ms_test_case-test_case_id IS INITIAL.
      ms_test_case-test_case_id = generate_test_case_id( ).
    ENDIF.

  ENDMETHOD.
  METHOD execute.

    MESSAGE i006(zeit1) WITH ms_test_case-test_case_id INTO mv_dummy.
    DATA(ls_context) = CORRESPONDING zst_eit1_log_context( ms_test_case ).
    mo_logger->add( context = ls_context ).

    IF ms_test_case-payload_msgguid_bm IS INITIAL
        OR ms_test_case-payload_msgguid_am_exp IS INITIAL.
      download_payloads( ).
    ENDIF.

    CASE ms_test_case-test_type.
      WHEN c_test_type-pm.
        execute_pm( ).
      WHEN c_test_type-es.
        execute_es( ).
      WHEN OTHERS.
        execute_pm( ).
    ENDCASE.



  ENDMETHOD.


  METHOD get_payload.

    ro_payload = mo_payload_rep->get_payload_by_guid(
                                            iv_guid = iv_guid ).

  ENDMETHOD.


  METHOD set_status.
    ms_test_case-test_status = iv_status.
  ENDMETHOD.


  METHOD download_payloads.
    DATA(ls_msg_payload_bm) = mo_amm_srv->get_payload_by_msg_id(
                              iv_message_id  = CONV #( ms_test_case-pi_msgguid )
                              iv_version     = 'BI'
                          ).

    DATA(lv_payload_bm_guid) = CONV zde_eitt_msgguid( cl_system_uuid=>create_uuid_c32_static( ) ).
    DATA(lo_payload_bm) = NEW zcl_eit1_payload(
        iv_guid    = lv_payload_bm_guid
        is_content = ls_msg_payload_bm
    ).

    mo_payload_rep->insert_payload( io_payload = lo_payload_bm ).
    mo_payload_rep->save( ).

    ms_test_case-payload_msgguid_bm = lv_payload_bm_guid.

    IF ms_test_case-test_type EQ c_test_type-es.
      DATA(ls_msg_payload_am) = mo_amm_srv->get_payload_by_ref_id(
                                "iv_message_id  = CONV #( ms_test_case-pi_msgguid )
                                iv_reference_id = CONV #( ms_test_case-pi_msgguid )
                                iv_version     = 'AM'
                            ).
    ELSE.

      ls_msg_payload_am = mo_amm_srv->get_payload_by_msg_id(
                                iv_message_id  = CONV #( ms_test_case-pi_msgguid )
                                iv_version     = 'AM'
                            ).
    ENDIF.

    DATA(lv_payload_am_guid) = CONV zde_eitt_msgguid( cl_system_uuid=>create_uuid_c32_static( ) ).
    DATA(lo_payload_am) = NEW zcl_eit1_payload(
        iv_guid    = lv_payload_am_guid
        is_content = ls_msg_payload_am
    ).

    mo_payload_rep->insert_payload( io_payload = lo_payload_am ).
    mo_payload_rep->save( ).

    ms_test_case-payload_msgguid_am_exp = lv_payload_am_guid.
  ENDMETHOD.


  METHOD execute_pm.

    DATA(lo_payload_bm) = get_payload( iv_guid = ms_test_case-payload_msgguid_bm ).

    DATA(lo_log) = zcl_eit1_logger=>get( ).
    DATA(ls_context) = CORRESPONDING zst_eit1_log_context( ms_test_case ).
    lo_log->i(  obj_to_log = 'Sending payload to ICO...'
                context = ls_context ).
    DATA(ls_ico_response) = mo_ico_srv->send( iv_payload = lo_payload_bm->get_content( ) ).

    DATA(ls_msg_payload_am_act) = mo_amm_srv->get_payload_by_msg_id(
                            iv_version = 'AM'
                            iv_message_id = ls_ico_response-ref_to_message_id ).

    DATA(lo_payload_am_act) = NEW zcl_eit1_payload(
        iv_guid    = CONV #( ls_ico_response-ref_to_message_id )
        is_content = ls_msg_payload_am_act
    ).

    mo_payload_rep->insert_payload( io_payload = lo_payload_am_act ).
    mo_payload_rep->save( ).

    ms_test_case-payload_msgguid_am_act = ls_ico_response-ref_to_message_id.

    DATA(lo_payload_am_exp) = get_payload( iv_guid = ms_test_case-payload_msgguid_am_exp ).

    DATA lt_diff TYPE zif_eit1_texts_diff=>tt_vxabapstring.
    lt_diff = compare_payloads(
        io_payload_exp = lo_payload_am_exp
        io_payload_act = lo_payload_am_act ).



*    IF lt_diff IS INITIAL
*      AND lv_xml_ignored_elements EQ abap_true.
*      ms_test_case-test_status = '4'.
    IF lt_diff IS INITIAL.
      ms_test_case-test_status = '1'.
    ELSE.
      ms_test_case-test_status = '2'.
    ENDIF.

    ms_test_case-execution_date = sy-datum.
    ms_test_case-execution_time = sy-uzeit.
  ENDMETHOD.


  METHOD execute_es.
    DATA(lo_payload_bm) = get_payload( iv_guid = ms_test_case-payload_msgguid_bm ).
    DATA(lv_payload_bm) = lo_payload_bm->get_content( ).
    DATA(lo_replace_conf)    = NEW zcl_eit1_xml_replace_conf( iv_interface = ms_test_case-interface_name ).
    DATA(lt_replace_expressions) = lo_replace_conf->get_expressions( ).
    IF lt_replace_expressions IS NOT INITIAL.
      DATA(lo_replace_elements) = NEW zcl_eit1_xml_ignore_elements(
          iv_xml               = lv_payload_bm
          it_xpath_expressions = lt_replace_expressions
      ).

      lv_payload_bm = lo_replace_elements->set_next_number( )->get_processed_xml( ).
      FIND FIRST OCCURRENCE OF cl_abap_char_utilities=>newline IN lv_payload_bm RESULTS DATA(ls_result).
      ls_result-offset = ls_result-offset + 1.
      lv_payload_bm = lv_payload_bm+ls_result-offset.
    ENDIF.

    DATA(ls_ico_response) = mo_ico_srv->send( iv_payload = lv_payload_bm ).

    DATA(ls_msg_payload_am_act) = mo_amm_srv->get_payload_by_ref_id(
                            iv_version = 'AM'
                            "iv_message_id = ls_ico_response-ref_to_message_id
                            iv_reference_id = ls_ico_response-ref_to_message_id ).

    DATA(lo_payload_am_act) = NEW zcl_eit1_payload(
        iv_guid    = CONV #( ls_ico_response-ref_to_message_id )
        is_content = ls_msg_payload_am_act
    ).

    mo_payload_rep->insert_payload( io_payload = lo_payload_am_act ).
    mo_payload_rep->save( ).

    ms_test_case-payload_msgguid_am_act = ls_ico_response-ref_to_message_id.

    DATA(lo_payload_am_exp) = get_payload( iv_guid = ms_test_case-payload_msgguid_am_exp ).

    DATA(lt_diff) = compare_payloads(
                    io_payload_exp     = lo_payload_am_exp
                    io_payload_act     = lo_payload_am_act
                ).

*    IF lt_diff IS INITIAL AND lv_xml_ignored_elements EQ abap_true.
*      ms_test_case-test_status = '4'.
    IF lt_diff IS INITIAL.
      ms_test_case-test_status = '1'.
    ELSE.
      ms_test_case-test_status = '2'.
    ENDIF.
    ms_test_case-execution_date = sy-datum.
    ms_test_case-execution_time = sy-uzeit.
  ENDMETHOD.


  METHOD generate_test_case_id.
    DATA: lv_test_case_id TYPE zteit_test_cases-test_case_id.

    DATA lo_generator TYPE REF TO zif_eit1_number_generator.

    lo_generator = NEW zcl_eit1_test_case_id_gen( ).

    rv_id = lo_generator->get_next( ).

  ENDMETHOD.


  METHOD compare_payloads.

    DATA(lv_xml_exp) = io_payload_exp->get_content( ).
    DATA(lv_xml_act) = io_payload_act->get_content( ).

    lv_xml_exp = NEW zcl_eit1_xml_pretty_printer(
                                iv_xml = lv_xml_exp )->pprint( ).
    lv_xml_act = NEW zcl_eit1_xml_pretty_printer(
                                iv_xml = lv_xml_act )->pprint( ).

    DATA(lv_xml_ignored_elements) = abap_false.
    DATA(lo_ignore_conf) = NEW zcl_eit1_xml_ignore_conf( iv_interface = ms_test_case-interface_name ).
    DATA(lt_expressions) = lo_ignore_conf->get_expressions( ).

    IF lt_expressions IS NOT INITIAL.

      DATA(lo_ignore_elements) = NEW zcl_eit1_xml_ignore_elements(
          iv_xml               = lv_xml_exp
          it_xpath_expressions = lt_expressions
      ).
      lv_xml_exp = lo_ignore_elements->set_empty_values( )->get_processed_xml( ).

      lo_ignore_elements = NEW zcl_eit1_xml_ignore_elements(
          iv_xml               = lv_xml_act
          it_xpath_expressions = lt_expressions
      ).
      lv_xml_act = lo_ignore_elements->set_empty_values( )->get_processed_xml( ).
      lv_xml_ignored_elements = abap_true.
    ENDIF.


    DATA(lo_diff) = NEW zcl_eit1_texts_diff( ).
    DATA(lt_diff) = lo_diff->compare(
      EXPORTING
        iv_pri              = lv_xml_exp
        iv_sec              = lv_xml_act ).

    rt_diff = lt_diff.
  ENDMETHOD.

ENDCLASS.
