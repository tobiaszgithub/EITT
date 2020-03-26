*"* use this source file for your ABAP unit test classes
CLASS ltcl_parser_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      msg_correct01 FOR TESTING RAISING cx_static_check,
      msg_correct02 FOR TESTING RAISING cx_static_check,
      test_http_request FOR TESTING RAISING cx_static_check,
      get_correct_msg
        RETURNING
          VALUE(rv_msg) TYPE string,
      get_payload_act
        RETURNING
          VALUE(rv_payload) TYPE string,
      get_correct_msg_v2
        RETURNING
          VALUE(rv_msg) TYPE string.
ENDCLASS.


CLASS ltcl_parser_test IMPLEMENTATION.

  METHOD msg_correct01.
    DATA lv_msg TYPE string.
    lv_msg = get_correct_msg( ).
    DATA(lv_payload_exp) = get_payload_act( ).

    DATA lo_amm_parser TYPE REF TO zcl_eit1_amm_msg_parser.

    lo_amm_parser = NEW #( iv_data = lv_msg ).
    DATA(ls_payload) = lo_amm_parser->parse( ).

    DATA(lv_xml_formatted) = NEW zcl_eit1_xml_pretty_printer(
                                    iv_xml = ls_payload-content )->pprint( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_xml_formatted   " Data object with current value
        exp                  =  lv_payload_exp   " Data object with expected type
    ).
  ENDMETHOD.

  METHOD msg_correct02.
    DATA lv_msg TYPE string.
    lv_msg = get_correct_msg_v2( ).
    DATA(lv_payload_exp) = get_payload_act( ).

    DATA lo_amm_parser TYPE REF TO zcl_eit1_amm_msg_parser.

    lo_amm_parser = NEW #( iv_data = lv_msg ).
    DATA(ls_payload) = lo_amm_parser->parse( ).

    DATA(lv_xml_formatted) = NEW zcl_eit1_xml_pretty_printer(
                                    iv_xml = ls_payload-content )->pprint( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_xml_formatted   " Data object with current value
        exp                  =  lv_payload_exp   " Data object with expected type
    ).
  ENDMETHOD.

  METHOD get_correct_msg.
    rv_msg =
|POST http://i905pzd76.sap.internal.example.com:57600/XISOAPAdapter/MessageServlet?senderParty=&senderService=BS_D_EXTSYS&receiverParty=&receiverService=&interface=InvoiceProcessingExtsysInvoiceHeader_Out HTTP/1.1\n| &&
|content-type:multipart/related; boundary=SAP_4b3c0e87-a2ed-11e9-9843-000010a8128a_END; type="text/xml"; start="<soap-4b3c0e86a2ed11e9cef5000010a8128a@sap.com>"\n| &&
|http:POST\n| &&
|content-length:7987\n| &&
|\n| &&
|\n| &&
|--SAP_4b3c0e87-a2ed-11e9-9843-000010a8128a_END\n| &&
|Content-ID: <soap-4b3c0e86a2ed11e9cef5000010a8128a@sap.com>\n| &&
|Content-Type: text/xml; charset=utf-8\n| &&
|Content-Disposition: attachment;filename="soap-4b3c0e86a2ed11e9cef5000010a8128a@sap.com.xml"\n| &&
|Content-Description: SOAP\n| &&
|\n| &&
|<SOAP:Envelope xmlns:SOAP='http://schemas.xmlsoap.org/soap/envelope/'></SOAP:Envelope>\n| &&
|--SAP_4b3c0e87-a2ed-11e9-9843-000010a8128a_END\n| &&
|Content-ID: <payload-4b388e64a2ed11e9c783000010a8128a@sap.com>\n| &&
|Content-Disposition: attachment;filename="MainDocument.xml"\n| &&
|Content-Type: application/xml\n| &&
|Content-Description: MainDocument\n| &&
|\n| &&
|<?xml version="1.0" encoding="UTF-8"?><INTERNAL_ORDER01><IDOC BEGIN="1"><EDI_DC40 SEGMENT="1"><TABNAM>EDI_DC40</TABNAM><MANDT>200</MANDT><DOCNUM>0000000000341838</DOCNUM><DOCREL>740</DOCREL><STATUS>30</STATUS><DIRECT>1</DIRECT><OUTMOD>2</OUTMOD><ID| &&
|OCTYP>INTERNAL_ORDER01</IDOCTYP><MESTYP>INTERNAL_ORDER</MESTYP><STDMES>INTERN</STDMES><SNDPOR>SAPEXD</SNDPOR><SNDPRT>LS</SNDPRT><CREDAT>20190711</CRE| &&
|DAT></EDI_DC40><E1BP2075_MASTERDATA_ALE SEGMENT="1"><ORDER_CATG>01</ORDER_CATG><SHORT_TEXT>DF test.</SHORT_TEXT><ENTERED_BY>USER| &&
|</ENTERED_BY><CO_AREA>RETL</CO_ARE| &&
|A><S_ORD_ITEM>000000</S_ORD_ITEM><CURRENCY>GBP</CURRENCY><ESTIMATED_COSTS>0.0000</ESTIMATED_COSTS><AP| &&
|PLICATION_DATE>00000000</APPLICATION_DATE><DATE_WORK_BEGINS>00000000</DATE_WORK_BEGINS><DATE_WORK_ENDS>00000000</DATE_WORK_ENDS><PROCESSING_GROUP>00</PROCESSING_GROUP><ORDER_STATUS>00</ORDER_STATUS><LAST_STAT_CHANGE>00000000</LAST_STAT_CHANGE><REAC| &&
|HED_STATUS>00</REACHED_STATUS><PHASE_RELEASE>X</PHASE_RELEASE><PLN_RELEASE>00000000</PLN_RELEASE><PLN_COMPLETION>00000000</PLN_COMPLETION><DATE_COMPLETION>00000000</DATE_COMPLETION| &&
|><DATE_CLOSE>00000000</DATE_CLOSE></E1BP2075_MASTERDATA_ALE></IDOC></INTERNAL_ORDER01>\n| &&
|--SAP_4b3c0e87-a2ed-11e9-9843-000010a8128a_END--\n|.


  ENDMETHOD.


  METHOD get_payload_act.
    rv_payload =
