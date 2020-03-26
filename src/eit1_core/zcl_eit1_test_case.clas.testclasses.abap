*"* use this source file for your ABAP unit test classes
CLASS lcl_logger_mock DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_logger.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_logger_mock IMPLEMENTATION.

  METHOD zif_logger~add.

  ENDMETHOD.

  METHOD zif_logger~i.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_eit1_ico_srv_mock DEFINITION CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_eit1_ico_service.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_eit1_ico_srv_mock IMPLEMENTATION.
  METHOD zif_eit1_ico_service~send.
    DATA: ls_response TYPE zst_eit1_ico_service_res .
    ls_response-ref_to_message_id = 'AM_ACT1'.
    rs_response = ls_response.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_payload_rep_mock DEFINITION
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_eit1_payload_repository.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS lcl_payload_rep_mock IMPLEMENTATION.
  METHOD zif_eit1_payload_repository~get_payload_by_guid.
    DATA: ls_content TYPE zst_eit1_content .


    IF iv_guid = 'BM1'.
      ls_content-content =
         |<?xml version="1.0" encoding="UTF-8"?>|
      && |<ns1:BAPI_ACC_INVOICE_RECEIPT_POST xmlns:ns1="urn:sap-com:document:sap:rfc:functions">|
      && |<DOCUMENTHEADER>|
      && |<USERNAME>BC_BATCH</USERNAME>|
      && |<HEADER_TXT>EXTSYS</HEADER_TXT>|
      && |<COMP_CODE>1001</COMP_CODE>|
      && |<DOC_DATE>2018-10-12</DOC_DATE>|
      && |<PSTNG_DATE>2019-10-07</PSTNG_DATE>|
      && |<PAYMENT_ORDER_REFERENCE/>|
      && |</DOCUMENTHEADER>|
      && |<ACCOUNTGL>|
      && |<item>|
      && |<ITEMNO_ACC>2</ITEMNO_ACC>|
      && |<GL_ACCOUNT>0000833220</GL_ACCOUNT>|
      && |<COMP_CODE>1001</COMP_CODE>|
      && |<REF_KEY_1/>|
      && |<TAX_CODE>V0</TAX_CODE>|
      && |<ALLOC_NMBR/>|
      && |<ITEM_TEXT>paper</ITEM_TEXT>|
      && |<COSTCENTER>1001021941</COSTCENTER>|
      && |</item>|
      && |</ACCOUNTGL>|
      && |</ns1:BAPI_ACC_INVOICE_RECEIPT_POST>|.
      ro_payload = NEW #(
          iv_guid = iv_guid
          is_content = ls_content ).
    ENDIF.

    IF iv_guid = 'AM1'.
      ls_content-content =
         |<?xml version="1.0" encoding="UTF-8"?>|
      && |<ns1:BAPI_ACC_INVOICE_RECEIPT_POST xmlns:ns1="urn:sap-com:document:sap:rfc:functions">|
      && |<DOCUMENTHEADER>|
      && |<USERNAME>BC_BATCH</USERNAME>|
      && |<HEADER_TXT>EXTSYS</HEADER_TXT>|
      && |<COMP_CODE>1001</COMP_CODE>|
      && |<DOC_DATE>2018-10-12</DOC_DATE>|
      && |<PSTNG_DATE>2019-10-07</PSTNG_DATE>|
      && |<PAYMENT_ORDER_REFERENCE/>|
      && |</DOCUMENTHEADER>|
      && |<ACCOUNTGL>|
      && |<item>|
      && |<ITEMNO_ACC>2</ITEMNO_ACC>|
      && |<GL_ACCOUNT>0000833220</GL_ACCOUNT>|
      && |<COMP_CODE>1001</COMP_CODE>|
      && |<REF_KEY_1/>|
      && |<TAX_CODE>V0</TAX_CODE>|
      && |<ALLOC_NMBR/>|
      && |<ITEM_TEXT>paper</ITEM_TEXT>|
      && |<COSTCENTER>1001021941</COSTCENTER>|
      && |</item>|
      && |</ACCOUNTGL>|
      && |</ns1:BAPI_ACC_INVOICE_RECEIPT_POST>|.
      ro_payload = NEW #(
          iv_guid = iv_guid
          is_content = ls_content ).
    ENDIF.

    IF iv_guid EQ '2'.
      ls_content-content =
         |<?xml version="1.0" encoding="UTF-8"?>|
      && |<ns1:BAPI_ACC_INVOICE_RECEIPT_POST xmlns:ns1="urn:sap-com:document:sap:rfc:functions">|
      && |<DOCUMENTHEADER>|
      && |<USERNAME>BC_BATCH</USERNAME>|
      && |<HEADER_TXT>EXTSYS</HEADER_TXT>|
      && |<COMP_CODE>1002</COMP_CODE>|
      && |<DOC_DATE>2018-10-14</DOC_DATE>|
      && |<PSTNG_DATE>2019-10-07</PSTNG_DATE>|
      && |<PAYMENT_ORDER_REFERENCE/>|
      && |</DOCUMENTHEADER>|
      && |<ACCOUNTGL>|
      && |<item>|
      && |<ITEMNO_ACC>2</ITEMNO_ACC>|
      && |<GL_ACCOUNT>0000833220</GL_ACCOUNT>|
      && |<COMP_CODE>1001</COMP_CODE>|
      && |<REF_KEY_1/>|
      && |<TAX_CODE>V0</TAX_CODE>|
      && |<ALLOC_NMBR/>|
      && |<ITEM_TEXT>paper</ITEM_TEXT>|
      && |<COSTCENTER>1001021941</COSTCENTER>|
      && |</item>|
      && |</ACCOUNTGL>|
      && |</ns1:BAPI_ACC_INVOICE_RECEIPT_POST>|.
      ro_payload = NEW #(
          iv_guid = iv_guid
          is_content = ls_content ).
    ENDIF.
  ENDMETHOD.

  METHOD zif_eit1_payload_repository~insert_payload.

  ENDMETHOD.

  METHOD zif_eit1_payload_repository~delete_payload.

  ENDMETHOD.

  METHOD zif_eit1_payload_repository~update_payload.

  ENDMETHOD.

  METHOD zif_eit1_payload_repository~save.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_amm_srv_mock DEFINITION
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_eit1_amm_service.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS lcl_amm_srv_mock IMPLEMENTATION.
*  METHOD zif_eit1_amm_service~get_payload_by_id.
*    IF iv_message_id EQ 'AM_ACT1'.
*      rs_msg_payload-content =
*     |<?xml version="1.0" encoding="UTF-8"?>|
*  && |<ns1:BAPI_ACC_INVOICE_RECEIPT_POST xmlns:ns1="urn:sap-com:document:sap:rfc:functions">|
*  && |<DOCUMENTHEADER>|
*  && |<USERNAME>BC_BATCH</USERNAME>|
*  && |<HEADER_TXT>EXTSYS</HEADER_TXT>|
*  && |<COMP_CODE>1001</COMP_CODE>|
*  && |<DOC_DATE>2018-10-12</DOC_DATE>|
*  && |<PSTNG_DATE>2019-10-07</PSTNG_DATE>|
*  && |<PAYMENT_ORDER_REFERENCE/>|
*  && |</DOCUMENTHEADER>|
*  && |<ACCOUNTGL>|
*  && |<item>|
*  && |<ITEMNO_ACC>2</ITEMNO_ACC>|
*  && |<GL_ACCOUNT>0000833220</GL_ACCOUNT>|
*  && |<COMP_CODE>1001</COMP_CODE>|
*  && |<REF_KEY_1/>|
*  && |<TAX_CODE>V0</TAX_CODE>|
*  && |<ALLOC_NMBR/>|
*  && |<ITEM_TEXT>paper</ITEM_TEXT>|
*  && |<COSTCENTER>1001021941</COSTCENTER>|
*  && |</item>|
*  && |</ACCOUNTGL>|
*  && |</ns1:BAPI_ACC_INVOICE_RECEIPT_POST>|.
*    ENDIF.
*
*    IF iv_reference_id EQ 'AM_ACT1'.
*      rs_msg_payload-content =
*     |<?xml version="1.0" encoding="UTF-8"?>|
*  && |<ns1:BAPI_ACC_INVOICE_RECEIPT_POST xmlns:ns1="urn:sap-com:document:sap:rfc:functions">|
*  && |<DOCUMENTHEADER>|
*  && |<USERNAME>BC_BATCH</USERNAME>|
*  && |<HEADER_TXT>EXTSYS</HEADER_TXT>|
*  && |<COMP_CODE>1001</COMP_CODE>|
*  && |<DOC_DATE>2018-10-12</DOC_DATE>|
*  && |<PSTNG_DATE>2019-10-07</PSTNG_DATE>|
*  && |<PAYMENT_ORDER_REFERENCE/>|
*  && |</DOCUMENTHEADER>|
*  && |<ACCOUNTGL>|
*  && |<item>|
*  && |<ITEMNO_ACC>2</ITEMNO_ACC>|
*  && |<GL_ACCOUNT>0000833220</GL_ACCOUNT>|
*  && |<COMP_CODE>1001</COMP_CODE>|
*  && |<REF_KEY_1/>|
*  && |<TAX_CODE>V0</TAX_CODE>|
*  && |<ALLOC_NMBR/>|
*  && |<ITEM_TEXT>paper</ITEM_TEXT>|
*  && |<COSTCENTER>1001021941</COSTCENTER>|
*  && |</item>|
*  && |</ACCOUNTGL>|
*  && |</ns1:BAPI_ACC_INVOICE_RECEIPT_POST>|.
*    ENDIF.
*  ENDMETHOD.

  METHOD zif_eit1_amm_service~get_payload_by_msg_id.
    IF iv_message_id EQ 'AM_ACT1'.
      rs_msg_payload-content =
     |<?xml version="1.0" encoding="UTF-8"?>|
  && |<ns1:BAPI_ACC_INVOICE_RECEIPT_POST xmlns:ns1="urn:sap-com:document:sap:rfc:functions">|
  && |<DOCUMENTHEADER>|
  && |<USERNAME>BC_BATCH</USERNAME>|
  && |<HEADER_TXT>EXTSYS</HEADER_TXT>|
  && |<COMP_CODE>1001</COMP_CODE>|
  && |<DOC_DATE>2018-10-12</DOC_DATE>|
  && |<PSTNG_DATE>2019-10-07</PSTNG_DATE>|
  && |<PAYMENT_ORDER_REFERENCE/>|
  && |</DOCUMENTHEADER>|
  && |<ACCOUNTGL>|
  && |<item>|
  && |<ITEMNO_ACC>2</ITEMNO_ACC>|
  && |<GL_ACCOUNT>0000833220</GL_ACCOUNT>|
  && |<COMP_CODE>1001</COMP_CODE>|
  && |<REF_KEY_1/>|
  && |<TAX_CODE>V0</TAX_CODE>|
  && |<ALLOC_NMBR/>|
  && |<ITEM_TEXT>paper</ITEM_TEXT>|
  && |<COSTCENTER>1001021941</COSTCENTER>|
  && |</item>|
  && |</ACCOUNTGL>|
  && |</ns1:BAPI_ACC_INVOICE_RECEIPT_POST>|.
    ENDIF.


  ENDMETHOD.

  METHOD zif_eit1_amm_service~get_payload_by_ref_id.

    IF iv_reference_id EQ 'AM_ACT1'.
      rs_msg_payload-content =
     |<?xml version="1.0" encoding="UTF-8"?>|
  && |<ns1:BAPI_ACC_INVOICE_RECEIPT_POST xmlns:ns1="urn:sap-com:document:sap:rfc:functions">|
  && |<DOCUMENTHEADER>|
  && |<USERNAME>BC_BATCH</USERNAME>|
  && |<HEADER_TXT>EXTSYS</HEADER_TXT>|
  && |<COMP_CODE>1001</COMP_CODE>|
  && |<DOC_DATE>2018-10-12</DOC_DATE>|
  && |<PSTNG_DATE>2019-10-07</PSTNG_DATE>|
  && |<PAYMENT_ORDER_REFERENCE/>|
  && |</DOCUMENTHEADER>|
  && |<ACCOUNTGL>|
  && |<item>|
  && |<ITEMNO_ACC>2</ITEMNO_ACC>|
  && |<GL_ACCOUNT>0000833220</GL_ACCOUNT>|
  && |<COMP_CODE>1001</COMP_CODE>|
  && |<REF_KEY_1/>|
  && |<TAX_CODE>V0</TAX_CODE>|
  && |<ALLOC_NMBR/>|
  && |<ITEM_TEXT>paper</ITEM_TEXT>|
  && |<COSTCENTER>1001021941</COSTCENTER>|
  && |</item>|
  && |</ACCOUNTGL>|
  && |</ns1:BAPI_ACC_INVOICE_RECEIPT_POST>|.
    ENDIF.
  ENDMETHOD.

  METHOD zif_eit1_amm_service~get_message_list.

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_test_case DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      setup,
      execute_success_01 FOR TESTING RAISING cx_static_check,
      execute_failure_02 FOR TESTING RAISING cx_static_check,
      execute_success_ignore_03 FOR TESTING RAISING cx_static_check,
      execute_es_success_01 FOR TESTING RAISING cx_static_check,
      download_payload_04 FOR TESTING RAISING cx_static_check,
      set_status_05 FOR TESTING RAISING cx_static_check.


    DATA: mo_cut TYPE REF TO zcl_eit1_test_case.
    DATA: ms_test_case        TYPE zteit_test_cases,
          mo_ico_srv_mock     TYPE REF TO zif_eit1_ico_service,
          mo_amm_srv_mock     TYPE REF TO zif_eit1_amm_service,
          mo_payload_rep_mock TYPE REF TO zif_eit1_payload_repository.
