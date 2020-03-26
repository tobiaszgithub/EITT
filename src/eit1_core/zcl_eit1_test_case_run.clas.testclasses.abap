*"* use this source file for your ABAP unit test classes
CLASS ltcl_test_case DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      execute_01 FOR TESTING RAISING cx_static_check.
    METHODS
      execute_02 FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_test_case IMPLEMENTATION.

  METHOD execute_01.

    DATA lo_test_case TYPE REF TO ZCL_EIT1_TEST_CASE_RUN.
    DATA lo_payload_act TYPE REF TO zcl_eit1_payload.
    DATA lo_payload_exp TYPE REF TO zcl_eit1_payload.
    DATA: lv_result TYPE abap_bool.
    "data(lv_payload_bm) = get_payload_from_db( iv_MSGGUID = 'F64B5F3FA4A711E9C597000010A8128A' ).

    lo_payload_act = NEW #( is_content = VALUE #( ) ).
    lo_payload_exp = NEW #( is_content = VALUE #( ) ).

    lo_test_case = NEW #( io_act = lo_payload_act
                          io_exp = lo_payload_exp ).

    lv_result = lo_test_case->execute( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_result    " Data object with current value
        exp                  = abap_true    " Data object with expected type
    ).

    lo_payload_act = NEW #( is_content = VALUE #( content = '<test></test>' ) ).
    lo_payload_exp = NEW #( is_content = VALUE #( content = '<test></test>' ) ).

    lo_test_case = NEW #( io_act = lo_payload_act
                          io_exp = lo_payload_exp ).

    lv_result = lo_test_case->execute( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_result    " Data object with current value
        exp                  = abap_true    " Data object with expected type
    ).

    lo_payload_act = NEW #( is_content = VALUE #( content = '<test></test>' ) ).
    lo_payload_exp = NEW #( is_content = VALUE #( content = '' ) ).

    lo_test_case = NEW #( io_act = lo_payload_act
                          io_exp = lo_payload_exp ).

    lv_result = lo_test_case->execute( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_result    " Data object with current value
        exp                  = abap_false    " Data object with expected type
    ).
  ENDMETHOD.

  METHOD execute_02.
    DATA lo_test_case TYPE REF TO ZCL_EIT1_TEST_CASE_RUN.
    DATA ls_content TYPE zst_eit1_content.
    DATA lo_payload_act TYPE REF TO zcl_eit1_payload.
    DATA lo_payload_exp TYPE REF TO zcl_eit1_payload.

    "data(lv_payload_bm) = get_payload_from_db( iv_MSGGUID = 'F64B5F3FA4A711E9C597000010A8128A' ).
    lo_payload_act = NEW #( is_content = ls_content ).
    lo_payload_exp = NEW #( is_content = ls_content ).

    lo_test_case = NEW #( io_act = lo_payload_act
                          io_exp = lo_payload_exp ).

    DATA(lv_result) = lo_test_case->execute( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lv_result   " Data object with current value
        exp                  = abap_true    " Data object with expected type
    ).

  ENDMETHOD.

ENDCLASS.
