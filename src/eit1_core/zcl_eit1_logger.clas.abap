CLASS zcl_eit1_logger DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS: get RETURNING VALUE(ro_logger) TYPE REF TO zif_logger.
    CLASS-DATA: mo_logger TYPE REF TO zif_logger.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_eit1_logger IMPLEMENTATION.
  METHOD get.
    IF mo_logger IS NOT BOUND.
      mo_logger = zcl_logger_factory=>create_log(
        EXPORTING
          object    = 'ZEITT'
          subobject = 'EXECUTION'
*            desc      =
*            context   =
*            settings  =
      ).
    ENDIF.

    ro_logger = mo_logger.
  ENDMETHOD.

ENDCLASS.
