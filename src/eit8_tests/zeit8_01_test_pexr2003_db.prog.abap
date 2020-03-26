*&---------------------------------------------------------------------*
*& Report  zeit8_01_test_pexr2003_db
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_01_test_pexr2003_db.

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
    lo_payload_repository = new #( ).

    DATA(lo_payload1) = lo_payload_repository->get_payload_by_guid(
                    iv_guid = 'D89D67C504821EE9B280D3E574A38609' ).

    DATA(lo_payload2) = lo_payload_repository->get_payload_by_guid(
                    iv_guid = 'D89D67C504821EE9B280DDD4533E460A' ).



  ENDMETHOD.

ENDCLASS.
