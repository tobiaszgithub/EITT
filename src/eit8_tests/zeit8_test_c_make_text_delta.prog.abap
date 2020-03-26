*&---------------------------------------------------------------------*
*& Report  ZEIT8_TEST_C_MAKE_TEXT_DELTA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_test_c_make_text_delta.

DATA lt_abaptxt255_pri TYPE STANDARD TABLE OF abaptxt255.
DATA lt_abaptxt255_sec TYPE STANDARD TABLE OF abaptxt255.
DATA lt_vxabapt255_delta TYPE STANDARD TABLE OF vxabapt255.
DATA lv_delta_options TYPE char4 VALUE '   2'.

lt_abaptxt255_pri = VALUE #( ( line = 'test' )
                             ( line = 'test1' )
                             ( line = 'test2' ) ).

lt_abaptxt255_sec = VALUE #( ( line = 'test' )
                             ( line = 'test1' )
                             ( line = 'test2' ) ).

CALL 'C_MAKE_TEXT_DELTA'                                  "#EC CI_CCALL
  ID 'TI_TEXT_PRI' FIELD lt_abaptxt255_pri "ti_text_pri-*sys*
  ID 'TI_TEXT_SEC' FIELD  lt_abaptxt255_sec "ti_text_sec-*sys*
  ID 'PI_DELTA_OPTIONS' FIELD lv_delta_options
  ID 'TO_TEXT_DELTA' FIELD lt_vxabapt255_delta.

IF sy-subrc = 8.
*   Kein freier Speicher verfügbar
  "MESSAGE a129.
ENDIF.



lt_abaptxt255_pri = VALUE #( ( line = 'test' )
                             ( line = 'test1' )
                             ( line = 'test2' ) ).

lt_abaptxt255_sec = VALUE #( ( line = 'test' )
                             ( line = 'test1234' )
                             ( line = 'test2' ) ).

CALL 'C_MAKE_TEXT_DELTA'                                  "#EC CI_CCALL
  ID 'TI_TEXT_PRI' FIELD lt_abaptxt255_pri "ti_text_pri-*sys*
  ID 'TI_TEXT_SEC' FIELD  lt_abaptxt255_sec "ti_text_sec-*sys*
  ID 'PI_DELTA_OPTIONS' FIELD lv_delta_options
  ID 'TO_TEXT_DELTA' FIELD lt_vxabapt255_delta.

IF sy-subrc = 8.
*   Kein freier Speicher verfügbar
  "MESSAGE a129.
ENDIF.


TYPES: BEGIN OF t_abapstring,
         line TYPE string,
       END OF t_abapstring.

TYPES: BEGIN OF t_vxabapstring,
         vrsflag TYPE sychar04,
         number  TYPE dbglinno,
         line    TYPE string,
       END OF t_vxabapstring.

DATA lt_abapstring_pri TYPE STANDARD TABLE OF abaptxt255.
DATA lt_abapstring_sec TYPE STANDARD TABLE OF abaptxt255.
DATA lt_vxabapstring_delta TYPE STANDARD TABLE OF t_vxabapstring.

lt_abapstring_pri = VALUE #( ( line = 'test' )
                             ( line = 'test1' )
                             ( line = 'test2' ) ).

lt_abapstring_sec = VALUE #( ( line = 'test' )
                             ( line = 'test123' )
                             ( line = 'test2' ) ).


CALL 'C_MAKE_TEXT_DELTA'                                  "#EC CI_CCALL
  ID 'TI_TEXT_PRI' FIELD lt_abapstring_pri "ti_text_pri-*sys*
  ID 'TI_TEXT_SEC' FIELD  lt_abapstring_sec "ti_text_sec-*sys*
  ID 'PI_DELTA_OPTIONS' FIELD lv_delta_options
  ID 'TO_TEXT_DELTA' FIELD lt_vxabapstring_delta.

IF sy-subrc = 8.
*   Kein freier Speicher verfügbar
  "MESSAGE a129.
ENDIF.
