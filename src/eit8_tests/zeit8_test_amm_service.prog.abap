*&---------------------------------------------------------------------*
*& Report  ZEIT8_TEST_AMM_SERVICE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_test_amm_service.

CLASS lcl_report DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS: run.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS import_from_cluster.

ENDCLASS.

START-OF-SELECTION.

  DATA(lo_report) = NEW lcl_report( ).

  lo_report->run( ).

CLASS lcl_report IMPLEMENTATION.

  METHOD run.

    DATA lo_amm_service TYPE REF TO zif_eit1_amm_service.

    lo_amm_service = NEW zcl_eit1_amm_service( iv_log_port_name = 'PI_PXD' ).

    DATA(ls_msg_payload) = lo_amm_service->get_payload_by_msg_id(
      EXPORTING
        iv_message_id   = 'f64b5f3f-a4a7-11e9-c597-000010a8128a'
        iv_version      = 'BI'
*        iv_pretty_print = ABAP_FALSE
    ).

    DATA ls_message_clu TYPE zteit_msg_cluste.
    DATA lt_res           TYPE sxmsrest.
    DATA ls_res TYPE LINE OF sxmsrest.

    DATA:       BEGIN OF clustkey,
                  msgguid TYPE sxmsqid,
                  pid     TYPE sxmspid,
                  vers    TYPE sxmslsqnbr,
                END OF clustkey.

    clustkey-msgguid = 'F64B5F3FA4A711E9C597000010A8128A'.
    clustkey-pid = 'SENDER'.
    clustkey-vers = '000'.

    ls_res-linecount = '000001'.
    ls_res-resname = ls_msg_payload-content_id.
    ls_res-rescontent = ls_msg_payload-content.
    ls_res-resattrib = ls_msg_payload-content_type.

    lt_res = VALUE #( ( ls_res ) ).

    EXPORT lt_res FROM lt_res
        TO DATABASE zteit_msg_cluste(is) FROM ls_message_clu ID clustkey.


    import_from_cluster( ).

  ENDMETHOD.


  METHOD import_from_cluster.
    DATA:       BEGIN OF clustkey,
                  msgguid TYPE sxmsqid,
                  pid     TYPE sxmspid,
                  vers    TYPE sxmslsqnbr,
                END OF clustkey.
    DATA ls_message_clu TYPE zteit_msg_cluste.
    DATA lt_res2           TYPE sxmsrest.

    clustkey-msgguid = 'F64B5F3FA4A711E9C597000010A8128A'.
    clustkey-pid = 'SENDER'.
    clustkey-vers = '000'.

    IMPORT lt_res TO lt_res2
        FROM DATABASE zteit_msg_cluste(is) TO ls_message_clu ID clustkey.

  ENDMETHOD.

ENDCLASS.
