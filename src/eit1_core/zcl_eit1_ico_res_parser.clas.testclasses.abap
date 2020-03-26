*"* use this source file for your ABAP unit test classes
CLASS ltcl_parser DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      correct_xml_01 FOR TESTING RAISING cx_static_check.
    METHODS: get_correct_xml RETURNING VALUE(rv_xml) TYPE string.
    DATA: mv_correct_xml TYPE string.

ENDCLASS.


CLASS ltcl_parser IMPLEMENTATION.

  METHOD correct_xml_01.
    DATA(lv_xml) = get_correct_xml( ).
    DATA(lo_parser) = NEW zcl_eit1_ico_res_parser( iv_data = lv_xml ).
    DATA(ls_result) = lo_parser->parse( ).
    DATA(ls_result_exp) = VALUE zst_eit1_ico_service_res(
        message_id        = 'be23dd1b-a3c9-11e9-99b7-000010a8128a'
        ref_to_message_id = 'd89d67c5-0482-1ee9-a8f9-3784f7958a01'
        time_sent          = '2019-07-11T10:50:48Z'
    ).
    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  ls_result-message_id
        exp                  =  ls_result_exp-message_id ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  =  ls_result-ref_to_message_id
        exp                  =  ls_result_exp-ref_to_message_id ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
      act                  =  ls_result-time_sent
      exp                  =  ls_result_exp-time_sent ).

  ENDMETHOD.

  METHOD get_correct_xml.
    rv_xml =

    |<SOAP:Envelope xmlns:SOAP='http://schemas.xmlsoap.org/soap/envelope/'>| &&
    |  <SOAP:Header>| &&
    |    <sap:Ack xmlns:sap='http://sap.com/xi/XI/Message/30' SOAP:mustUnderstand='1'>| &&
    |      <sap:Status>OK</sap:Status>| &&
    |    </sap:Ack>| &&
    |    <sap:Main xmlns:sap='http://sap.com/xi/XI/Message/30' versionMajor='3' versionMinor='1' SOAP:mustUnderstand='1'>| &&
    |      <sap:MessageClass>SystemAck</sap:MessageClass>| &&
    |      <sap:ProcessingMode>synchronous</sap:ProcessingMode>| &&
    |      <sap:MessageId>be23dd1b-a3c9-11e9-99b7-000010a8128a</sap:MessageId>| &&
    |      <sap:RefToMessageId>d89d67c5-0482-1ee9-a8f9-3784f7958a01</sap:RefToMessageId>| &&
    |      <sap:TimeSent>2019-07-11T10:50:48Z</sap:TimeSent>| &&
    |      <sap:Sender>| &&
    |        <sap:Party agency='http://sap.com/xi/XI' scheme='XIParty'></sap:Party>| &&
    |        <sap:Service></sap:Service>| &&
    |      </sap:Sender>| &&
    |      <sap:Receiver>| &&
    |        <sap:Party agency='http://sap.com/xi/XI' scheme='XIParty'></sap:Party>| &&
    |        <sap:Service>BS_EXD_200</sap:Service>| &&
    |      </sap:Receiver>| &&
    |      <sap:Interface namespace='urn:sap-com:document:sap:idoc:messages'>ZCREMAS02.CREMAS06.ZCREMASX</sap:Interface>| &&
    |    </sap:Main>| &&
    |  </SOAP:Header>| &&
    |  <SOAP:Body/>| &&
    |</SOAP:Envelope>|.

  ENDMETHOD.

ENDCLASS.
