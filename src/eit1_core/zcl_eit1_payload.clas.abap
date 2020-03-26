CLASS zcl_eit1_payload DEFINITION
  PUBLIC

  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_eit1_content.
    ALIASES get_content FOR zif_eit1_content~get_content.
    METHODS constructor
      IMPORTING
        iv_guid    TYPE zde_eitt_msgguid OPTIONAL
        is_content TYPE zst_eit1_content.
    DATA ms_content TYPE zst_eit1_content READ-ONLY.
    DATA mv_guid TYPE zde_eitt_msgguid READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_eit1_payload IMPLEMENTATION.


  METHOD constructor.

    me->ms_content = is_content.
    me->mv_guid = iv_guid.
  ENDMETHOD.


  METHOD zif_eit1_content~get_content.
    rv_content = ms_content-content.
  ENDMETHOD.
ENDCLASS.
