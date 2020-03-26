CLASS zcl_eit1_ico_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS: BEGIN OF c_qos,
                 exactly_once TYPE string VALUE 'ExactlyOnce',
                 besteffort   TYPE string VALUE 'BestEffort',
               END OF c_qos.
    INTERFACES: zif_eit1_ico_service.
    ALIASES send FOR zif_eit1_ico_service~send.
    METHODS constructor
      IMPORTING
        iv_destination         TYPE c
        io_http_client         TYPE REF TO if_http_client OPTIONAL
        iv_sender_service      TYPE string
        iv_interface_namespace TYPE string
        iv_interface           TYPE string
        iv_quality_of_service  TYPE string DEFAULT c_qos-exactly_once.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mo_http_client TYPE REF TO if_http_client.
    DATA mv_destination TYPE rfcdest.
    DATA mv_sender_service TYPE string.
    DATA mv_interface_namespace TYPE string.
    DATA mv_interface TYPE string.
    DATA mv_payload_cid TYPE string.
    DATA mv_quality_of_service TYPE string.
    DATA mo_uuid TYPE REF TO if_system_uuid.
    DATA mo_tstmp TYPE REF TO zif_eit1_tstmp.
    METHODS prepare_request_header IMPORTING io_request TYPE REF TO if_http_request.
    METHODS prepare_metadata_part IMPORTING io_request TYPE REF TO if_http_request
                                  RAISING   cx_uuid_error.
    METHODS prepare_message_part
      IMPORTING io_request TYPE REF TO if_http_request
                iv_payload TYPE string.
    METHODS get_timesent
      RETURNING
        VALUE(rv_timesent) TYPE string.
    METHODS create_message_id
      RETURNING
        VALUE(rv_message_id) TYPE string.
    METHODS create_payload_cid
      RETURNING
        VALUE(rv_payload_cid) TYPE string.
    METHODS prepare_request
      IMPORTING iv_payload TYPE string
                io_request TYPE REF TO if_http_request.


ENDCLASS.



CLASS zcl_eit1_ico_service IMPLEMENTATION.


  METHOD constructor.

    me->mv_destination = iv_destination.
    me->mo_http_client = io_http_client.
    me->mv_sender_service = iv_sender_service.
    me->mv_interface_namespace = iv_interface_namespace.
    me->mv_interface = iv_interface.
    me->mv_quality_of_service = iv_quality_of_service.
    IF mo_http_client IS INITIAL.
      cl_http_client=>create_by_destination(
        EXPORTING
          destination              =  mv_destination  " Logical destination (specified in function call)
        IMPORTING
          client                   =  mo_http_client   " HTTP Client Abstraction
        EXCEPTIONS
          argument_not_found       = 1
          destination_not_found    = 2
          destination_no_authority = 3
          plugin_not_active        = 4
          internal_error           = 5
          OTHERS                   = 6
      ).
      IF sy-subrc <> 0.
*         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ENDIF.

    mo_uuid = NEW cl_system_uuid( ).
    mo_tstmp = NEW zcl_eit1_tstmp( ).
  ENDMETHOD.


  METHOD create_message_id.
    DATA(lv_guid_c32) = mo_uuid->create_uuid_c32( ).
    rv_message_id = |{ lv_guid_c32+0(8) }-{ lv_guid_c32+8(4) }-{ lv_guid_c32+12(4) }-{ lv_guid_c32+16(4) }-{ lv_guid_c32+20(12) }|.

  ENDMETHOD.


  METHOD create_payload_cid.
    rv_payload_cid = |payload-{ mo_uuid->create_uuid_c32( ) }@eitt.com|.
  ENDMETHOD.


  METHOD get_timesent.

    DATA(ts) = mo_tstmp->get( ).
    CONVERT TIME STAMP ts TIME ZONE 'UTC' INTO DATE DATA(utc_date) TIME DATA(utc_time).
    rv_timesent = |{ utc_date+0(4) }-{ utc_date+4(2) }-{ utc_date+6(2) }T{ utc_time+0(2) }:{ utc_time+2(2) }:{ utc_time+4(2) }Z|.

  ENDMETHOD.


  METHOD prepare_message_part.
    DATA lo_part TYPE REF TO if_http_entity.
    lo_part = io_request->add_multipart(
*              suppress_content_length = ABAP_FALSE
              ).
    lo_part->set_content_type( content_type = 'application/xml' ).

    lo_part->set_header_field(
      EXPORTING
        name  =  'Content-ID'   " Name of the header field
        value =  |<{ mv_payload_cid }>|   " HTTP header field value
    ).
    lo_part->set_header_field(
      EXPORTING
        name  =  'Content-Disposition'   " Name of the header field
        value =  'attachment; filename="MainDocument.xml"'   " HTTP header field value
    ).

    lo_part->append_cdata(
      EXPORTING
        data   =  iv_payload   " Character data
*    offset = 0    " Offset into character data
*    length = -1    " Length of character data
    ).

  ENDMETHOD.


  METHOD prepare_metadata_part.
    DATA lo_part TYPE REF TO if_http_entity.

    lo_part = io_request->add_multipart( ).
    lo_part->set_content_type( content_type = 'text/xml; charset=UTF-8' ).

    DATA(lv_message_id) = create_message_id( ).

    DATA(lv_timesent) = get_timesent( ).

    mv_payload_cid = create_payload_cid( ).

