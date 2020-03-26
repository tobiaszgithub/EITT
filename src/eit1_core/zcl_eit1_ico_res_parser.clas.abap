CLASS zcl_eit1_ico_res_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_data TYPE string.
    METHODS parse
      RETURNING
        VALUE(rs_data) TYPE zst_eit1_ico_service_res
      RAISING
        zcx_eit1_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_data TYPE string.
    METHODS process_errors
      IMPORTING
        io_parser TYPE REF TO if_ixml_parser.
ENDCLASS.



CLASS zcl_eit1_ico_res_parser IMPLEMENTATION.


  METHOD constructor.

    me->mv_data = iv_data.

  ENDMETHOD.


  METHOD parse.
    DATA lo_ixml          TYPE REF TO if_ixml.
    DATA lo_document      TYPE REF TO if_ixml_document.
    DATA lo_streamfactory TYPE REF TO if_ixml_stream_factory.
    DATA lo_istream  TYPE REF TO if_ixml_istream.
    DATA lo_parser        TYPE REF TO if_ixml_parser.
    DATA: lx_exc  TYPE REF TO zcx_eit1_exception.

    lx_exc = NEW #( ).

    IF mv_data IS INITIAL.
      RETURN.
    ENDIF.

    lo_ixml = cl_ixml=>create( ).
    lo_document = lo_ixml->create_document( ).
    lo_streamfactory = lo_ixml->create_stream_factory( ).
    lo_istream = lo_streamfactory->create_istream_string( string = mv_data ).

    lo_parser = lo_ixml->create_parser(
                document       = lo_document
                istream        = lo_istream
                stream_factory = lo_streamfactory
            ).

    IF lo_parser->parse( ) <> 0.
      process_errors( lo_parser ).
    ENDIF.

    DATA lo_message_id TYPE REF TO if_ixml_element.
    lo_message_id = lo_document->find_from_path_ns(
                 default_uri = 'http://schemas.xmlsoap.org/soap/envelope/'
                 path        =
                   |/Envelope| &&
                   |/"http://schemas.xmlsoap.org/soap/envelope/:Header"| &&
                   |/"http://sap.com/xi/XI/Message/30:Main"| &&
                   |/"http://sap.com/xi/XI/Message/30:MessageId"|
             ).
    IF lo_message_id IS INITIAL.
      MESSAGE e002(zeit1) INTO DATA(lv_msg).
      lx_exc->append_sy_message( ).
      RAISE EXCEPTION lx_exc.
    ENDIF.
    DATA lo_ref_to TYPE REF TO if_ixml_element.
    lo_ref_to = lo_document->find_from_path_ns(
                 default_uri = 'http://schemas.xmlsoap.org/soap/envelope/'
                 path        =
                   |/Envelope| &&
                   |/"http://schemas.xmlsoap.org/soap/envelope/:Header"| &&
                   |/"http://sap.com/xi/XI/Message/30:Main"| &&
                   |/"http://sap.com/xi/XI/Message/30:RefToMessageId"|
             ).
    DATA lo_time_sent TYPE REF TO if_ixml_element.
    lo_time_sent = lo_document->find_from_path_ns(
                 default_uri = 'http://schemas.xmlsoap.org/soap/envelope/'
                 path        =
                   |/Envelope| &&
                   |/"http://schemas.xmlsoap.org/soap/envelope/:Header"| &&
                   |/"http://sap.com/xi/XI/Message/30:Main"| &&
                   |/"http://sap.com/xi/XI/Message/30:TimeSent"|
             ).

    rs_data-message_id = lo_message_id->get_value( ).
    rs_data-ref_to_message_id = lo_ref_to->get_value( ).
    rs_data-time_sent = lo_time_sent->get_value( ).
  ENDMETHOD.


  METHOD process_errors.

  ENDMETHOD.
ENDCLASS.
