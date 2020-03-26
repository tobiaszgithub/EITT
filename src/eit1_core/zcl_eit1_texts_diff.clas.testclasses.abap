*"* use this source file for your ABAP unit test classes
CLASS ltcl_texts_diff DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      compare_equal_strings FOR TESTING RAISING cx_static_check,
      compare_empty_strings FOR TESTING RAISING cx_static_check,
      compare_different_strings FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_texts_diff IMPLEMENTATION.

  METHOD compare_equal_strings.
    DATA lo_cut TYPE REF TO zcl_eit1_texts_diff.

    lo_cut = NEW #( ).
    DATA(lt_result) = lo_cut->compare(
                iv_pri              = 'test'
                iv_sec              = 'test'
            ).
    cl_abap_unit_assert=>assert_initial( msg = 'equal strings should give an empty table'
                                         act = lt_result ).
  ENDMETHOD.

  METHOD compare_empty_strings.
    DATA lo_cut TYPE REF TO zcl_eit1_texts_diff.

    lo_cut = NEW #( ).
    DATA(lt_result) = lo_cut->compare(
                iv_pri              = ''
                iv_sec              = ''
            ).
    cl_abap_unit_assert=>assert_initial( msg = 'equal strings should give an empty table'
                                         act = lt_result ).
  ENDMETHOD.

  METHOD compare_different_strings.
    DATA lo_cut TYPE REF TO zcl_eit1_texts_diff.

    lo_cut = NEW #( ).
    DATA(lt_result) = lo_cut->compare(
                iv_pri              = 'test'
                iv_sec              = 'test2'
            ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_result ) exp = 1 ).
  ENDMETHOD.

ENDCLASS.
