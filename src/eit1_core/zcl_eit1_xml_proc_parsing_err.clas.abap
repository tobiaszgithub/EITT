CLASS zcl_eit1_xml_proc_parsing_err DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS process_errors
      IMPORTING
        io_parser TYPE REF TO if_ixml_parser
      RAISING
        zcx_eit1_xml_exception.

    METHODS prepare_texts
      IMPORTING
        iv_string TYPE string
      EXPORTING
        ev_txt1   TYPE string
        ev_txt2   TYPE string
        ev_txt3   TYPE string
        ev_txt4   TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_eit1_xml_proc_parsing_err IMPLEMENTATION.
  METHOD process_errors.
    DATA: lx_exc  TYPE REF TO zcx_eit1_xml_exception,
          lv_txt1 TYPE string,
          lv_txt2 TYPE string,
          lv_txt3 TYPE string,
          lv_txt4 TYPE string.

    lx_exc = NEW #( ).

    DO io_parser->num_errors( ) TIMES.
      DATA(lo_error) = io_parser->get_error(
          index = sy-index - 1 ).
      DATA(lv_txt) = lo_error->get_reason( ).

      prepare_texts( EXPORTING iv_string = lv_txt
                     IMPORTING ev_txt1 = lv_txt1
                               ev_txt2 = lv_txt2
                               ev_txt3 = lv_txt3
                               ev_txt4 = lv_txt4 ).


      MESSAGE e001(zeit1) WITH lv_txt1 lv_txt2 lv_txt3 lv_txt4 INTO DATA(lv_msg).
      lx_exc->append_sy_message( ).
    ENDDO.

    IF lines( lx_exc->get_messages( ) ) > 0.
      RAISE EXCEPTION lx_exc.
    ENDIF.
  ENDMETHOD.

  METHOD prepare_texts.
    DATA(lv_len) = strlen( iv_string ).

    IF lv_len <= 50.
      DATA(lv_txt1) = substring( val = iv_string off = 0 len = lv_len ).
    ELSE.
      lv_txt1 = substring( val = iv_string off = 0 len = 50 ).
      lv_len = lv_len - 50.
      IF lv_len <= 50.
        DATA(lv_txt2) = substring( val = iv_string off = 50 len = lv_len ).
      ELSE.
        lv_txt2 = substring( val = iv_string off = 50 len = 50 ).
        lv_len = lv_len - 50.
        IF lv_len <= 50.
          DATA(lv_txt3) = substring( val = iv_string off = 100 len = lv_len ).
        ELSE.
          lv_txt3 = substring( val = iv_string off = 100 len = 50 ).
          lv_len = lv_len - 50.
          IF lv_len <= 50.
            DATA(lv_txt4) = substring( val = iv_string off = 150 len = lv_len ).
          ELSE.
            lv_txt4 = substring( val = iv_string off = 150 len = 50 ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    ev_txt1 = lv_txt1.
    ev_txt2 = lv_txt2.
    ev_txt3 = lv_txt3.
    ev_txt4 = lv_txt4.
  ENDMETHOD.

ENDCLASS.
