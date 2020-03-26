*"* use this source file for your ABAP unit test classes
CLASS ltcl_pretty_printer DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      pprint_test01 FOR TESTING RAISING cx_static_check.
    METHODS:
      pprint_test02 FOR TESTING RAISING cx_static_check.
    METHODS:
      pprint_test03 FOR TESTING RAISING cx_static_check.
    METHODS:
      pprint_not_valid_xml FOR TESTING RAISING cx_static_check.

    METHODS: get_example_formatted_xml
      RETURNING VALUE(rv_xml) TYPE string.
    METHODS: get_example_unformatted_xml
      RETURNING VALUE(rv_xml) TYPE string,
      get_not_valid_xml
        RETURNING
          VALUE(rv_xml) TYPE string.
ENDCLASS.


CLASS ltcl_pretty_printer IMPLEMENTATION.

  METHOD pprint_test01.
    DATA lo_pprinter TYPE REF TO zcl_eit1_xml_pretty_printer.
    DATA(lv_xml) = get_example_formatted_xml( ).
    lo_pprinter = NEW #( iv_xml = lv_xml ).

    DATA(lv_xml_after_pprint) = lo_pprinter->pprint( ).

    cl_abap_unit_assert=>assert_equals( msg = 'Test case for already formatted xml'
                                        exp = lv_xml
                                        act = lv_xml_after_pprint ).


  ENDMETHOD.

  METHOD pprint_test02.
    DATA lo_pprinter TYPE REF TO zcl_eit1_xml_pretty_printer.
    DATA(lv_xml) = get_example_unformatted_xml( ).
    DATA(lv_xml_formatted_exp) = get_example_formatted_xml( ).
    lo_pprinter = NEW #( iv_xml = lv_xml ).

    DATA(lv_xml_after_pprint) = lo_pprinter->pprint( ).

    cl_abap_unit_assert=>assert_equals( msg = 'Test case for unformatted xml'
                                        exp = lv_xml_formatted_exp
                                        act = lv_xml_after_pprint ).


  ENDMETHOD.

  METHOD pprint_test03.
    DATA lo_pprinter TYPE REF TO zcl_eit1_xml_pretty_printer.
    DATA lv_xml TYPE    string VALUE ''.
    DATA lv_xml_formatted_exp TYPE string VALUE ''.

    lo_pprinter = NEW #( iv_xml = lv_xml ).
    DATA(lv_xml_after_pprint) = lo_pprinter->pprint( ).
    cl_abap_unit_assert=>assert_equals( msg = 'Should be initial'
                                    exp = lv_xml_formatted_exp
                                    act = lv_xml_after_pprint ).

  ENDMETHOD.

  METHOD pprint_not_valid_xml.
    DATA lo_pprinter TYPE REF TO zcl_eit1_xml_pretty_printer.
    DATA(lv_not_valid_xml) = get_not_valid_xml( ).

    lo_pprinter = NEW #( iv_xml = lv_not_valid_xml ).


    TRY.
        DATA(lv_xml_after_pprint) = lo_pprinter->pprint( ).

        cl_abap_unit_assert=>fail(
            msg    = 'Not valid xml should cause an exception'

        ).
      CATCH zcx_eit1_exception   INTO DATA(lx_exc).

    ENDTRY.

  ENDMETHOD.

  METHOD get_example_formatted_xml.
    rv_xml =
