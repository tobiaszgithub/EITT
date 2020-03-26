*"* use this source file for your ABAP unit test classes
CLASS lcl_amm_proxy_mock DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_eit1_amm_proxy.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_response
      RETURNING
        VALUE(rv_response) TYPE xstring.

ENDCLASS.

CLASS lcl_amm_proxy_mock IMPLEMENTATION.

  METHOD zif_eit1_amm_proxy~get_messages_by_ids.
    DATA(lv_message_id) = VALUE #( input-message_ids-string[ 1 ] OPTIONAL ).
    CASE lv_message_id.
      WHEN 'msg1'.
        output-response-list-adapter_framework_data = VALUE #( ( message_key = 'msg_key1' ) ).
    ENDCASE.
  ENDMETHOD.

  METHOD zif_eit1_amm_proxy~get_message_bytes_java_lang_st.

  ENDMETHOD.

  METHOD zif_eit1_amm_proxy~get_logged_message_bytes.

    CASE input-message_key.
      WHEN 'msg_key1'.
        output-response = get_response( ).
    ENDCASE.
  ENDMETHOD.

  METHOD zif_eit1_amm_proxy~get_message_list.
    CASE input-filter-interface-name.
      WHEN 'intf1'.
        output-response-list-adapter_framework_data = VALUE #( ( interface-name = 'intf1' ) ).
    ENDCASE.
  ENDMETHOD.

  METHOD zif_eit1_amm_proxy~get_integration_flows.

  ENDMETHOD.


  METHOD get_response.


    DATA(lv_response) =
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
|OCTYP>INTERNAL_ORDER01</IDOCTYP><MESTYP>INTERNAL_ORDER</MESTYP><STDMES>INTERN</STDMES><SNDPOR>SAPEXD<CREDAT>20190711</CRE| &&
|DAT></EDI_DC40><E1BP2075_MASTERDATA_ALE SEGMENT="1"><SHORT_TEXT>DF test.</SHORT_TEXT><ENTERED_BY>USER| &&
|</ENTERED_BY><CO_AREA>RETL</CO_ARE| &&
|A><AP| &&
|PLICATION_DATE>00000000</APPLICATION_DATE><REAC| &&
|HED_STATUS>00<DATE_COMPLETION>00000000</DATE_COMPLETION| &&
|></E1BP2075_MASTERDATA_ALE></IDOC></INTERNAL_ORDER01>\n| &&
|--SAP_4b3c0e87-a2ed-11e9-9843-000010a8128a_END--\n|.

    rv_response = cl_abap_codepage=>convert_to(
                source                        = lv_response
*                    codepage                      = `UTF-8`
                ).

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_amm_service DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: mo_cut TYPE REF TO zif_eit1_amm_service .
    DATA: mo_amm_proxy_mock TYPE REF TO lcl_amm_proxy_mock.

    METHODS:
      setup.
    METHODS:
      get_message_list_01 FOR TESTING RAISING cx_static_check.
    METHODS:
      get_message_list_02 FOR TESTING RAISING cx_static_check.
    METHODS:
      get_payload_by_msg_id_01 FOR TESTING RAISING cx_static_check.
    METHODS:
      get_payload_by_msg_id_02 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_amm_service IMPLEMENTATION.
  METHOD setup.
    mo_amm_proxy_mock = NEW lcl_amm_proxy_mock( ).
    mo_cut = NEW zcl_eit1_amm_service(
        iv_log_port_name = 'DUMMY'
        io_amm_proxy     = mo_amm_proxy_mock
    ).
  ENDMETHOD.

  METHOD get_message_list_01.
    DATA:
          ls_filter         TYPE zst_eit1_amm_msg_list_filter.

    DATA(lt_result) = mo_cut->get_message_list( is_filter = ls_filter ).
    cl_abap_unit_assert=>assert_initial(
        act              = lt_result
    ).
  ENDMETHOD.

  METHOD get_message_list_02.
    DATA:
          ls_filter         TYPE zst_eit1_amm_msg_list_filter.
    ls_filter-interface_name = 'intf1'.
    DATA(lt_result) = mo_cut->get_message_list( is_filter = ls_filter ).

    cl_abap_unit_assert=>assert_not_initial(
        act              =  lt_result   " Actual Data Object
    ).
  ENDMETHOD.

  METHOD get_payload_by_msg_id_01.
    DATA(ls_payload)     = mo_cut->get_payload_by_msg_id(
                    iv_message_id      = 'msg_not_exits'
*                   iv_reference_id    =
                    iv_version         = 'BI'
               ).
*                 CATCH zcx_eit1_exception.  "

    cl_abap_unit_assert=>assert_initial(
        act              = ls_payload
    ).
  ENDMETHOD.

  METHOD get_payload_by_msg_id_02.

    DATA(ls_payload)     = mo_cut->get_payload_by_msg_id(
                   iv_message_id      = 'msg1'
*                   iv_reference_id    =
                   iv_version         = 'BI'
               ).
*                 CATCH zcx_eit1_exception.  "

    cl_abap_unit_assert=>assert_not_initial(
        act              = ls_payload
    ).
  ENDMETHOD.

ENDCLASS.
