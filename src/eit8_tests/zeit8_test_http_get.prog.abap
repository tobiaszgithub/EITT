*&---------------------------------------------------------------------*
*& Report  zeit8_test_message_to_ico
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_test_http_get.

DATA: lo_http_client TYPE REF TO if_http_client.
DATA: response TYPE string.

"create HTTP client by url
"API endpoint for API sandbox
CALL METHOD cl_http_client=>create_by_url
  EXPORTING
    url                = 'https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap/API_PROD_ORDER_CONFIRMATION/A_ProductionOrderConf'
"API endpoint with optional query parameters
    "url                = 'https://sandbox.api.sap.com/s4hanacloud/sap/opu/odata/sap/API_PROD_ORDER_CONFIRMATION/A_ProductionOrderConf'
"To view the complete list of query parameters, see its API definition.

  IMPORTING
    client             = lo_http_client
  EXCEPTIONS
    argument_not_found = 1
    plugin_not_active  = 2
    internal_error     = 3
    OTHERS             = 4.

"Available API Endpoints
"https://{host}:{port}/sap/opu/odata/sap/API_PROD_ORDER_CONFIRMATION

IF sy-subrc <> 0.
  "error handling
ENDIF.

"setting request method
lo_http_client->request->set_method('GET').

"adding headers
lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).
lo_http_client->request->set_header_field( name = 'Accept' value = 'application/json' ).
"API Key for API Sandbox
lo_http_client->request->set_header_field( name = 'APIKey' value = 'LObj0tMhowpMHAHMahtWQ0NVfhbh7ZzM' ).


"Available Security Schemes for productive API Endpoints
"Basic Authentication

"Basic Auth : provide username:password in Base64 encoded in Authorization header
"lo_http_client->request->set_header_field( name = 'Authorization' value = 'Basic <Base64 encoded value>' ).

CALL METHOD lo_http_client->send
  EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3
    http_invalid_timeout       = 4
    OTHERS                     = 5.

IF sy-subrc = 0.
  CALL METHOD lo_http_client->receive
    EXCEPTIONS
      http_communication_failure = 1
      http_invalid_state         = 2
      http_processing_failed     = 3
      OTHERS                     = 5.
ENDIF.

IF sy-subrc <> 0.
  "error handling
ENDIF.

response = lo_http_client->response->get_cdata( ).

WRITE: 'response: ', response.
