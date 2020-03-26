*"* use this source file for your ABAP unit test classes
CLASS ltcl_parser_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      response_correct02 FOR TESTING RAISING cx_static_check,
      get_correct_response
        RETURNING
          VALUE(rv_res) TYPE string,
      get_payload_act01
        RETURNING VALUE(rv_payload) TYPE string.
ENDCLASS.


CLASS ltcl_parser_test IMPLEMENTATION.

  METHOD response_correct02.
    DATA lv_response TYPE string.
    lv_response = get_correct_response( ).
    DATA(lv_payload_exp) = get_payload_act01( ).

    DATA lo_amm_parser TYPE REF TO zcl_eit1_ico_res_be_parser.

    lo_amm_parser = NEW #( iv_data = lv_response ).
    DATA(ls_payload) = lo_amm_parser->parse( ).

    DATA(lv_xml_formatted) = NEW zcl_eit1_xml_pretty_printer(
                                    iv_xml = ls_payload-synch_response-content )->pprint( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  lv_xml_formatted   " Data object with current value
        exp                  =  lv_payload_exp   " Data object with expected type
    ).
  ENDMETHOD.

  METHOD get_correct_response.
    rv_res =
  |--SAP_acfa451e-f4d1-11e9-bfbd-000010a8128a_END\n| &&
  |content-id: <soap-D89D67C504821EE9BD9A359EB86E9E09@sap.com>\n| &&
  |Content-Type: text/xml; charset=utf-8\n| &&
  |\n| &&
  |<SOAP:Envelope xmlns:SOAP='http://schemas.xmlsoap.org/soap/envelope/'><SOAP:Header xmlns:sap='http://sap.com/xi/XI/Message/30' xmlns:SAP='http://sap.com/xi/XI/Message/30' xmlns:wsu='http://www.docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecu| &&
 |rity-utility-1.0.xsd'><SAP:ReliableMessaging SOAP:mustUnderstand='1'><SAP:QualityOfService>BestEffort</SAP:QualityOfService></SAP:ReliableMessaging><SAP:HopList SOAP:mustUnderstand='1'><SAP:Hop timeStamp='2019-10-22T13:41:39Z' wasRead='false'><SAP:E| &&
 |ngine type='AE'>af.pxd.i905pxd27</SAP:Engine><SAP:Adapter namespace='http://sap.com/xi/XI/System'>XIRA</SAP:Adapter><SAP:MessageId>d89d67c5-0482-1ee9-bd9a-2ff9716a9300</SAP:MessageId><SAP:Info></SAP:Info></SAP:Hop><SAP:Hop timeStamp='2019-10-22T13:4| &&
 |1:39Z' wasRead='false'><SAP:Engine type='BS'>BS_EXD_200</SAP:Engine><SAP:Adapter namespace='http://sap.com/xi/XI/System'>XI</SAP:Adapter><SAP:MessageId>d89d67c5-0482-1ee9-bd9a-2ff9716a9300</SAP:MessageId><SAP:Info>3.0</SAP:Info></SAP:Hop><SAP:Hop ti| &&
 |meStamp='2019-10-22T13:41:39Z' wasRead='false'><SAP:Engine type='AE'>af.pxd.i905pxd27</SAP:Engine><SAP:Adapter namespace='http://sap.com/xi/XI/System'>XIRA</SAP:Adapter><SAP:MessageId>d89d67c5-0482-1ee9-bd9a-359df1279e08</SAP:MessageId></SAP:Hop></S| &&
 |AP:HopList><SAP:Diagnostic SOAP:mustUnderstand='1'><SAP:TraceLevel>Information</SAP:TraceLevel><SAP:Logging>Off</SAP:Logging></SAP:Diagnostic><SAP:System SOAP:mustUnderstand='1'><SAP:Record namespace='/xmlvalidation' name='SYNC_RESPONSE_BEFORE_MAPPI| &&
 |NG'>1</SAP:Record></SAP:System><SAP:DynamicConfiguration SOAP:mustUnderstand='1'><SAP:Record namespace='http://sap.com/xi/XI/Message/30/routing' name='SourceMessageTypeNS'>urn:example.com:EXTSYS:Invoice</SAP:Record><SAP:Record namespace='http://| &&
 |sap.com/xi/XI/Message/30/routing' name='InterfaceDeterminationHash'>8444770bc3bc2008220faa673087e6d7</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/Message/30/routing' name='SourceMessageType'>invoice-header</SAP:Record><SAP:Record namespac| &&
 |e='http://sap.com/xi/XI/Message/30/routing' name='InterfaceFromOperation'>InvoiceProcessingExtsyInvoiceHeader_Out</SAP:Record><SAP:Record namespace='http://sap.com/xi/XI/Message/30/general' name='senderAgreementGUID'>8e2ca092b0a6323f932d25737bf5c645| &&
 |</SAP:Record></SAP:DynamicConfiguration><SAP:Main versionMajor='3' versionMinor='1' SOAP:mustUnderstand='1'><SAP:MessageClass>ApplicationResponse</SAP:MessageClass><SAP:ProcessingMode>synchronous</SAP:ProcessingMode><SAP:MessageId>d89d67c5-0482-1ee9| &&
 |-bd9a-359df1279e08</SAP:MessageId><SAP:RefToMessageId>d89d67c5-0482-1ee9-bd9a-2ff9716a9300</SAP:RefToMessageId><SAP:TimeSent>2019-10-22T13:41:39Z</SAP:TimeSent><SAP:Sender><SAP:Party agency='' scheme=''></SAP:Party><SAP:Service>BS_EXD_200</SAP:Servi| &&
 |ce></SAP:Sender><SAP:Receiver><SAP:Party agency='http://sap.com/xi/XI' scheme='XIParty'></SAP:Party><SAP:Service>BS_D_EXTSYS</SAP:Service></SAP:Receiver><SAP:Interface namespace='urn:example.com:EXTSYS:Invoice'>InvoiceProcessingExtsyInvoiceHe| &&
 |ader_Out</SAP:Interface></SAP:Main></SOAP:Header><SOAP:Body><sap:Manifest xmlns:sap='http://sap.com/xi/XI/Message/30' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:wsu='http://www.docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utilit| &&
 |y-1.0.xsd' wsu:Id='wsuid-manifest-5CABE13F5C59AB7FE10000000A1551F7'><sap:Payload xlink:type='simple' xlink:href='cid:payload-D89D67C504821EE9BD9A359D3DBEDE08@sap.com'><sap:Name>MainDocument</sap:Name><sap:Description></sap:Description><sap:Type>Appl| &&
 |ication</sap:Type></sap:Payload></sap:Manifest></SOAP:Body></SOAP:Envelope>\n| &&
 |--SAP_acfa451e-f4d1-11e9-bfbd-000010a8128a_END\n| &&
 |content-id: <payload-D89D67C504821EE9BD9A359D3DBEDE08@sap.com>\n| &&
 |Content-Type: application/xml\n| &&
 |\n| &&
 |<?xml version="1.0" encoding="UTF-8"?>\n| &&
 |<ns1:invoice-header-bapi-response xmlns:ns1="urn:example.com:EXTSYS:Invoice"><OBJ_KEY>$</OBJ_KEY><ACCOUNTGL><item><ITEMNO_ACC>0000000002</ITEMNO_ACC><ITEM_TEXT>| &&
 |paper</ITEM_TEXT></item></ACCOUNTGL><ACCOUNTPAYABLE><item><ITEMNO_ACC>0000099999</ITEMNO_ACC></item></ACCOUNTPAYABLE><ACCOUNTTAX><item><ITEMNO_ACC>000000100| &&
 |0</ITEMNO_ACC></item></ACCOUNTTAX><CURRENCYAMOUNT><item><ITEMNO_ACC>0000099999</ITEMNO_ACC><CURRENCY>USD</CURRENCY><CURRENCY_ISO>USD</CURRENCY_ISO><AMT_DOCCUR>-800.0</AMT_DOCCUR></item><item><ITEMNO_ACC>0000000002</ITEMNO_ACC>| &&
 |<CURRENCY>USD</CURRENCY><CURRENCY_ISO>USD</CURRENCY_ISO><AMT_DOCCUR>800.0</AMT_DOCCUR></item><item><ITEMNO_ACC>0000001000</ITEMNO_ACC><CURRENCY>USD</CURRENCY><CURRENCY_ISO>USD</CURRENCY_ISO><AMT_BASE>800.0</AMT_BASE></item></CURRENCYAMOUNT><RETURN><| &&
 |item><TYPE>E</TYPE><ID>RW</ID><NUMBER>609</NUMBER><MESSAGE>Error in document: BKPFF $ EXDCLNT200</MESSAGE><MESSAGE_V1>BKPFF</MESSAGE_V1><MESSAGE_V2>$</MESSAGE_V2><MESSAGE_V3>EXDCLNT200</MESSAGE_V3></item><item><TYPE>E</TYP| &&
 |E><ID>F5</ID><NUMBER>104</NUMBER><MESSAGE>Vendor 1000000 is not defined in company code 1001</MESSAGE><MESSAGE_V1>1000000</MESSAGE_V1><MESSAGE_V2>1001</MESSAGE_V2></item><item><TYPE>E</TYPE><ID>F5</ID><NUMBER>104</NUMBER><| &&
 |MESSAGE>Vendor 1000000 is not defined in company code 1001</MESSAGE><MESSAGE_V1>1000000</MESSAGE_V1><MESSAGE_V2>1001</MESSAGE_V2><PARAMETER>ACCOUNTPAYABLE</PARAMETER><ROW>1</ROW><FIELD>VENDOR_NO</FIELD></item></RETURN></ns| &&
 |1:invoice-header-bapi-response>\n| &&
 |--SAP_acfa451e-f4d1-11e9-bfbd-000010a8128a_END--\n|.
  ENDMETHOD.

  METHOD get_payload_act01.
    rv_payload =
