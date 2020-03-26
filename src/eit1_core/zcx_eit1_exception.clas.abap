CLASS zcx_eit1_exception DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      tt_bapireturn TYPE STANDARD TABLE OF bapireturn .

    DATA ms_msg TYPE bapiret2 READ-ONLY .
    DATA mt_msg TYPE bapiret2_t READ-ONLY .

    METHODS constructor
      IMPORTING
        !textid   LIKE textid OPTIONAL
        !previous LIKE previous OPTIONAL
        !ms_msg   TYPE bapiret2 OPTIONAL
        !mt_msg   TYPE bapiret2_t OPTIONAL .
    METHODS append_message
      IMPORTING
        !iv_msgty TYPE symsgty DEFAULT 'E'
        !iv_msgno TYPE symsgno
        !iv_msgid TYPE symsgid DEFAULT 'ZEOT'
        !iv_msgv1 TYPE any OPTIONAL
        !iv_msgv2 TYPE any OPTIONAL
        !iv_msgv3 TYPE any OPTIONAL
        !iv_msgv4 TYPE any OPTIONAL .
    METHODS append_sy_message .
    METHODS display
      IMPORTING
        !iv_always_as_log     TYPE abap_bool OPTIONAL
        !iv_object            TYPE balobj_d DEFAULT 'ZBC'
        !iv_subobject         TYPE balsubobj OPTIONAL
        !iv_title             TYPE baltitle OPTIONAL
        !iv_show_tree         TYPE abap_bool OPTIONAL
        !iv_standard_disp     TYPE abap_bool OPTIONAL
        !iv_extnumber         TYPE any OPTIONAL
        !iv_display_like      TYPE abap_bool DEFAULT abap_false
        !iv_message_after_log TYPE abap_bool DEFAULT abap_false
          PREFERRED PARAMETER iv_display_like .
    CLASS-METHODS contains_error
      IMPORTING
        !it_msg         TYPE bapiret2_t
      RETURNING
        VALUE(rv_error) TYPE abap_bool .
    CLASS-METHODS contains_error_bapireturn
      IMPORTING
        !it_msg         TYPE tt_bapireturn
      RETURNING
        VALUE(rv_error) TYPE abap_bool .
    METHODS append_messages
      IMPORTING
        !it_bapiret2 TYPE bapiret2_t .
    CLASS-METHODS raise_from_exception
      IMPORTING
        !iv_exc_class TYPE seoclsname OPTIONAL
        !io_exception TYPE REF TO cx_root
      RAISING
        zcx_eit1_exception .
    CLASS-METHODS raise_from_sy
      IMPORTING
        !iv_exc_class TYPE seoclsname OPTIONAL
      RAISING
        zcx_eit1_exception .
    CLASS-METHODS raise_from_txt
      IMPORTING
        !iv_txt TYPE itex132
      RAISING
        zcx_eit1_exception .
    METHODS display_message
      IMPORTING
        !iv_display_like      TYPE abap_bool DEFAULT abap_false
        !iv_display_like_type TYPE symsgty OPTIONAL .
    METHODS display_log
      IMPORTING
        !iv_object        TYPE balobj_d DEFAULT 'ZBC'
        !iv_subobject     TYPE balsubobj DEFAULT 'ZBC15_MSG'
        !iv_title         TYPE baltitle OPTIONAL
        !iv_show_tree     TYPE abap_bool OPTIONAL
        !iv_standard_disp TYPE abap_bool OPTIONAL
        !iv_extnumber     TYPE any OPTIONAL .
    CLASS-METHODS create_message_sy
      RETURNING
        VALUE(rs_msg) TYPE bapiret2 .
    CLASS-METHODS create_message
      IMPORTING
        !iv_msgid     TYPE symsgid
        !iv_msgty     TYPE symsgty
        !iv_msgno     TYPE symsgno
        !iv_msgv1     TYPE any OPTIONAL
        !iv_msgv2     TYPE any OPTIONAL
        !iv_msgv3     TYPE any OPTIONAL
        !iv_msgv4     TYPE any OPTIONAL
      RETURNING
        VALUE(rs_msg) TYPE bapiret2 .
    CLASS-METHODS bapiret2_to_bapireturn
      IMPORTING
        !is_bapiret2   TYPE bapiret2
      EXPORTING
        !es_bapireturn TYPE bapireturn .
    METHODS get_messages
      RETURNING
        VALUE(rt_msg) TYPE bapiret2_t .
    CLASS-METHODS contains_error_generic
      IMPORTING
        !it_msg         TYPE ANY TABLE
      RETURNING
        VALUE(rv_error) TYPE abap_bool .

    METHODS if_message~get_longtext
         REDEFINITION .
    METHODS if_message~get_text
         REDEFINITION .
  PROTECTED SECTION.


    CLASS-METHODS message_from_txt
      IMPORTING
        !iv_txt TYPE itex132 .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_eit1_exception IMPLEMENTATION.


  METHOD append_message.

    ms_msg-type = iv_msgty.
    ms_msg-id = iv_msgid.
    ms_msg-number = iv_msgno.
    ms_msg-message_v1 = iv_msgv1.
    ms_msg-message_v2 = iv_msgv2.
    ms_msg-message_v3 = iv_msgv3.
    ms_msg-message_v4 = iv_msgv4.

    MESSAGE ID ms_msg-id TYPE ms_msg-type NUMBER ms_msg-number
      WITH ms_msg-message_v1 ms_msg-message_v2 ms_msg-message_v3
           ms_msg-message_v4 INTO ms_msg-message.

    APPEND ms_msg TO mt_msg.

  ENDMETHOD.


  METHOD append_messages.

    FIELD-SYMBOLS:
                   <ls_bapiret2> TYPE bapiret2.

    LOOP AT it_bapiret2 ASSIGNING <ls_bapiret2>.
      append_message( iv_msgty = <ls_bapiret2>-type
                      iv_msgno = <ls_bapiret2>-number
                      iv_msgid = <ls_bapiret2>-id
                      iv_msgv1 = <ls_bapiret2>-message_v1
                      iv_msgv2 = <ls_bapiret2>-message_v2
                      iv_msgv3 = <ls_bapiret2>-message_v3
                      iv_msgv4 = <ls_bapiret2>-message_v4 ).
    ENDLOOP.

  ENDMETHOD.


  METHOD append_sy_message.

    append_message( iv_msgid = sy-msgid
                    iv_msgty = sy-msgty
                    iv_msgno = sy-msgno
                    iv_msgv1 = sy-msgv1
                    iv_msgv2 = sy-msgv2
                    iv_msgv3 = sy-msgv3
                    iv_msgv4 = sy-msgv4 ).

  ENDMETHOD.


  METHOD bapiret2_to_bapireturn.
    es_bapireturn-type = is_bapiret2-type.
    es_bapireturn-code(2) = is_bapiret2-id.
    es_bapireturn-code+2(3) = is_bapiret2-number.
    es_bapireturn-message = is_bapiret2-message.
    es_bapireturn-log_no = is_bapiret2-log_no.
    es_bapireturn-log_msg_no = is_bapiret2-log_msg_no.
    es_bapireturn-message_v1 = is_bapiret2-message_v1.
    es_bapireturn-message_v2 = is_bapiret2-message_v2.
    es_bapireturn-message_v3 = is_bapiret2-message_v3.
    es_bapireturn-message_v4 = is_bapiret2-message_v4.
  ENDMETHOD.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        textid   = textid
        previous = previous.
    me->ms_msg = ms_msg .
    me->mt_msg = mt_msg .
  ENDMETHOD.


  METHOD contains_error.

    LOOP AT it_msg TRANSPORTING NO FIELDS
      WHERE type CA 'EAX'.
      rv_error = abap_true.
      EXIT.
    ENDLOOP.

  ENDMETHOD.


  METHOD contains_error_bapireturn.

    LOOP AT it_msg TRANSPORTING NO FIELDS
      WHERE type CA 'EAX'.
      rv_error = abap_true.
      EXIT.
    ENDLOOP.

  ENDMETHOD.


  METHOD contains_error_generic.
    FIELD-SYMBOLS: <lv_type> TYPE any.

    LOOP AT it_msg ASSIGNING FIELD-SYMBOL(<ls_msg>).
      ASSIGN COMPONENT 'TYPE' OF STRUCTURE <ls_msg> TO <lv_type>.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      IF <lv_type> CA 'EAX'.
        rv_error = abap_true.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD create_message.
    rs_msg-id = iv_msgid.
    rs_msg-number = iv_msgno.
    rs_msg-type = iv_msgty.
    rs_msg-message_v1 = iv_msgv1.
    rs_msg-message_v2 = iv_msgv2.
    rs_msg-message_v3 = iv_msgv3.
    rs_msg-message_v4 = iv_msgv4.

    MESSAGE ID rs_msg-id TYPE rs_msg-type NUMBER rs_msg-number
       WITH rs_msg-message_v1 rs_msg-message_v2 rs_msg-message_v3 rs_msg-message_v4
       INTO rs_msg-message.
  ENDMETHOD.


  METHOD create_message_sy.
    rs_msg = create_message(
                 iv_msgid = sy-msgid
                 iv_msgno = sy-msgno
                 iv_msgty = sy-msgty
                 iv_msgv1 = sy-msgv1
                 iv_msgv2 = sy-msgv2
                 iv_msgv3 = sy-msgv3
                 iv_msgv4 = sy-msgv4 ).

  ENDMETHOD.


  METHOD display.

    CHECK mt_msg IS NOT INITIAL.

    IF iv_always_as_log NE abap_true AND lines( mt_msg ) EQ 1.
      display_message( iv_display_like = iv_display_like ).
    ELSE.
      display_log( iv_object = iv_object
                   iv_subobject = iv_subobject
                   iv_title = iv_title
                   iv_show_tree = iv_show_tree
                   iv_standard_disp = iv_standard_disp
                   iv_extnumber = iv_extnumber ).
      IF iv_message_after_log EQ abap_true.
        CALL METHOD display_message( iv_display_like = iv_display_like ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD display_log.

    DATA(lo_logger) = zcl_logger_factory=>create_log(
*                object    =
*                subobject =
*                desc      =
*                context   =
*                settings  =
            ).
    lo_logger->add( mt_msg )->popup( ).
  ENDMETHOD.


  METHOD display_message.
    DATA:
          lv_lines TYPE i.

    IF ms_msg IS INITIAL AND mt_msg IS NOT INITIAL.
      lv_lines = lines( mt_msg ).
      READ TABLE mt_msg INTO ms_msg INDEX lv_lines.
    ENDIF.

    IF iv_display_like EQ abap_false.
      MESSAGE ID ms_msg-id TYPE ms_msg-type NUMBER ms_msg-number
          WITH ms_msg-message_v1 ms_msg-message_v2
               ms_msg-message_v3 ms_msg-message_v4.
    ELSE.
      IF iv_display_like_type IS INITIAL.
        MESSAGE ID ms_msg-id TYPE 'S' NUMBER ms_msg-number
            WITH ms_msg-message_v1 ms_msg-message_v2
                 ms_msg-message_v3 ms_msg-message_v4
            DISPLAY LIKE ms_msg-type.
      ELSE.
        MESSAGE ID ms_msg-id TYPE 'S' NUMBER ms_msg-number
            WITH ms_msg-message_v1 ms_msg-message_v2
                 ms_msg-message_v3 ms_msg-message_v4
            DISPLAY LIKE iv_display_like_type.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_messages.
    rt_msg = mt_msg.
  ENDMETHOD.


  METHOD if_message~get_longtext.
    CLEAR result.
    IF NOT ms_msg-type IS INITIAL AND NOT ms_msg-id IS INITIAL AND NOT ms_msg-number IS INITIAL.
      MESSAGE
      ID ms_msg-id
      TYPE ms_msg-type
      NUMBER ms_msg-number
      WITH ms_msg-message_v1
      ms_msg-message_v2
      ms_msg-message_v3
      ms_msg-message_v4
      INTO result.
    ENDIF.
  ENDMETHOD.


  METHOD if_message~get_text.

    CLEAR result.
    IF NOT ms_msg-type IS INITIAL AND NOT ms_msg-id IS INITIAL AND NOT ms_msg-number IS INITIAL.
      MESSAGE
        ID ms_msg-id
        TYPE ms_msg-type
        NUMBER ms_msg-number
        WITH ms_msg-message_v1
        ms_msg-message_v2
        ms_msg-message_v3
        ms_msg-message_v4
        INTO result.
    ENDIF.
  ENDMETHOD.


  METHOD message_from_txt.

    DATA:
      BEGIN OF ls_msg,
        v1 TYPE symsgv,
        v2 TYPE symsgv,
        v3 TYPE symsgv,
        v4 TYPE symsgv,
      END OF ls_msg,
      lv_dummy.


    ls_msg = iv_txt.
    MESSAGE e000(0q) WITH ls_msg-v1 ls_msg-v2 ls_msg-v3 ls_msg-v4
            INTO lv_dummy.

  ENDMETHOD.


  METHOD raise_from_exception.

    DATA lv_str TYPE string.
    lv_str = io_exception->get_text( ).


    IF io_exception->get_text( ) IS  INITIAL.
      lv_str = 'Error ocurred in interface framework processing'(001).
    ENDIF.


    CALL METHOD cl_reca_string_services=>raise_string_as_symsg
      EXPORTING
        id_msgty  = 'E'
        id_string = lv_str
      EXCEPTIONS
        message   = 1
        OTHERS    = 2.

    raise_from_sy( iv_exc_class ).

  ENDMETHOD.


  METHOD raise_from_sy.

    DATA:
          lr_ex TYPE REF TO zcx_eit1_exception.

    IF iv_exc_class IS INITIAL.
      CREATE OBJECT lr_ex.
    ELSE.
      CREATE OBJECT lr_ex TYPE (iv_exc_class).
    ENDIF.

    lr_ex->append_sy_message( ).
    RAISE EXCEPTION lr_ex.

  ENDMETHOD.


  METHOD raise_from_txt.
    message_from_txt( iv_txt ).
    CALL METHOD raise_from_sy( ).
  ENDMETHOD.
ENDCLASS.
