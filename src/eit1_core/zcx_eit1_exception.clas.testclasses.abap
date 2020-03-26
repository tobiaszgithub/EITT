*"* use this source file for your ABAP unit test classes
CLASS ltcl_eit1_exception DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      setup,
      assert_msg
        IMPORTING
          is_msg_act TYPE bapiret2,
      append_message FOR TESTING RAISING cx_static_check,
      append_messages FOR TESTING RAISING cx_static_check,
      append_sy_message FOR TESTING RAISING cx_static_check,
      bapiret2_to_bapireturn FOR TESTING RAISING cx_static_check,
      contains_error FOR TESTING RAISING cx_static_check,
      contains_error_bapireturn FOR TESTING RAISING cx_static_check,
      contains_error_generic FOR TESTING RAISING cx_static_check,
      create_message FOR TESTING RAISING cx_static_check,
      create_message_sy FOR TESTING RAISING cx_static_check,
      get_longtext FOR TESTING RAISING cx_static_check,
      get_text FOR TESTING RAISING cx_static_check.

    DATA: mx_cut TYPE REF TO zcx_eit1_exception.
ENDCLASS.


CLASS ltcl_eit1_exception IMPLEMENTATION.
  METHOD setup.
    mx_cut = NEW zcx_eit1_exception( ).
  ENDMETHOD.

  METHOD append_message.

    mx_cut->append_message(
      EXPORTING
        iv_msgty = 'E'    " Message Type
        iv_msgno =  001   " Message Number
        iv_msgid = 'ZEIT'    " Message Class
        iv_msgv1 = 'msgv1'
*        iv_msgv2 =
*        iv_msgv3 =
*        iv_msgv4 =
    ).

    DATA(lt_msgs) = mx_cut->get_messages( ).
    assert_msg( lt_msgs[ 1 ] ).
  ENDMETHOD.

  METHOD append_messages.
    DATA: lt_bapiret TYPE bapiret2_t.

    lt_bapiret = VALUE #( ( type = 'E'
                            number = '001'
                            id = 'ZEIT'
                            message_v1 = 'msgv1' ) ).
    mx_cut->append_messages( it_bapiret2 = lt_bapiret ).
    DATA(lt_msgs) = mx_cut->get_messages( ).
    assert_msg( is_msg_act = lt_msgs[ 1 ] ).
  ENDMETHOD.

  METHOD append_sy_message.
    MESSAGE e001(zeit) WITH 'msgv1' INTO DATA(lv_msg).
    mx_cut->append_sy_message( ).

    DATA(lt_msgs) = mx_cut->get_messages( ).
    assert_msg( is_msg_act = lt_msgs[ 1 ] ).
  ENDMETHOD.

  METHOD bapiret2_to_bapireturn.
    DATA: ls_bapiret2   TYPE bapiret2,
          ls_bapireturn TYPE bapireturn.
    ls_bapiret2-type = 'E'.
    ls_bapiret2-number = 001.
    ls_bapiret2-id = 'ZEIT'.
    ls_bapiret2-message_v1 = 'msgv1'.

    mx_cut->bapiret2_to_bapireturn(
      EXPORTING
        is_bapiret2   = ls_bapiret2    " Return Parameter
      IMPORTING
        es_bapireturn = ls_bapireturn    " Return Parameter
    ).

    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'E' act = ls_bapireturn-type ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'msgv1' act = ls_bapireturn-message_v1 ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 001 act = ls_bapireturn-code+2(3) ).
  ENDMETHOD.

  METHOD contains_error.
    DATA: ls_bapiret2 TYPE bapiret2,
          lt_msg      TYPE bapiret2_t.

    ls_bapiret2-type = 'E'.
    ls_bapiret2-number = 001.
    ls_bapiret2-id = 'ZEIT'.
    ls_bapiret2-message_v1 = 'msgv1'.
    APPEND ls_bapiret2 TO lt_msg.
    cl_abap_unit_assert=>assert_equals( exp = abap_true act = mx_cut->contains_error( it_msg = lt_msg ) ).
  ENDMETHOD.

  METHOD contains_error_bapireturn.
    DATA: lt_msg TYPE zcx_eit1_exception=>tt_bapireturn.

    lt_msg = VALUE #( ( type = 'E' ) ).

    cl_abap_unit_assert=>assert_equals( exp = abap_true act = mx_cut->contains_error_bapireturn( it_msg = lt_msg ) ).
  ENDMETHOD.
  METHOD contains_error_generic.
    DATA: lt_msg TYPE zcx_eit1_exception=>tt_bapireturn.

    lt_msg = VALUE #( ( type = 'E' ) ).

    cl_abap_unit_assert=>assert_equals( exp = abap_true act = mx_cut->contains_error_generic( it_msg = lt_msg ) ).

  ENDMETHOD.

  METHOD create_message.
    DATA(ls_msg) = mx_cut->create_message(
       EXPORTING
         iv_msgid = 'ZEIT'    " Message Class
         iv_msgty =  'E'   " Message Type
         iv_msgno =  001   " Message Number
         iv_msgv1 = 'msgv1' ).

    assert_msg( is_msg_act = ls_msg ).
  ENDMETHOD.

  METHOD create_message_sy.
    MESSAGE e001(zeit) WITH 'msgv1' INTO DATA(lv_msg).
    DATA(ls_msg) = mx_cut->create_message_sy( ).
    assert_msg( is_msg_act = ls_msg ).
  ENDMETHOD.

  METHOD get_longtext.
    MESSAGE e001(zeit) WITH 'msgv1' INTO DATA(lv_msg).
    mx_cut->append_sy_message( ).
    DATA(lv_longtext) = mx_cut->get_longtext( ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'E:ZEIT:001 msgv1' act = lv_longtext ).
  ENDMETHOD.

  METHOD get_text.
    MESSAGE e001(zeit) WITH 'msgv1' INTO DATA(lv_msg).
    mx_cut->append_sy_message( ).
    DATA(lv_text) = mx_cut->get_text( ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'E:ZEIT:001 msgv1' act = lv_text ).
  ENDMETHOD.

  METHOD assert_msg.
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'E' act = is_msg_act-type ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 001 act = is_msg_act-number ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'ZEIT' act = is_msg_act-id ).
    cl_abap_unit_assert=>assert_equals( msg = 'msg' exp = 'msgv1' act = is_msg_act-message_v1 ).
  ENDMETHOD.

ENDCLASS.
