*&---------------------------------------------------------------------*
*& Report  zeit8_04_sxi_monitor_xml_disp
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_04_sxi_monitor_xml_disp.
DATA:
  gr_container TYPE REF TO cl_gui_custom_container,
  gr_request   TYPE REF TO cl_proxy_xml_edit,
  gv_payload   TYPE xstring.

START-OF-SELECTION.

  DATA: lo_payload_repository TYPE REF TO zcl_eit1_payload_repository.
  lo_payload_repository = NEW #( ).

  DATA(lo_payload) = lo_payload_repository->get_payload_by_guid(
                  iv_guid = 'D89D67C504821ED9B281A9234DE6030C' ).

  DATA(lv_xml1) = lo_payload->zif_eit1_content~get_content( ).

  DATA: lo_converter TYPE REF TO cl_abap_conv_out_ce.

  DATA(lo_conv) = cl_abap_conv_out_ce=>create(
    EXPORTING
      encoding                      = 'UTF-8'    " Output Character Format
*      endian                        =     " Output Byte Sequence
*      replacement                   = '#'    " Replacement Character for Character Set Conversion
*      ignore_cerr                   = ABAP_FALSE    " Flag: Ignore Errors When Converting Character Set
*    RECEIVING
*      conv                          =     " New Conversion Instance
  ).

  lo_conv->write(
    EXPORTING
*        n                             = -1    " Number of Units To Be Output
      data                          = lv_xml1    " Data Object To Be Output
*        view                          =     " ABAP Structure View with Offset and Length
*      IMPORTING
*        len                           =     " Number of Units Output
  ).
*      CATCH cx_sy_codepage_converter_init.    "
*      CATCH cx_sy_conversion_codepage.    "
*      CATCH cx_parameter_invalid_type.    "
*      CATCH cx_parameter_invalid_range.    "
  gv_payload = lo_conv->get_buffer( ).

  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*&      Module  PBO_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.

  IF gr_container IS INITIAL.
    CREATE OBJECT gr_container
      EXPORTING
        container_name              = 'CONTROL'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.

    CREATE OBJECT gr_request
      EXPORTING
        parent = gr_container.

    gr_request->set_xstring( in = gv_payload ).
    gr_request->toggle_change_mode( ).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'ENTER' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