|﻿<?xml version="1.0" encoding="utf-16"?>\n| &&
|<INTERNAL_ORDER01>\n| &&
| <IDOC BEGIN="1">\n| &&
|  <EDI_DC40 SEGMENT="1">\n| &&
|   <TABNAM>EDI_DC40</TABNAM>\n| &&
|   <MANDT>200</MANDT>\n| &&
|   <DOCNUM>0000000000341838</DOCNUM>\n| &&
|   <DOCREL>740</DOCREL>\n| &&
|   <STATUS>30</STATUS>\n| &&
|   <DIRECT>1</DIRECT>\n| &&
|   <OUTMOD>2</OUTMOD>\n| &&
|   <IDOCTYP>INTERNAL_ORDER01</IDOCTYP>\n| &&
|   <MESTYP>INTERNAL_ORDER</MESTYP>\n| &&
|   <STDMES>INTERN</STDMES>\n| &&
|   <SNDPOR>SAPEXD</SNDPOR>\n| &&
|   <SNDPRT>LS</SNDPRT>\n| &&
|   <CREDAT>20190711</CREDAT>\n| &&
|  </EDI_DC40>\n| &&
|  <E1BP2075_MASTERDATA_ALE SEGMENT="1">\n| &&
|   <ORDER_CATG>01</ORDER_CATG>\n| &&
|   <SHORT_TEXT>DF test.</SHORT_TEXT>\n| &&
|   <ENTERED_BY>USER</ENTERED_BY>\n| &&
|   <CO_AREA>RETL</CO_AREA>\n| &&
|   <S_ORD_ITEM>000000</S_ORD_ITEM>\n| &&
|   <CURRENCY>GBP</CURRENCY>\n| &&
|   <ESTIMATED_COSTS>0.0000</ESTIMATED_COSTS>\n| &&
|   <APPLICATION_DATE>00000000</APPLICATION_DATE>\n| &&
|   <DATE_WORK_BEGINS>00000000</DATE_WORK_BEGINS>\n| &&
|   <DATE_WORK_ENDS>00000000</DATE_WORK_ENDS>\n| &&
|   <PROCESSING_GROUP>00</PROCESSING_GROUP>\n| &&
|   <ORDER_STATUS>00</ORDER_STATUS>\n| &&
|   <LAST_STAT_CHANGE>00000000</LAST_STAT_CHANGE>\n| &&
|   <REACHED_STATUS>00</REACHED_STATUS>\n| &&
|   <PHASE_RELEASE>X</PHASE_RELEASE>\n| &&
|   <PLN_RELEASE>00000000</PLN_RELEASE>\n| &&
|   <PLN_COMPLETION>00000000</PLN_COMPLETION>\n| &&
|   <DATE_COMPLETION>00000000</DATE_COMPLETION>\n| &&
|   <DATE_CLOSE>00000000</DATE_CLOSE>\n| &&
|  </E1BP2075_MASTERDATA_ALE>\n| &&
| </IDOC>\n| &&
|</INTERNAL_ORDER01>\n|.

  ENDMETHOD.

  METHOD test_http_request.
    DATA lo_request  TYPE REF TO if_http_request.
    lo_request = NEW cl_http_request(
*        c_msg     =
*        add_c_msg = 0
    ).

    DATA(lv_request) = get_correct_msg( ).

    DATA(lv_xreq) = cl_abap_codepage=>convert_to(
                    source                        = lv_request
*                    codepage                      = `UTF-8`
                    ).
    lo_request->from_xstring( data = lv_xreq ).

    DATA lv_data_xstring  TYPE xstring.
    DATA: lt_header_fields TYPE tihttpnvp.
    lv_data_xstring = lo_request->get_raw_message( ).
    DATA(lv_request_to_xstring) = lo_request->to_xstring( ).

    DATA(lv_num_mul) = lo_request->num_multiparts( ).


    DO lv_num_mul TIMES.
      DATA(lv_idx) = sy-index.
      DATA(lo_entity) = lo_request->get_multipart( index = lv_idx ).
      DATA(lv_cdata) = lo_entity->get_cdata( ).
      lo_entity->get_header_fields(
        CHANGING
          fields =   lt_header_fields  " Header fields
      ).
    ENDDO.

  ENDMETHOD.

  METHOD get_correct_msg_v2.
    rv_msg =
    |POST http://example.com HTTP/1.1\n| &&
