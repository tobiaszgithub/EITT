CLASS zcl_eit1_xml_ignore_elements DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF t_expression,
             expression TYPE string,
             ns_decls   TYPE string,
           END OF t_expression.
    TYPES: tt_expression TYPE STANDARD TABLE OF t_expression WITH EMPTY KEY.
    METHODS constructor
      IMPORTING
        iv_xml               TYPE string
        it_xpath_expressions TYPE tt_expression.
    METHODS set_empty_values RETURNING VALUE(ro_instance) TYPE REF TO zcl_eit1_xml_ignore_elements
                             RAISING
                                       zcx_eit1_exception.
    METHODS set_values
      IMPORTING iv_value           TYPE string
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_eit1_xml_ignore_elements
      RAISING
                zcx_eit1_exception.
    METHODS get_processed_xml
      RETURNING
        VALUE(rv_xml) TYPE string.
    METHODS set_next_number
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_eit1_xml_ignore_elements
      RAISING
                zcx_eit1_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_xml_orginal TYPE string.
    DATA mv_xml_final TYPE string.
    DATA mt_expressions TYPE STANDARD TABLE OF zcl_eit1_xml_ignore_elements=>t_expression.
ENDCLASS.



CLASS zcl_eit1_xml_ignore_elements IMPLEMENTATION.


  METHOD constructor.

    me->mv_xml_orginal = iv_xml.
    me->mt_expressions = it_xpath_expressions.
  ENDMETHOD.


  METHOD get_processed_xml.
    rv_xml = mv_xml_final.
  ENDMETHOD.


  METHOD set_empty_values.
    ro_instance = set_values( iv_value = '' ).
  ENDMETHOD.

  METHOD set_next_number.
    DATA: lv_next_number TYPE zteit_test_cases-test_case_id.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '02'    " Number range number
        object                  = 'ZEITT'    " Name of number range object
*       quantity                = '1'    " Number of numbers
*       subobject               = SPACE    " Value of subobject
*       toyear                  = '0000'    " Value of To-fiscal year
*       ignore_buffer           = SPACE    " Ignore object buffering
      IMPORTING
        number                  = lv_next_number    " free number
*       quantity                =     " Number of numbers
*       returncode              =     " Return code
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    ro_instance = set_values( iv_value = CONV #( lv_next_number ) ).
  ENDMETHOD.

  METHOD set_values.
    DATA lo_ixml          TYPE REF TO if_ixml.
    DATA lo_document      TYPE REF TO if_ixml_document.
    DATA lo_streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA lo_istream  TYPE REF TO if_ixml_istream.
    DATA lo_parser        TYPE REF TO if_ixml_parser.
    DATA: lx_exc TYPE REF TO zcx_eit1_exception.
    lx_exc = NEW #( ).

    lo_ixml = cl_ixml=>create( ).
    lo_document = lo_ixml->create_document( ).
    lo_streamfactory = lo_ixml->create_stream_factory( ).
    lo_istream = lo_streamfactory->create_istream_string( string = mv_xml_orginal ).

    lo_parser = lo_ixml->create_parser(
                document       = lo_document
                istream        = lo_istream
                stream_factory = lo_streamfactory
            ).

    IF lo_parser->parse( ) <> 0.

      DATA(lo_parsing_err) = NEW zcl_eit1_xml_proc_parsing_err( ).
      lo_parsing_err->process_errors( io_parser = lo_parser ).
    ENDIF.
    DATA: lo_xslt TYPE REF TO cl_xslt_processor.

    lo_xslt = NEW #( ).

    TRY.
        lo_xslt->set_source_node(
          EXPORTING
            node              = lo_document    " iXML node
        ).
      CATCH cx_xslt_exception.    "
    ENDTRY.

    LOOP AT mt_expressions INTO DATA(ls_expression).
      TRY.
          lo_xslt->set_expression(
            EXPORTING
              expression        = ls_expression-expression    " XPath expression
              nsdeclarations    = ls_expression-ns_decls ).

          lo_xslt->run(
            EXPORTING
              progname          =  '' ).
        CATCH cx_xslt_exception INTO DATA(lx_xslt_exc).    "
          lx_exc = NEW zcx_eit1_exception(
*                textid   =
              previous = lx_xslt_exc
*                ms_msg   =
*                mt_msg   =
          ).
          RAISE EXCEPTION lx_exc.
      ENDTRY.

      DATA(lo_nodes) = lo_xslt->get_nodes( ).

      DATA(lv_len) = lo_nodes->get_length( ).

      IF lv_len > 0.
        DATA(lo_item) = lo_nodes->get_item( index = 0 ).

        lo_item->set_value( value = iv_value ).
      ENDIF.

    ENDLOOP.

    " Crate Output Stream
    DATA lo_ostream        TYPE REF TO if_ixml_ostream.
    DATA lo_renderer       TYPE REF TO if_ixml_renderer.
    DATA lo_oencoding TYPE REF TO if_ixml_encoding.
    DATA lv_output_str TYPE string.

    lo_ostream = lo_streamfactory->create_ostream_cstring( string = lv_output_str ).
*    lo_oencoding = lo_ixml->create_encoding(
*                   byte_order    = if_ixml_encoding=>co_none
*                   character_set = 'UTF-8'
*               ).
*    lo_ostream->set_encoding( encoding = lo_oencoding ).

    lo_ostream->set_pretty_print( abap_true ).

    lo_renderer = lo_ixml->create_renderer(
                  document = lo_document
                  ostream  = lo_ostream
              ).

    DATA(lv_rc) = lo_renderer->render( ).
    mv_xml_final = lv_output_str.
    ro_instance = me.
  ENDMETHOD.

ENDCLASS.
