CLASS zcl_eit2_payload_disp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_payload      TYPE string
                                  iv_payload_guid TYPE zde_eitt_msgguid.
    METHODS show_dialog.
    METHODS toggle_change_mode.
    METHODS pretty_print.
    METHODS save.
    METHODS free.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_payload          TYPE string,
          gr_request          TYPE REF TO cl_proxy_xml_edit,
          mo_custom_container TYPE REF TO cl_gui_custom_container,
          mv_payload_guid     TYPE zde_eitt_msgguid.
ENDCLASS.



CLASS zcl_eit2_payload_disp IMPLEMENTATION.
  METHOD show_dialog.
    DATA: gv_sample_request_payload TYPE xstring.

    DATA lo_conv TYPE REF TO cl_abap_conv_out_ce.

    lo_conv = cl_abap_conv_out_ce=>create(
              encoding                      = 'UTF-8'
*              endian                        =
*              replacement                   = '#'
*              ignore_cerr                   = ABAP_FALSE
          ).
*            CATCH cx_parameter_invalid_range.  "
*            CATCH cx_sy_codepage_converter_init.  "

    lo_conv->convert(
      EXPORTING
        data                          = mv_payload    " Field to Be Converted
*        n                             = -1    " Number of Units to Be Converted
      IMPORTING
        buffer                        =  gv_sample_request_payload   " Converted Data
*        len                           =     " Number of Converted Units
    ).
*      CATCH cx_sy_codepage_converter_init.    "
*      CATCH cx_sy_conversion_codepage.    "
*      CATCH cx_parameter_invalid_type.    "

    mo_custom_container = NEW
     cl_gui_custom_container( container_name = 'CUSTOM_CONTAINER' ).


    CREATE OBJECT gr_request
      EXPORTING
        parent = mo_custom_container.

    gr_request->set_xstring( gv_sample_request_payload ).

    gr_request->set_visible( visible = abap_true ).
  ENDMETHOD.

  METHOD constructor.
    mv_payload = iv_payload.
    mv_payload_guid = iv_payload_guid.
  ENDMETHOD.

  METHOD free.
    gr_request->clear( ).
    mo_custom_container->free(
*      EXCEPTIONS
*        cntl_error        = 1
*        cntl_system_error = 2
*        others            = 3
    ).
    IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    clear gr_request.
    clear mo_custom_container.
  ENDMETHOD.

  METHOD toggle_change_mode.
    gr_request->toggle_change_mode( ).
    "gr_request->set_visible( abap_true ).
  ENDMETHOD.

  METHOD pretty_print.
    gr_request->pretty_print( ).
  ENDMETHOD.

  METHOD save.
    DATA:
  lv_data TYPE xstring.
    DATA lv_output_str TYPE string.

    lv_data = gr_request->get_xstring( ).

    DATA lo_conv TYPE REF TO cl_abap_conv_in_ce.

    lo_conv = cl_abap_conv_in_ce=>create(
              encoding                      = 'UTF-8'
*              endian                        =
*              replacement                   = '#'
*              ignore_cerr                   = ABAP_FALSE
*              input                         =
          ).
*            CATCH cx_parameter_invalid_range.  "
*            CATCH cx_sy_codepage_converter_init.  "
    lo_conv->convert(
      EXPORTING
        input                         = lv_data    " Byte Sequence to Be Converted
*    n                             = -1    " Number of Units To Be Read
      IMPORTING
        data                          = lv_output_str    " Field to Be Filled
*    len                           =     " Number of Converted Units
*    input_too_short               =     " Input Buffer Was too Short
    ).
*  CATCH cx_sy_conversion_codepage.    "
*  CATCH cx_sy_codepage_converter_init.    "
*  CATCH cx_parameter_invalid_type.    "

    DATA(lo_payload_rep) = NEW zcl_eit1_payload_repository( ).
    DATA(lo_payload) = lo_payload_rep->get_payload_by_guid( iv_guid = mv_payload_guid ).
    DATA(ls_content) = lo_payload->ms_content.
    ls_content-content = lv_output_str.
    DATA(lo_payload_new) = NEW zcl_eit1_payload(
        iv_guid    = lo_payload->mv_guid
        is_content = ls_content
    ).


    lo_payload_rep->update_payload( io_payload = lo_payload_new ).
    lo_payload_rep->save( ).
  ENDMETHOD.

ENDCLASS.
