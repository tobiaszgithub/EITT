CLASS zcl_eit1_exit DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    CLASS-METHODS: get_instance RETURNING VALUE(ri_exit) TYPE REF TO zif_eit1_exit.
    INTERFACES: zif_eit1_exit.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA gi_exit TYPE REF TO zif_eit1_exit .
ENDCLASS.



CLASS zcl_eit1_exit IMPLEMENTATION.
  METHOD get_instance.
    IF gi_exit IS INITIAL.
      TRY.
          CREATE OBJECT gi_exit TYPE ('ZCL_EITT_USER_EXIT').
        CATCH cx_sy_create_object_error ##NO_HANDLER.
      ENDTRY.
    ENDIF.

    CREATE OBJECT ri_exit TYPE zcl_eit1_exit.
  ENDMETHOD.

  METHOD zif_eit1_exit~get_ignore_expressions.
    TRY.
        rt_expressions = gi_exit->get_ignore_expressions( iv_interface = iv_interface ).

      CATCH cx_sy_ref_is_initial cx_sy_dyn_call_illegal_method ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

  METHOD zif_eit1_exit~get_replace_expressions.
    TRY.
        rt_expressions = gi_exit->get_replace_expressions( iv_interface = iv_interface ).

      CATCH cx_sy_ref_is_initial cx_sy_dyn_call_illegal_method ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