*                  CATCH cx_uuid_error.  "
    "30afd515-99b6-11e3-c37d-000000aecb0e
    DATA(lv_soap) =
    |<SOAP:Envelope xmlns:SOAP="http://schemas.xmlsoap.org/soap/envelope/">| &&
    |<SOAP:Header>| &&
    |<sap:Main xmlns:sap='http://sap.com/xi/XI/Message/30' versionMajor='3' versionMinor='1' SOAP:mustUnderstand='1'>| &&
    |<sap:MessageClass>ApplicationMessage</sap:MessageClass>| &&
    |<sap:ProcessingMode>asynchronous</sap:ProcessingMode>| &&
    |<sap:MessageId>| && |{ lv_message_id }| && |</sap:MessageId>| &&
    |<sap:TimeSent>| && |{ lv_timesent }| && |</sap:TimeSent>| &&
    |<sap:Sender>| &&
    |<sap:Party agency='http://sap.com/xi/XI' scheme='XIParty'></sap:Party>| &&
    |<sap:Service>| && |{ mv_sender_service }| && |</sap:Service>| &&
    |</sap:Sender>| &&
    |<sap:Interface namespace='| && |{ mv_interface_namespace }| && |'>| && |{ mv_interface }| && |</sap:Interface>| &&
    |</sap:Main>| &&
    |<sap:ReliableMessaging xmlns:sap='http://sap.com/xi/XI/Message/30' SOAP:mustUnderstand='1'>| &&
    |<sap:QualityOfService>| && |{ mv_quality_of_service }| && |</sap:QualityOfService>| &&
    |</sap:ReliableMessaging>| &&
    |</SOAP:Header>| &&
    |<SOAP:Body>| &&
    |<sap:Manifest xmlns:sap="http://sap.com/xi/XI/Message/30" xmlns:xlink="http://www.w3.org/1999/xlink">| &&
    |<sap:Payload xlink:type="simple" xlink:href="cid:| && |{ mv_payload_cid }| && |">| &&
    |<sap:Name>PayloadName</sap:Name>| &&
    |<sap:Description>PayloadDescription</sap:Description>| &&
    |<sap:Type>Application</sap:Type>| &&
    |</sap:Payload>| &&
    |</sap:Manifest>| &&
    |</SOAP:Body>| &&
    |</SOAP:Envelope>|.

    lo_part->append_cdata(
        data   =  lv_soap ).

  ENDMETHOD.


  METHOD prepare_request.

    prepare_request_header( io_request = io_request ).

    prepare_metadata_part( io_request = io_request ).

    prepare_message_part( io_request = io_request
                          iv_payload = iv_payload ).
  ENDMETHOD.


  METHOD prepare_request_header.
    io_request->set_method( if_http_request=>co_request_method_post ).

    io_request->set_version( if_http_request=>co_protocol_version_1_1 ).

    io_request->set_content_type( content_type = 'multipart/related; type="text/xml"' ).

*    mo_http_client->request->set_header_field(
*        name  =  'SOAPAction'
*        value =  'http://sap.com/xi/WebService/soap1.1').
*
*    mo_http_client->request->set_header_field(
*        name  =  'MIME-Version'
*        value =  '1.0' ).
  ENDMETHOD.


  METHOD zif_eit1_ico_service~send.

    prepare_request( io_request = mo_http_client->request
                     iv_payload = iv_payload ).

    DATA(lv_request_to_xstring) = mo_http_client->request->to_xstring( ).

    CALL METHOD mo_http_client->send
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5.

    IF sy-subrc = 0.
      CALL METHOD mo_http_client->receive
        EXCEPTIONS
          http_communication_failure = 1
          http_invalid_state         = 2
          http_processing_failed     = 3
          OTHERS                     = 5.
    ENDIF.

    IF sy-subrc <> 0.
      "error handling
    ENDIF.

    DATA(lv_response) = mo_http_client->response->get_cdata( ).
    IF mv_quality_of_service EQ c_qos-exactly_once.
      DATA(lo_parser) = NEW zcl_eit1_ico_res_parser( iv_data = lv_response ).
      rs_response = lo_parser->parse( ).
    ENDIF.

    IF mv_quality_of_service EQ c_qos-besteffort.
      DATA(lo_parser_be) = NEW zcl_eit1_ico_res_be_parser( iv_data = lv_response ).
      rs_response = lo_parser_be->parse( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
