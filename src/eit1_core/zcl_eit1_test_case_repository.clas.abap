CLASS zcl_eit1_test_case_repository DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_eit1_test_case_repository.
    ALIASES get_test_case_by_id FOR zif_eit1_test_case_repository~get_test_case_by_id.
    ALIASES update_test_case FOR zif_eit1_test_case_repository~update_test_case.
    ALIASES insert_test_case FOR zif_eit1_test_case_repository~insert_test_case.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_eit1_test_case_repository IMPLEMENTATION.
  METHOD zif_eit1_test_case_repository~get_test_case_by_id.
    SELECT SINGLE * FROM zteit_test_cases
        INTO @DATA(ls_test_case)
        WHERE test_case_id = @iv_id.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    ro_test_case = NEW zcl_eit1_test_case(
        is_test_case = ls_test_case ).

  ENDMETHOD.

  METHOD zif_eit1_test_case_repository~insert_test_case.
    DATA(ls_test_case) = io_test_case->ms_test_case.

    INSERT zteit_test_cases FROM @ls_test_case.
  ENDMETHOD.

  METHOD zif_eit1_test_case_repository~delete_test_case.

  ENDMETHOD.

  METHOD zif_eit1_test_case_repository~update_test_case.
    DATA(ls_test_case) = io_test_case->ms_test_case.
    MODIFY zteit_test_cases FROM @ls_test_case.
  ENDMETHOD.

  METHOD zif_eit1_test_case_repository~save.
    COMMIT WORK AND WAIT.
  ENDMETHOD.

ENDCLASS.
