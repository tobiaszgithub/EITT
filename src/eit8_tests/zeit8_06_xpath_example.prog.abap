*&---------------------------------------------------------------------*
*& Report  zeit8_06_xpath_example
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_06_xpath_example.

DATA(lo_payload_rep) = NEW zcl_eit1_payload_repository( ).


DATA(lo_payload_am_exp) = lo_payload_rep->get_payload_by_guid(
                            iv_guid = 'D89D67C504821ED9BA9BF0196DA20708' ).
DATA(lo_payload_am_act) = lo_payload_rep->get_payload_by_guid(
                            iv_guid = 'd89d67c5-0482-1ed9-bbcc-35ee83d2db0f' ).

DATA(lv_xml1) = lo_payload_am_exp->zif_eit1_content~get_content( ).
DATA(lv_xml2) = lo_payload_am_act->zif_eit1_content~get_content( ).

DATA: lo_ignore TYPE REF TO zcl_eit1_xml_ignore_elements.

DATA lt_expressions TYPE zcl_eit1_xml_ignore_elements=>tt_expression.
lt_expressions = VALUE #( ( expression = '/ns1:BAPI_ACC_INVOICE_RECEIPT_POST/DOCUMENTHEADER/PSTNG_DATE'
                            ns_decls = 'ns1 urn:sap-com:document:sap:rfc:functions' ) ).


lo_ignore = NEW #( iv_xml = lv_xml1
                   it_xpath_expressions = lt_expressions ).

DATA(lv_xml1_masked) = lo_ignore->set_empty_values( )->get_processed_xml( ).

lo_ignore = NEW #( iv_xml = lv_xml2
                   it_xpath_expressions = lt_expressions ).
DATA(lv_xml2_masked) = lo_ignore->set_empty_values( )->get_processed_xml( ).


lv_xml1 = NEW zcl_eit1_xml_pretty_printer(
                            iv_xml = lv_xml1 )->pprint( ).
lv_xml2 = NEW zcl_eit1_xml_pretty_printer(
                            iv_xml = lv_xml2 )->pprint( ).
CALL FUNCTION 'ZEIT2_XML_DIFF'
  EXPORTING
    iv_pri = lv_xml1_masked    " primary xml
    iv_sec = lv_xml2_masked.    " secondary xml

CALL FUNCTION 'ZEIT2_XML_DIFF'
  EXPORTING
    iv_pri = lv_xml1    " primary xml
    iv_sec = lv_xml2.    " secondary xml
WRITE: 'test...'.
