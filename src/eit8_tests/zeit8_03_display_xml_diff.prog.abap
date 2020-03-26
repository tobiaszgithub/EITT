*&---------------------------------------------------------------------*
*& Report  zeit8_03_display_xml_diff
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_03_display_xml_diff.
CLASS lcl_report DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS: run.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



START-OF-SELECTION.

  DATA(lo_report) = NEW lcl_report( ).

  lo_report->run( ).


CLASS lcl_report IMPLEMENTATION.

  METHOD run.
    DATA: lo_payload_repository TYPE REF TO zcl_eit1_payload_repository.
    lo_payload_repository = NEW #( ).

    DATA(lo_payload1) = lo_payload_repository->get_payload_by_guid(
                    iv_guid = 'D89D67C504821ED9B281A9234DE6030C' ).

    DATA(lo_payload2) = lo_payload_repository->get_payload_by_guid(
                    iv_guid = 'D89D67C504821ED9B281AC11B297830B' ).
    DATA(lv_xml1) = lo_payload1->zif_eit1_content~get_content( ).
    DATA(lv_xml2) = lo_payload2->zif_eit1_content~get_content( ).

    lv_xml1 = NEW zcl_eit1_xml_pretty_printer(
                                iv_xml = lv_xml1 )->pprint( ).
    lv_xml2 = NEW zcl_eit1_xml_pretty_printer(
                                iv_xml = lv_xml2 )->pprint( ).

    CALL FUNCTION 'ZEIT2_XML_DIFF'
      EXPORTING
        iv_pri = lv_xml1    " primary xml
        iv_sec = lv_xml2.     " secondary xml

  ENDMETHOD.


ENDCLASS.
