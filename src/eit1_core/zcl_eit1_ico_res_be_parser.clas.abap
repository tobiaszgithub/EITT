CLASS zcl_eit1_ico_res_be_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_data TYPE string.
    METHODS parse
      RETURNING
                VALUE(rs_response) TYPE zst_eit1_ico_service_res
      RAISING   zcx_eit1_exception.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_data TYPE string.

    METHODS process_errors
      IMPORTING
        io_parser TYPE REF TO if_ixml_parser.
ENDCLASS.



CLASS ZCL_EIT1_ICO_RES_BE_PARSER IMPLEMENTATION.


  METHOD constructor.

    me->mv_data = iv_data.

  ENDMETHOD.


  METHOD parse.
    DATA lv_payload TYPE string.
    DATA: lv_output TYPE string.
    DATA lv_main_doc_start TYPE i.
    DATA: lx_exc  TYPE REF TO zcx_eit1_exception.

    lx_exc = NEW #( ).
    "
    DATA lo_http_request TYPE REF TO if_http_request.

    lo_http_request = NEW cl_http_request( ).
    SPLIT mv_data AT cl_abap_char_utilities=>newline INTO TABLE DATA(lt_data).
    DATA(lv_boundary) = VALUE #( lt_data[ 1 ] OPTIONAL ).
    lv_boundary = shift_left( val = lv_boundary places = 2 ).
    "message from PI is HTTP request but POST segment is missing
    DATA lv_request TYPE string.
    lv_request =
    |POST http://example.com HTTP/1.1\n| &&
    |content-type:multipart/related; boundary=| && |{ lv_boundary }; type="text/xml";\n| &&
    |\n| &&
    |\n| &&
    |{ mv_data }|.

    DATA(lv_xrequest) = cl_abap_codepage=>convert_to(
                        source                        = lv_request
                        codepage                      = 'UTF-8' ).

    lo_http_request->from_xstring( data = lv_xrequest ).

    DATA(lv_num_mul) = lo_http_request->num_multiparts( ).

    DATA(lo_payload_entity) = lo_http_request->get_multipart( index = lv_num_mul ).
    IF lo_payload_entity IS NOT BOUND.
      MESSAGE e002(zeit1) INTO DATA(lv_msg).
      lx_exc->append_sy_message( ).
      RAISE EXCEPTION lx_exc.
    ENDIF.
    lv_payload = lo_payload_entity->get_cdata( ).
    DATA(lv_content_type) = lo_payload_entity->get_content_type( ).
    DATA(lv_content_id) = lo_payload_entity->get_header_field( name = 'content-id' ).

    rs_response-synch_response-content_id = lv_content_id.
    rs_response-synch_response-content = lv_payload.
    rs_response-synch_response-content_type = lv_content_type.

    DATA(lo_ico_soap_response_entity) = lo_http_request->get_multipart( index = 1 ).
    DATA(lv_ico_soap_response) = lo_ico_soap_response_entity->get_cdata( ).

    DATA(lo_ico_soap_parser) = NEW zcl_eit1_ico_res_parser( iv_data = lv_ico_soap_response ).
    DATA(ls_ico_soap) = lo_ico_soap_parser->parse( ).
    rs_response-message_id = ls_ico_soap-message_id.
    rs_response-ref_to_message_id = ls_ico_soap-ref_to_message_id.
    rs_response-time_sent = ls_ico_soap-time_sent.

  ENDMETHOD.


  METHOD process_errors.

  ENDMETHOD.
ENDCLASS.