ENDCLASS.


CLASS ltcl_test_case IMPLEMENTATION.
  METHOD setup.
    mo_ico_srv_mock = NEW lcl_eit1_ico_srv_mock( ).
    mo_amm_srv_mock = NEW lcl_amm_srv_mock( ).
    mo_payload_rep_mock = NEW lcl_payload_rep_mock( ).
    DATA(lo_logger) = NEW lcl_logger_mock( ).
    zcl_eit1_logger=>mo_logger = lo_logger.
    CLEAR ms_test_case.
  ENDMETHOD.

  METHOD execute_success_01.
    ms_test_case-test_case_id = '1'.
    ms_test_case-test_type = zcl_eit1_test_case=>c_test_type-pm.
    ms_test_case-payload_msgguid_bm = 'BM1'.
    ms_test_case-payload_msgguid_am_exp = 'AM1'.

    mo_cut = NEW zcl_eit1_test_case(
        is_test_case = ms_test_case
        io_ico_srv   = mo_ico_srv_mock
        io_amm_srv   = mo_amm_srv_mock
        io_payload_rep = mo_payload_rep_mock
    ).

    mo_cut->execute( ).

    cl_abap_unit_assert=>assert_equals( msg = 'After execute test status should be success' exp = '1' act = mo_cut->ms_test_case-test_status ).

  ENDMETHOD.

  METHOD execute_failure_02.

    ms_test_case-test_case_id = '1'.
    ms_test_case-payload_msgguid_bm = 'BM1'.
    ms_test_case-payload_msgguid_am_exp = '2'.

    mo_cut = NEW zcl_eit1_test_case(
        is_test_case = ms_test_case
        io_ico_srv   = mo_ico_srv_mock
        io_amm_srv   = mo_amm_srv_mock
        io_payload_rep = mo_payload_rep_mock
    ).

    mo_cut->execute( ).

    cl_abap_unit_assert=>assert_equals( msg = 'Execute with failure' exp = '2' act = mo_cut->ms_test_case-test_status ).

  ENDMETHOD.
  METHOD execute_success_ignore_03.

    ms_test_case-test_case_id = '1'.
    ms_test_case-interface_name = 'InvoiceProcessingExtsysInvoiceHeader_Out'.
    ms_test_case-payload_msgguid_bm = 'BM1'.
    ms_test_case-payload_msgguid_am_exp = 'AM1'.

    mo_cut = NEW zcl_eit1_test_case(
        is_test_case = ms_test_case
        io_ico_srv   = mo_ico_srv_mock
        io_amm_srv   = mo_amm_srv_mock
        io_payload_rep = mo_payload_rep_mock
    ).

    mo_cut->execute( ).

    cl_abap_unit_assert=>assert_equals( msg = 'Execute test with ignore elements' exp = '1' act = mo_cut->ms_test_case-test_status ).
  ENDMETHOD.

  METHOD execute_es_success_01.

    ms_test_case-test_case_id = '1'.
    ms_test_case-test_type = zcl_eit1_test_case=>c_test_type-es.
    ms_test_case-payload_msgguid_bm = 'BM1'.
    ms_test_case-payload_msgguid_am_exp = 'AM1'.

    mo_cut = NEW zcl_eit1_test_case(
        is_test_case = ms_test_case
        io_ico_srv   = mo_ico_srv_mock
        io_amm_srv   = mo_amm_srv_mock
        io_payload_rep = mo_payload_rep_mock
    ).

    mo_cut->execute( ).

    cl_abap_unit_assert=>assert_equals( msg = 'After execute test status should be success' exp = '1' act = mo_cut->ms_test_case-test_status ).


  ENDMETHOD.

  METHOD download_payload_04.

    mo_cut = NEW zcl_eit1_test_case(
        is_test_case = ms_test_case
        io_ico_srv   = mo_ico_srv_mock
        io_amm_srv   = mo_amm_srv_mock
        io_payload_rep = mo_payload_rep_mock
    ).

    mo_cut->download_payloads( ).

    cl_abap_unit_assert=>assert_differs( msg = 'msg' exp = '' act = mo_cut->ms_test_case-payload_msgguid_bm ).

    cl_abap_unit_assert=>assert_differs( msg = 'msg' exp = '' act = mo_cut->ms_test_case-payload_msgguid_am_exp ).
  ENDMETHOD.
  METHOD set_status_05.

    mo_cut = NEW zcl_eit1_test_case(
        is_test_case = ms_test_case
        io_ico_srv   = mo_ico_srv_mock
        io_amm_srv   = mo_amm_srv_mock
        io_payload_rep = mo_payload_rep_mock
    ).

    mo_cut->set_status( iv_status = zcl_eit1_test_case=>c_status-success ).

    cl_abap_unit_assert=>assert_equals( msg = 'Set success status'
                                        exp = zcl_eit1_test_case=>c_status-success
                                        act = mo_cut->ms_test_case-test_status ).

  ENDMETHOD.

ENDCLASS.