|content-type:multipart/related; boundary=SAP_d7142120-4d78-11ea-b1a4-00002dc59d92_END; type="text/xml"; start="<soap-68B599C104081EEA93AF1AC8F8AB32E7@sap.com>"\n| &&
|http:POST\n| &&
|content-length:4726\n| &&
|\n| &&
|\n| &&
|--SAP_d7142120-4d78-11ea-b1a4-00002dc59d92_END\n| &&
|content-id: <soap-68B599C104081EEA93AF1AC8F8AB32E7@sap.com>\n| &&
|Content-Type: text/xml; charset=utf-8\n| &&
|\n| &&
|<SOAP:Envelope xmlns:SOAP='http://schemas.xmlsoap.org/soap/envelope/'><SOAP:Header xmlns:urn='urn:example.com:EXTSYS:Invoice' SOAP:mustUnderstand='1' xmlns:SAP='http://sap.com/xi/XI/Message/30'| &&
|versionMajor='003' versionMinor='001' xmlns:Id='wsuid-main-92ABE13F5C59AB7FE10000000A1551F7' xmlns:wsu='http://www.docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'><SAP:ReliableMessaging SOAP:mustUnderstand='1'>| &&
|<SAP:QualityOfService>BestEffort</SAP:QualityOfService></SAP:ReliableMessaging><SAP:Main versionMajor='3' versionMinor='1' SOAP:mustUnderstand='1' wsu:Id='wsuid-main-92ABE13F5C59AB7FE10000000A1551F7'><SAP:MessageClass>| &&
|ApplicationResponse</SAP:MessageClass>| &&
|SAP:ProcessingMode>synchronous</SAP:ProcessingMode><SAP:MessageId>68b599c1-0408-1eea-93af-1ac8f8ab12e7</SAP:MessageId><SAP:RefToMessageId>d130a012-4d78-11ea-a1a8-00002dc59d92</SAP:RefToMessageId><SAP:TimeSent>2020-02-12T09:19:58Z| &&
|</SAP:TimeSent><SAP:Sender><SAP:Party agency='' scheme=''></SAP:Party><SAP:Service>BS_ESD_300</SAP:Service></SAP:Sender><SAP:Receiver><SAP:Party agency='http://sap.com/xi/XI' scheme='XIParty'></SAP:Party><SAP:Service>BS_D_EXTSYS</SAP:Service>| &&
|</SAP:Receiver><SAP:Interface namespace='urn:example.com:EXTSYS:Invoice'>InvoiceProcessingEXTSYSInvoiceHeader_Out</SAP:Interface></SAP:Main><SAP:Diagnostic SOAP:mustUnderstand='1'><SAP:TraceLevel>Information</SAP:TraceLevel><SAP:Logging>Off| &&
|</SAP:Logging></SAP:Diagnostic><SAP:System SOAP:mustUnderstand='1'><SAP:Record namespace='/xmlvalidation' name='SYNC_RESPONSE_BEFORE_MAPPING'>1</SAP:Record></SAP:System><SAP:DynamicConfiguration SOAP:mustUnderstand='1'><SAP:Record| &&
| namespace='http://sap.com/xi/XI/System/SOAP' name='SndrSOAPAction'>http://sap.com/xi/WebService/soap1.1</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/Message/30/routing' name='SourceMessageTypeNS'>urn:example.com:EXTSYS:Invoice| &&
|</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/Message/30/routing' name='InterfaceDeterminationHash'>4968e7514fab8602e1bbbaeaa4cf0aca</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/System/SOAP' name='SndrTransportProtocol'>| &&
|http</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/Message/30/routing' name='SourceMessageType'>invoice-header</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/Message/30/routing' name='InterfaceFromOperation'>| &&
|InvoiceProcessingEXTSYSInvoiceHeader_Out</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/System/SOAP' name='SndrCharset'>UTF-8</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/System/SOAP' name='SndrEndpointURL'>| &&
|http://pzd.sap.internal.example.com/XISOAPAdapter/MessageServlet</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/Message/30/general' name='senderAgreementGUID'>8e2ca092b0a6323f932d25737bf5c645</SAP:Record>| &&
|<SAP:Record namespace='http://sap.com/xi/XI/System/SOAP' name='SndrClientAddr'>10.5.0.254</SAP:Record></SAP:DynamicConfiguration></SOAP:Header></SOAP:Envelope>| &&
|--SAP_d7142120-4d78-11ea-b1a4-00002dc59d92_END\n| &&
|content-id: <payload-68B599C104081EEA93AF1AC8F8AAD2E7@sap.com>\n| &&
|content-type: application/xml\n| &&
|\n| &&
|<?xml version="1.0" encoding="UTF-8"?><INTERNAL_ORDER01><IDOC BEGIN="1"><EDI_DC40 SEGMENT="1"><TABNAM>EDI_DC40</TABNAM><MANDT>200</MANDT><DOCNUM>0000000000341838</DOCNUM><DOCREL>740</DOCREL><STATUS>30</STATUS><DIRECT>1</DIRECT><OUTMOD>2</OUTMOD><ID| &&
|OCTYP>INTERNAL_ORDER01</IDOCTYP><MESTYP>INTERNAL_ORDER</MESTYP><STDMES>INTERN</STDMES><SNDPOR>SAPEXD</SNDPOR><SNDPRT>LS</SNDPRT><CREDAT>20190711</CRE| &&
|DAT></EDI_DC40><E1BP2075_MASTERDATA_ALE SEGMENT="1"><ORDER_CATG>01</ORDER_CATG><SHORT_TEXT>DF test.</SHORT_TEXT><ENTERED_BY>USER| &&
|</ENTERED_BY><CO_AREA>RETL</CO_ARE| &&
|A><S_ORD_ITEM>000000</S_ORD_ITEM><CURRENCY>GBP</CURRENCY><ESTIMATED_COSTS>0.0000</ESTIMATED_COSTS><AP| &&
|PLICATION_DATE>00000000</APPLICATION_DATE><DATE_WORK_BEGINS>00000000</DATE_WORK_BEGINS><DATE_WORK_ENDS>00000000</DATE_WORK_ENDS><PROCESSING_GROUP>00</PROCESSING_GROUP><ORDER_STATUS>00</ORDER_STATUS><LAST_STAT_CHANGE>00000000</LAST_STAT_CHANGE><REAC| &&
|HED_STATUS>00</REACHED_STATUS><PHASE_RELEASE>X</PHASE_RELEASE><PLN_RELEASE>00000000</PLN_RELEASE><PLN_COMPLETION>00000000</PLN_COMPLETION><DATE_COMPLETION>00000000</DATE_COMPLETION| &&
|><DATE_CLOSE>00000000</DATE_CLOSE></E1BP2075_MASTERDATA_ALE></IDOC></INTERNAL_ORDER01>\n| &&
|--SAP_4b3c0e87-a2ed-11e9-9843-000010a8128a_END--\n|.
  ENDMETHOD.

ENDCLASS.
