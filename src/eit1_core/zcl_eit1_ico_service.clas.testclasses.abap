*"* use this source file for your ABAP unit test classes
CLASS ltcl_ico_service DEFINITION DEFERRED.
CLASS zcl_eit1_ico_service DEFINITION LOCAL FRIENDS ltcl_ico_service.

CLASS lcl_http_entity_mock DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_entity.
    DATA mv_content_type  TYPE string.
    DATA mv_cdata TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.

CLASS lcl_http_entity_mock IMPLEMENTATION.
  METHOD if_http_entity~set_content_type.
    mv_content_type = content_type.
  ENDMETHOD.

  METHOD if_http_entity~append_cdata.
    mv_cdata = data.
  ENDMETHOD.

  METHOD if_http_entity~set_header_field.

  ENDMETHOD.
ENDCLASS.

CLASS lcl_request_mock DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_request.
    DATA: mv_method TYPE string.
    DATA mv_version TYPE i.
    DATA mv_content_type  TYPE string.
    DATA mt_entity TYPE STANDARD TABLE OF REF TO if_http_entity.
  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.

CLASS lcl_request_mock IMPLEMENTATION.
  METHOD if_http_request~set_method.
    mv_method = method.
  ENDMETHOD.

  METHOD if_http_request~set_version.
    mv_version = version.
  ENDMETHOD.

  METHOD if_http_request~set_content_type.
    mv_content_type = content_type.
  ENDMETHOD.

  METHOD if_http_request~add_multipart.

    entity = NEW lcl_http_entity_mock( ).
    INSERT entity INTO TABLE mt_entity.
  ENDMETHOD.

  METHOD if_http_request~to_xstring.

  ENDMETHOD.
ENDCLASS.

CLASS lcl_response_mock DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_http_response.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_response_mock IMPLEMENTATION.
  METHOD if_http_response~get_cdata.

  ENDMETHOD.
ENDCLASS.

CLASS lcl_http_client_mock DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_client.
    ALIASES request FOR if_http_client~request .
    ALIASES response FOR if_http_client~response.
    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_http_client_mock IMPLEMENTATION.

  METHOD constructor.

    me->request = NEW lcl_request_mock( ).
    me->response = NEW lcl_response_mock( ).
  ENDMETHOD.

  METHOD if_http_client~send.

  ENDMETHOD.

  METHOD if_http_client~receive.

  ENDMETHOD.
ENDCLASS.

CLASS lcl_tstmp_mock DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_eit1_tstmp.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_tstmp_mock IMPLEMENTATION.

  METHOD zif_eit1_tstmp~get.
    rv_tstmp = 20200116160000.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_uidd_mock DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_system_uuid.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_uidd_mock IMPLEMENTATION.
  METHOD if_system_uuid~create_uuid_c32.
    uuid = '12345678901234567890123456789012'.
  ENDMETHOD.
ENDCLASS.

CLASS ltcl_ico_service DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      send_01 FOR TESTING RAISING cx_static_check,
      get_sample_metadata
        RETURNING
          VALUE(rv_metadata) TYPE string.
ENDCLASS.


CLASS ltcl_ico_service IMPLEMENTATION.

  METHOD send_01.
    DATA(lo_http_client) = NEW lcl_http_client_mock( ).
    DATA lo_request_mock TYPE REF TO lcl_request_mock.


    DATA(mo_cut) = NEW zcl_eit1_ico_service(
        iv_destination         = 'Test dest'
        io_http_client         = lo_http_client
        iv_sender_service      = 'BS_D_EXTSYS'
        iv_interface_namespace = 'urn:example.com:EXTSYS:Invoice'
        iv_interface           = 'InvoiceProcessingExtsysInvoiceHeader_Out'
*        iv_quality_of_service  = C_QOS-EXACTLY_ONCE
    ).
    DATA(lo_tstmp_mock) = NEW lcl_tstmp_mock( ).
    mo_cut->mo_tstmp = lo_tstmp_mock.
    DATA(lo_uuid_mock) = NEW lcl_uidd_mock( ).
    mo_cut->mo_uuid = lo_uuid_mock.

    lo_request_mock ?= lo_http_client->request.

    DATA lv_payload TYPE string.
    DATA ls_response_exp TYPE zst_eit1_ico_service_res .
    DATA(ls_response) = mo_cut->send( iv_payload = lv_payload ).
*      CATCH zcx_eit1_exception.    "
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = ls_response act = ls_response ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = if_http_request=>co_request_method_post act = lo_request_mock->mv_method ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = if_http_request=>co_protocol_version_1_1 act = lo_request_mock->mv_version ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'multipart/related; type="text/xml"' act = lo_request_mock->mv_content_type ).

    DATA lo_entity_mock TYPE REF TO lcl_http_entity_mock.
    lo_entity_mock ?= lo_request_mock->mt_entity[ 1 ].
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'text/xml; charset=UTF-8' act = lo_entity_mock->mv_content_type ).
    DATA(lv_metadata) = get_sample_metadata( ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = lv_metadata act = lo_entity_mock->mv_cdata ).
    lo_entity_mock ?= lo_request_mock->mt_entity[ 2 ].
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'application/xml' act = lo_entity_mock->mv_content_type ).



  ENDMETHOD.


  METHOD get_sample_metadata.
    rv_metadata =
|<SOAP:Envelope xmlns:SOAP="http://schemas.xmlsoap.org/soap/envelope/">| &&
    |<SOAP:Header>| &&
        |<sap:Main xmlns:sap='http://sap.com/xi/XI/Message/30' versionMajor='3' versionMinor='1' SOAP:mustUnderstand='1'>| &&
            |<sap:MessageClass>ApplicationMessage</sap:MessageClass>| &&
            |<sap:ProcessingMode>asynchronous</sap:ProcessingMode>| &&
            |<sap:MessageId>12345678-9012-3456-7890-123456789012</sap:MessageId>| &&
            |<sap:TimeSent>2020-01-16T16:00:00Z</sap:TimeSent>| &&
            |<sap:Sender>| &&
                |<sap:Party agency='http://sap.com/xi/XI' scheme='XIParty'></sap:Party>| &&
                |<sap:Service>BS_D_EXTSYS</sap:Service>| &&
            |</sap:Sender>| &&
            |<sap:Interface namespace='urn:example.com:EXTSYS:Invoice'>InvoiceProcessingExtsysInvoiceHeader_Out</sap:Interface>| &&
        |</sap:Main>| &&
        |<sap:ReliableMessaging xmlns:sap='http://sap.com/xi/XI/Message/30' SOAP:mustUnderstand='1'>| &&
            |<sap:QualityOfService>ExactlyOnce</sap:QualityOfService>| &&
        |</sap:ReliableMessaging>| &&
    |</SOAP:Header>| &&
    |<SOAP:Body>| &&
        |<sap:Manifest xmlns:sap="http://sap.com/xi/XI/Message/30" | &&
            |xmlns:xlink="http://www.w3.org/1999/xlink">| &&
            |<sap:Payload xlink:type="simple" xlink:href="cid:payload-12345678901234567890123456789012@eitt.com">| &&
                |<sap:Name>PayloadName</sap:Name>| &&
                |<sap:Description>PayloadDescription</sap:Description>| &&
                |<sap:Type>Application</sap:Type>| &&
            |</sap:Payload>| &&
        |</sap:Manifest>| &&
    |</SOAP:Body>| &&
|</SOAP:Envelope>|.
  ENDMETHOD.

ENDCLASS.
