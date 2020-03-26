CLASS zcl_eit1_xml_pretty_printer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: mv_xml TYPE string.
    METHODS constructor
      IMPORTING
        iv_xml TYPE string.

    METHODS pprint
      RETURNING VALUE(rv_xml) TYPE string
      RAISING   zcx_eit1_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS ZCL_EIT1_XML_PRETTY_PRINTER IMPLEMENTATION.


  METHOD constructor.

    me->mv_xml = iv_xml.

  ENDMETHOD.


  METHOD pprint.
    DATA lo_ixml          TYPE REF TO if_ixml.
    DATA lo_document      TYPE REF TO if_ixml_document.
    DATA lo_streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA lo_istream  TYPE REF TO if_ixml_istream.
    DATA lo_parser        TYPE REF TO if_ixml_parser.

    IF mv_xml IS INITIAL.
      RETURN.
    ENDIF.

    lo_ixml = cl_ixml=>create( ).
    lo_document = lo_ixml->create_document( ).
    lo_streamfactory = lo_ixml->create_stream_factory( ).
    lo_istream = lo_streamfactory->create_istream_string( string = mv_xml ).

    lo_parser = lo_ixml->create_parser(
                document       = lo_document
                istream        = lo_istream
                stream_factory = lo_streamfactory
            ).

    IF lo_parser->parse( ) <> 0.
      DATA(lo_parsing_err) = NEW zcl_eit1_xml_proc_parsing_err( ).
      lo_parsing_err->process_errors( io_parser = lo_parser ).
*        CATCH zcx_eit1_xml_exception.    "
*      process_errors( lo_parser ).
    ENDIF.
    " Crate Output Stream
    DATA lo_ostream        TYPE REF TO if_ixml_ostream.
    DATA lo_renderer       TYPE REF TO if_ixml_renderer.
    DATA lv_output_str TYPE string.

    lo_ostream = lo_streamfactory->create_ostream_cstring( string = lv_output_str ).
*    DATA(lo_encoding) = lo_ixml->create_encoding(
*                        byte_order    = if_ixml_encoding=>co_none
*                        character_set = 'UTF-8'
*                    ).
*
*    lo_ostream->set_encoding( encoding = lo_encoding ).
    lo_ostream->set_pretty_print( abap_true ).

    lo_renderer = lo_ixml->create_renderer(
                  document = lo_document
                  ostream  = lo_ostream
              ).

    DATA(lv_rc) = lo_renderer->render( ).

    rv_xml = lv_output_str.
  ENDMETHOD.



ENDCLASS.
