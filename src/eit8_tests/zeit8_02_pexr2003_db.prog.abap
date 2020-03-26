*&---------------------------------------------------------------------*
*& Report  zeit8_test_pexr2003
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_02_pexr2003_db.

CLASS lcl_report DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS: run.
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS get_pexr2003
      RETURNING
        VALUE(rv_idoc) TYPE string.

ENDCLASS.

START-OF-SELECTION.

  DATA(lo_report) = NEW lcl_report( ).

  lo_report->run( ).


CLASS lcl_report IMPLEMENTATION.

  METHOD run.
    DATA: lo_payload_rep TYPE REF TO zcl_eit1_payload_repository.
    lo_payload_rep = NEW #( ).
    DATA(lv_pexr2003) = get_pexr2003( ).

    DATA lo_ico_srv_pxd TYPE REF TO zcl_eit1_ico_service.

    lo_ico_srv_pxd = NEW zcl_eit1_ico_service(
        iv_destination = 'PI_PXD_TEST_ICO'
*    io_http_client =
        iv_sender_service = 'BS_EXD_200'
        iv_interface_namespace = 'urn:sap-com:document:sap:idoc:messages'
        iv_interface = 'REMADV.PEXR2003'
    ).

    DATA(lv_ico_response_pxd) = lo_ico_srv_pxd->send( iv_payload = lv_pexr2003 ).
    WRITE: 'PXD response guid: ', lv_ico_response_pxd-ref_to_message_id.

    DATA lo_amm_service_pxd TYPE REF TO zif_eit1_amm_service.

    lo_amm_service_pxd = NEW zcl_eit1_amm_service( iv_log_port_name = 'PI_PXD' ).

    DATA(msg_payload_am_pxd) = lo_amm_service_pxd->get_payload_by_msg_id(
                            iv_version = 'AM'
                            iv_message_id = lv_ico_response_pxd-ref_to_message_id ).
    DATA: lo_payload TYPE REF TO zcl_eit1_payload.

    DATA: lv_guid TYPE string.
    lv_guid = lv_ico_response_pxd-ref_to_message_id.
    lv_guid = to_upper( lv_guid ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_guid WITH ''.
    lo_payload = NEW #( iv_guid = CONV #( lv_guid )
                        is_content = msg_payload_am_pxd ).

    lo_payload_rep->insert_payload( io_payload = lo_payload ).

    lo_payload_rep->save( ).

    DATA(lv_content) = NEW zcl_eit1_xml_pretty_printer(
                                    iv_xml = msg_payload_am_pxd-content )->pprint( ).
*                                                                          CATCH zcx_eit1_exception.  "
    msg_payload_am_pxd-content = lv_content.

    DATA lo_ico_srv_pa2 TYPE REF TO zcl_eit1_ico_service.

    lo_ico_srv_pa2 = NEW zcl_eit1_ico_service(
        iv_destination = 'PI_PA2_TEST_ICO'
*    io_http_client =
        iv_sender_service = 'SAP_R3_TX6_210'
        iv_interface_namespace = 'urn:sap-com:document:sap:idoc:messages'
        iv_interface = 'REMADV.PEXR2003'
    ).
    DATA(lv_ico_response_pa2) = lo_ico_srv_pa2->send( iv_payload = lv_pexr2003 ).
    WRITE: 'PA2 response guid: ', lv_ico_response_pa2-ref_to_message_id.

    DATA lo_amm_service_pa2 TYPE REF TO zif_eit1_amm_service.

    lo_amm_service_pa2 = NEW zcl_eit1_amm_service( iv_log_port_name = 'PI_PA2' ).

    DATA(msg_payload_am_pa2) = lo_amm_service_pa2->get_payload_by_msg_id(
                            iv_version = '-1'
                            iv_message_id = lv_ico_response_pa2-ref_to_message_id ).

    lv_guid = lv_ico_response_pa2-ref_to_message_id.
    lv_guid = to_upper( lv_guid ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_guid WITH ''.
    lo_payload = NEW #( iv_guid = CONV #( lv_guid )
                        is_content = msg_payload_am_pa2 ).

    lo_payload_rep->insert_payload( io_payload = lo_payload ).

    lo_payload_rep->save( ).

    msg_payload_am_pa2-content = NEW zcl_eit1_xml_pretty_printer(
                                iv_xml = msg_payload_am_pa2-content )->pprint( ).

    DATA lt_payload_diff TYPE zif_eit1_texts_diff=>tt_vxabapstring.
    DATA(lo_text_diff) = NEW zcl_eit1_texts_diff( ).

    lt_payload_diff = lo_text_diff->compare(
      EXPORTING
        iv_pri              = msg_payload_am_pxd-content
        iv_sec              = msg_payload_am_pa2-content
    ).

    CALL FUNCTION 'ZEIT2_XML_DIFF'
      EXPORTING
        iv_pri = msg_payload_am_pxd-content  " primary xml
        iv_sec = msg_payload_am_pa2-content.  " secondary xml

  ENDMETHOD.
  METHOD get_pexr2003.
    DATA lo_amm_service_pxd TYPE REF TO zif_eit1_amm_service.

    lo_amm_service_pxd = NEW zcl_eit1_amm_service( iv_log_port_name = 'PI_PXD' ).

    DATA lv_message_id TYPE string.
    lv_message_id = '53c66d59-c80c-11e9-c9d6-000010a8128a'.

    DATA(msg_payload_am_pxd) = lo_amm_service_pxd->get_payload_by_msg_id(
                            iv_version = '0'
                            iv_message_id = lv_message_id ).
    rv_idoc = msg_payload_am_pxd-content.

    DATA: lo_payload_rep TYPE REF TO zcl_eit1_payload_repository.
    DATA: lo_payload TYPE REF TO zcl_eit1_payload.
    lo_payload_rep = NEW #( ).

    DATA lv_guid  TYPE string.
    lv_guid = lv_message_id.
    lv_guid = to_upper( lv_guid ).
    REPLACE ALL OCCURRENCES OF '-' IN lv_guid WITH ''.
    lo_payload = NEW #( iv_guid = CONV #( lv_guid )
                        is_content = msg_payload_am_pxd ).

    lo_payload_rep->insert_payload( io_payload = lo_payload ).

    lo_payload_rep->save( ).
  ENDMETHOD.






ENDCLASS.
