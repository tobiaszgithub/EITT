*"* use this source file for your ABAP unit test classes
CLASS ltcl_ignore_elements DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_eit1_xml_ignore_elements.
    DATA mt_expressions TYPE zcl_eit1_xml_ignore_elements=>tt_expression.
    DATA: mv_test_xml TYPE string.
    METHODS:
      correct_xml_correct_exp01 FOR TESTING RAISING cx_static_check,
      correct_xml_wrong_exp02 FOR TESTING RAISING cx_static_check,
      correct_xml_not_valid_exp03 FOR TESTING RAISING cx_static_check,
      not_valid_xml_correct_exp04 FOR TESTING RAISING cx_static_check.
    METHODS: get_test_xml1 RETURNING VALUE(rv_xml) TYPE string,
      get_not_valid_xml  RETURNING VALUE(rv_xml) TYPE string.
ENDCLASS.


CLASS ltcl_ignore_elements IMPLEMENTATION.

  METHOD correct_xml_correct_exp01.
    mt_expressions = VALUE #(
                        ( expression = '/ns1:BAPI_ACC_INVOICE_RECEIPT_POST/DOCUMENTHEADER/USERNAME'
                          ns_decls = 'ns1 urn:sap-com:document:sap:rfc:functions' ) ).

    mv_test_xml = get_test_xml1( ).

    mo_cut = NEW #( iv_xml = mv_test_xml
                    it_xpath_expressions = mt_expressions ).

    DATA(lv_final_xml) = mo_cut->set_empty_values( )->get_processed_xml( ).

    DATA(lo_xpath) = NEW cl_proxy_xpath( ).
    lo_xpath->set_source_string( source = lv_final_xml ).

    DATA(lv_result) = lo_xpath->get_element_value(
      EXPORTING
        expression = mt_expressions[ 1 ]-expression
        default    = '@'
       ns_decls   = mt_expressions[ 1 ]-ns_decls ).

    cl_abap_unit_assert=>assert_equals( msg = 'set empty not working'
                                        exp = ''
                                        act = lv_result ).

    mv_test_xml = NEW zcl_eit1_xml_pretty_printer(
                        iv_xml = mv_test_xml )->pprint( ).
    lv_final_xml = NEW zcl_eit1_xml_pretty_printer(
                        iv_xml = lv_final_xml )->pprint( ).

    cl_abap_unit_assert=>assert_differs( msg = 'msg' exp = lv_final_xml act = mv_test_xml ).

  ENDMETHOD.

  METHOD correct_xml_wrong_exp02.
    mt_expressions = VALUE #(
                          ( expression = '/ns1:BAPI_ACC_INVOICE_RECEIPT_POST/DOCUMENTHEADER/USERNAME/ZZZZ'
                            ns_decls = 'ns1 urn:sap-com:document:sap:rfc:functions' ) ).

    mv_test_xml = get_test_xml1( ).

    mo_cut = NEW #( iv_xml = mv_test_xml
                    it_xpath_expressions = mt_expressions ).

    DATA(lv_final_xml) = mo_cut->set_empty_values( )->get_processed_xml( ).

    DATA(lo_xpath) = NEW cl_proxy_xpath( ).
    lo_xpath->set_source_string( source = lv_final_xml ).

    mv_test_xml = NEW zcl_eit1_xml_pretty_printer( iv_xml = mv_test_xml )->pprint( ).
    lv_final_xml = NEW zcl_eit1_xml_pretty_printer( iv_xml = lv_final_xml )->pprint( ).

    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = lv_final_xml act = mv_test_xml ).

  ENDMETHOD.


  METHOD correct_xml_not_valid_exp03.
    mt_expressions = VALUE #(
          ( expression = '/ns1:BAPI_ACC_INVOICE_RECEIPT_POST/DOCUMENTHEADER/USERNAME/ZZZZ()'
            ns_decls = 'ns1 urn:sap-com:document:sap:rfc:functions' ) ).

    mv_test_xml = get_test_xml1( ).

    mo_cut = NEW #( iv_xml = mv_test_xml
                    it_xpath_expressions = mt_expressions ).

    TRY.
        DATA(lv_final_xml) = mo_cut->set_empty_values( )->get_processed_xml( ).
        cl_abap_unit_assert=>fail(
            msg    = 'Not valid xpath expression should cause an exception'

        ).
      CATCH zcx_eit1_exception INTO DATA(lx_exc).

    ENDTRY.

  ENDMETHOD.

  METHOD not_valid_xml_correct_exp04.
    mt_expressions = VALUE #(
            ( expression = '/ns1:BAPI_ACC_INVOICE_RECEIPT_POST/DOCUMENTHEADER/USERNAME'
              ns_decls = 'ns1 urn:sap-com:document:sap:rfc:functions' ) ).

    mv_test_xml = get_not_valid_xml( ).

    mo_cut = NEW #( iv_xml = mv_test_xml
                    it_xpath_expressions = mt_expressions ).

    TRY.
        DATA(lv_final_xml) = mo_cut->set_empty_values( )->get_processed_xml( ).
        cl_abap_unit_assert=>fail(
            msg    = 'Not valid xpath expression should cause an exception'

        ).
      CATCH zcx_eit1_exception INTO DATA(lx_exc).

    ENDTRY.
  ENDMETHOD.

  METHOD get_test_xml1.
    rv_xml =
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
  ENDMETHOD.

  METHOD get_not_valid_xml.
    rv_xml =
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
    && |<COMP_CODE>1001</COMP_CODE>|.
  ENDMETHOD.


ENDCLASS.