|﻿<?xml version="1.0" encoding="utf-16"?>\n| &&
|<ns1:invoice-header-bapi-response xmlns:ns1="urn:example.com:EXTSYS:Invoice">\n| &&
| <OBJ_KEY>$</OBJ_KEY>\n| &&
| <ACCOUNTGL>\n| &&
|  <item>\n| &&
|   <ITEMNO_ACC>0000000002</ITEMNO_ACC>\n| &&
|   <ITEM_TEXT>paper</ITEM_TEXT>\n| &&
|  </item>\n| &&
| </ACCOUNTGL>\n| &&
| <ACCOUNTPAYABLE>\n| &&
|  <item>\n| &&
|   <ITEMNO_ACC>0000099999</ITEMNO_ACC>\n| &&
|  </item>\n| &&
| </ACCOUNTPAYABLE>\n| &&
| <ACCOUNTTAX>\n| &&
|  <item>\n| &&
|   <ITEMNO_ACC>0000001000</ITEMNO_ACC>\n| &&
|  </item>\n| &&
| </ACCOUNTTAX>\n| &&
| <CURRENCYAMOUNT>\n| &&
|  <item>\n| &&
|   <ITEMNO_ACC>0000099999</ITEMNO_ACC>\n| &&
|   <CURRENCY>USD</CURRENCY>\n| &&
|   <CURRENCY_ISO>USD</CURRENCY_ISO>\n| &&
|   <AMT_DOCCUR>-800.0</AMT_DOCCUR>\n| &&
|  </item>\n| &&
|  <item>\n| &&
|   <ITEMNO_ACC>0000000002</ITEMNO_ACC>\n| &&
|   <CURRENCY>USD</CURRENCY>\n| &&
|   <CURRENCY_ISO>USD</CURRENCY_ISO>\n| &&
|   <AMT_DOCCUR>800.0</AMT_DOCCUR>\n| &&
|  </item>\n| &&
|  <item>\n| &&
|   <ITEMNO_ACC>0000001000</ITEMNO_ACC>\n| &&
|   <CURRENCY>USD</CURRENCY>\n| &&
|   <CURRENCY_ISO>USD</CURRENCY_ISO>\n| &&
|   <AMT_BASE>800.0</AMT_BASE>\n| &&
|  </item>\n| &&
| </CURRENCYAMOUNT>\n| &&
| <RETURN>\n| &&
|  <item>\n| &&
|   <TYPE>E</TYPE>\n| &&
|   <ID>RW</ID>\n| &&
|   <NUMBER>609</NUMBER>\n| &&
|   <MESSAGE>Error in document: BKPFF $ EXDCLNT200</MESSAGE>\n| &&
|   <MESSAGE_V1>BKPFF</MESSAGE_V1>\n| &&
|   <MESSAGE_V2>$</MESSAGE_V2>\n| &&
|   <MESSAGE_V3>EXDCLNT200</MESSAGE_V3>\n| &&
|  </item>\n| &&
|  <item>\n| &&
|   <TYPE>E</TYPE>\n| &&
|   <ID>F5</ID>\n| &&
|   <NUMBER>104</NUMBER>\n| &&
|   <MESSAGE>Vendor 1000000 is not defined in company code 1001</MESSAGE>\n| &&
|   <MESSAGE_V1>1000000</MESSAGE_V1>\n| &&
|   <MESSAGE_V2>1001</MESSAGE_V2>\n| &&
|  </item>\n| &&
|  <item>\n| &&
|   <TYPE>E</TYPE>\n| &&
|   <ID>F5</ID>\n| &&
|   <NUMBER>104</NUMBER>\n| &&
|   <MESSAGE>Vendor 1000000 is not defined in company code 1001</MESSAGE>\n| &&
|   <MESSAGE_V1>1000000</MESSAGE_V1>\n| &&
|   <MESSAGE_V2>1001</MESSAGE_V2>\n| &&
|   <PARAMETER>ACCOUNTPAYABLE</PARAMETER>\n| &&
|   <ROW>1</ROW>\n| &&
|   <FIELD>VENDOR_NO</FIELD>\n| &&
|  </item>\n| &&
| </RETURN>\n| &&
|</ns1:invoice-header-bapi-response>\n|.
  ENDMETHOD.

ENDCLASS.
