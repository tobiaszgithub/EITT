CLASS zcl_eit1_texts_diff DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF t_abapstring,
             line TYPE string,
           END OF t_abapstring.

    TYPES tt_abapstring TYPE STANDARD TABLE OF abaptxt255.

    INTERFACES zif_eit1_texts_diff.
    ALIASES: compare FOR zif_eit1_texts_diff~compare.






  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS: _compare
      IMPORTING it_abapstring_pri   TYPE tt_abapstring
                it_abapstring_sec   TYPE tt_abapstring
      EXPORTING
                et_abapstring_delta TYPE zif_eit1_texts_diff=>tt_vxabapstring.
ENDCLASS.



CLASS zcl_eit1_texts_diff IMPLEMENTATION.

  METHOD _compare.
    DATA lv_delta_options TYPE char4 VALUE '   2'.
    DATA lt_abapstring_delta TYPE vxabapt255_tab.
    DATA lt_abapstring_pri TYPE tt_abapstring.
    DATA lt_abapstring_sec TYPE tt_abapstring .

    lt_abapstring_pri = it_abapstring_pri.
    lt_abapstring_sec = it_abapstring_sec.

*    CALL 'C_MAKE_TEXT_DELTA'                              "#EC CI_CCALL
*      ID 'TI_TEXT_PRI' FIELD lt_abapstring_pri "ti_text_pri-*sys*
*      ID 'TI_TEXT_SEC' FIELD  lt_abapstring_sec "ti_text_sec-*sys*
*      ID 'PI_DELTA_OPTIONS' FIELD lv_delta_options
*      ID 'TO_TEXT_DELTA' FIELD lt_abapstring_delta.

    IF sy-subrc = 8.
*   Kein freier Speicher verfügbar
      "MESSAGE a129.
    ENDIF.

    DATA: lt_trdirtab_old TYPE TABLE OF trdir,
          lt_trdirtab_new TYPE TABLE OF trdir,
          lt_trdir_delta  TYPE TABLE OF xtrdir.
    DATA: it_new   TYPE abaptxt255_tab,
          it_old   TYPE abaptxt255_tab,
          rt_delta TYPE vxabapt255_tab.
    MOVE-CORRESPONDING it_abapstring_pri TO it_old.
    MOVE-CORRESPONDING it_abapstring_sec TO it_new.

    CALL FUNCTION 'SVRS_COMPUTE_DELTA_REPS'
      TABLES
        texttab_old  = it_old
        texttab_new  = it_new
        trdirtab_old = lt_trdirtab_old
        trdirtab_new = lt_trdirtab_new
        trdir_delta  = lt_trdir_delta
        text_delta   = rt_delta.

    CLEAR lt_abapstring_delta.

    "et_abapstring_delta = lt_abapstring_delta.
    MOVE-CORRESPONDING rt_delta TO lt_abapstring_delta.
    MOVE-CORRESPONDING rt_delta TO et_abapstring_delta.
  ENDMETHOD.

  METHOD compare.
    DATA: lt_payload_pri  TYPE zcl_eit1_texts_diff=>tt_abapstring,
          lt_payload_sec  TYPE zcl_eit1_texts_diff=>tt_abapstring,
          lt_payload_diff TYPE zif_eit1_texts_diff=>tt_vxabapstring.

    SPLIT iv_pri AT cl_abap_char_utilities=>newline
        INTO TABLE DATA(lt_payload_str_pri).

    lt_payload_pri = VALUE #( FOR wa IN lt_payload_str_pri
                                    ( line = wa ) ).

    SPLIT iv_sec AT cl_abap_char_utilities=>newline
        INTO TABLE DATA(lt_payload_str_sec).
    lt_payload_sec = VALUE #( FOR wa IN lt_payload_str_sec
                                    ( line = wa ) ).
    _compare(
      EXPORTING
        it_abapstring_pri   = lt_payload_pri
        it_abapstring_sec   = lt_payload_sec
      IMPORTING
        et_abapstring_delta = lt_payload_diff
    ).

    rt_abapstring_delta = lt_payload_diff.
  ENDMETHOD.

ENDCLASS.
