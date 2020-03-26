CLASS zcl_eit1_amm_msg_parser DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_data TYPE string.
    METHODS parse
      RETURNING
        VALUE(rs_payload) TYPE zst_eit1_content.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_data TYPE string.


ENDCLASS.



CLASS zcl_eit1_amm_msg_parser IMPLEMENTATION.


  METHOD constructor.

    me->mv_data = iv_data.

  ENDMETHOD.


  METHOD parse.
    DATA lv_payload TYPE string.
    DATA: lv_output TYPE string.
    DATA lv_main_doc_start TYPE i.
    "
    DATA lo_http_request TYPE REF TO if_http_request.

    lo_http_request = NEW cl_http_request( ).

    "message from PI is HTTP request but POST segment is missing
    DATA lv_request TYPE string.
    lv_request = |POST http://example.com HTTP/1.1\n| && |{ mv_data }|.

    DATA(lv_xrequest) = cl_abap_codepage=>convert_to(
                        source                        = lv_request
                        codepage                      = 'UTF-8' ).

    lo_http_request->from_xstring( data = lv_xrequest ).

    DATA(lv_num_mul) = lo_http_request->num_multiparts( ).
    IF lv_num_mul > 0.
      DATA(lo_payload_entity) = lo_http_request->get_multipart( index = lv_num_mul ).
      lv_payload = lo_payload_entity->get_cdata( ).
      DATA(lv_content_type) = lo_payload_entity->get_content_type( ).
      DATA(lv_content_id) = lo_payload_entity->get_header_field( name = 'content-id' ).
    ELSE.
      SPLIT lv_request AT cl_abap_char_utilities=>newline INTO TABLE DATA(lt_lines).
      DATA(lv_lines_no) = lines( lt_lines ).
      lv_payload = lt_lines[ lv_lines_no - 1  ].
    ENDIF.

    rs_payload-content_id = lv_content_id.
    rs_payload-content = lv_payload.
    rs_payload-content_type = lv_content_type.
  ENDMETHOD.

ENDCLASS.
