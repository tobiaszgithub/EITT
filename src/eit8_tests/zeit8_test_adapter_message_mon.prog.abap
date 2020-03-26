*&---------------------------------------------------------------------*
*& Report  zeit8_test_adapter_message_mon
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_test_adapter_message_mon.

DATA lo_msg_moni TYPE REF TO zeit9_co_adapter_message_monit.
DATA ls_input  TYPE zeit9_get_message_bytes_java_1.
DATA ls_output  TYPE zeit9_get_message_bytes_java_l.

lo_msg_moni = NEW  zeit9_co_adapter_message_monit(
    logical_port_name = 'PI_PXD'
).

ls_input-archive = abap_false.
ls_input-message_key = '4b386ace-a2ed-11e9-cf22-000010a8128a\OUTBOUND\279450250\EO\0\'.
ls_input-version = 0.

lo_msg_moni->get_message_bytes_java_lang_st(
  EXPORTING
    input                          = ls_input
  IMPORTING
    output                         = ls_output
).

*  CATCH cx_ai_system_fault.    "
*  CATCH zeit9_cx_get_message_bytes_jav.    "
*  CATCH zeit9_cx_get_message_bytes_ja1.    "


DATA conv TYPE REF TO cl_abap_conv_in_ce.

conv = cl_abap_conv_in_ce=>create(
        encoding = 'UTF-8' ).

DATA lv_output_str TYPE string.

conv->convert(
        EXPORTING input = ls_output-response
        IMPORTING data = lv_output_str ).

SPLIT lv_output_str AT cl_abap_char_utilities=>newline INTO TABLE DATA(lt_output).

DATA(msg_content) = lt_output[ lines( lt_output ) - 1 ].

CLEAR ls_output.
ls_input-version = -1.
lo_msg_moni->get_message_bytes_java_lang_st(
  EXPORTING
    input                          = ls_input
  IMPORTING
    output                         = ls_output
).

conv = cl_abap_conv_in_ce=>create(
        encoding = 'UTF-8' ).

conv->convert(
        EXPORTING input = ls_output-response
        IMPORTING data = lv_output_str ).

SPLIT lv_output_str AT cl_abap_char_utilities=>newline INTO TABLE lt_output.

msg_content = lt_output[ lines( lt_output ) - 1 ].

WRITE: 'testing...'.