|﻿<?xml version="1.0" encoding="utf-16"?>\n| &&
|<INTERNAL_ORDER01>\n| &&
| <IDOC BEGIN="1">\n| &&
|  <EDI_DC40 SEGMENT="1">\n| &&
|   <TABNAM>EDI_DC40</TABNAM>\n| &&
|   <MANDT>200</MANDT>\n| &&
|   <DOCNUM>0000000000341838</DOCNUM>\n| &&
|   <DOCREL>740</DOCREL>\n| &&
|   <STATUS>30</STATUS>\n| &&
|   <DIRECT>1</DIRECT>\n| &&
|   <OUTMOD>2</OUTMOD>\n| &&
|   <IDOCTYP>INTERNAL_ORDER01</IDOCTYP>\n| &&
|   <MESTYP>INTERNAL_ORDER</MESTYP>\n| &&
|   <STDMES>INTERN</STDMES>\n| &&
|   <SNDPOR>SAPEXD</SNDPOR>\n| &&
|   <SNDPRT>LS</SNDPRT>\n| &&
|   <SNDPRN>EXDCLNT200</SNDPRN>\n| &&
|   <RCVPOR>A000000023</RCVPOR>\n| &&
|   <RCVPRT>LS</RCVPRT>\n| &&
|   <RCVPRN>EXTSYS</RCVPRN>\n| &&
|   <CREDAT>20190711</CREDAT>\n| &&
|   <CRETIM>211922</CRETIM>\n| &&
|   <SERIAL>20190528111424</SERIAL>\n| &&
|  </EDI_DC40>\n| &&
|  <E1BP2075_MASTERDATA_ALE SEGMENT="1">\n| &&
|   <REFERENCE_ORDER>000100110000</REFERENCE_ORDER>\n| &&
|   <CO_AREA>RETL</CO_AREA>\n| &&
|   <COMP_CODE>1001</COMP_CODE>\n| &&
|   <RESPCCTR>1001021093</RESPCCTR>\n| &&
|   <S_ORD_ITEM>000000</S_ORD_ITEM>\n| &&
|   <STATISTICAL>X</STATISTICAL>\n| &&
|   <CCTR_POSTED>1001021093</CCTR_POSTED>\n| &&
|   <CURRENCY>GBP</CURRENCY>\n| &&
|   <ISO_CODE>GBP</ISO_CODE>\n| &&
|   <ESTIMATED_COSTS>0.0000</ESTIMATED_COSTS>\n| &&
|   <APPLICATION_DATE>00000000</APPLICATION_DATE>\n| &&
|   <PLN_RELEASE>00000000</PLN_RELEASE>\n| &&
|   <PLN_COMPLETION>00000000</PLN_COMPLETION>\n| &&
|   <PLN_CLOSE>00000000</PLN_CLOSE>\n| &&
|   <DATE_RELEASE>20190228</DATE_RELEASE>\n| &&
|   <DATE_COMPLETION>00000000</DATE_COMPLETION>\n| &&
|  </E1BP2075_MASTERDATA_ALE>\n| &&
| </IDOC>\n| &&
|</INTERNAL_ORDER01>\n|.

  ENDMETHOD.

  METHOD get_example_unformatted_xml.
    rv_xml =
  |<?xml version="1.0" encoding="UTF-8"?><INTERNAL_ORDER01><IDOC BEGIN="1"><EDI_DC40 SEGMENT="1"><TABNAM>EDI_DC40</TABNAM><MANDT>200</MANDT><DOCNUM>0000000000341838</DOCNUM><DOCREL>740</DOCREL><STATUS>30</STATUS><DIRECT>1</DIRECT><OUTMOD>2</OUTMOD><ID| &&
  |OCTYP>INTERNAL_ORDER01</IDOCTYP><MESTYP>INTERNAL_ORDER</MESTYP><STDMES>INTERN</STDMES><SNDPOR>SAPEXD</SNDPOR><SNDPRT>LS</SNDPRT><SNDPRN>EXDCLNT200</SNDPRN><RCVPOR>A000000023</RCVPOR><RCVPRT>LS</RCVPRT><RCVPRN>EXTSYS</RCVPRN><CREDAT>20190711</CRE| &&
  |DAT><CRETIM>211922</CRETIM><SERIAL>20190528111424</SERIAL></EDI_DC40><E1BP2075_MASTERDATA_ALE SEGMENT="1">| &&
  |<REFERENCE_ORDER>000100110000</REFERENCE_ORDER><CO_AREA>RETL</CO_ARE| &&
  |A><COMP_CODE>1001</COMP_CODE><RESPCCTR>1001021093</RESPCCTR><S_ORD_ITEM>000000</S_ORD_ITEM><STATISTICAL>X</STATISTICAL><CCTR_POSTED>1001021093</CCTR_POSTED><CURRENCY>GBP</CURRENCY><ISO_CODE>GBP</ISO_CODE><ESTIMATED_COSTS>0.0000</ESTIMATED_COSTS><AP| &&
  |PLICATION_DATE>00000000</APPLICATION_DATE>| &&
  |<PLN_RELEASE>00000000</PLN_RELEASE><PLN_COMPLETION>00000000</PLN_COMPLETION><PLN_CLOSE>00000000</PLN_CLOSE><DATE_RELEASE>20190228</DATE_RELEASE><DATE_COMPLETION>00000000</DATE_COMPLETION>| &&
  |</E1BP2075_MASTERDATA_ALE></IDOC></INTERNAL_ORDER01>\n|.

  ENDMETHOD.




  METHOD get_not_valid_xml.
    rv_xml =  |<?xml version="1.0" encoding="UTF-8"?><INTERNAL_ORDER01><IDOC BEGIN="1"></IDOC>|.
  ENDMETHOD.

ENDCLASS.
