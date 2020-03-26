INTERFACE zif_eit1_test_case_repository
  PUBLIC .
  METHODS: get_test_case_by_id
    IMPORTING iv_id               TYPE zteit_test_cases-test_case_id
    RETURNING VALUE(ro_test_case) TYPE REF TO zcl_eit1_test_case
    RAISING   zcx_eit1_exception.

  METHODS: insert_test_case
    IMPORTING io_test_case TYPE REF TO zcl_eit1_test_case.

  METHODS: delete_test_case
    IMPORTING iv_id TYPE zteit_test_cases-test_case_id.

  METHODS: update_test_case
    IMPORTING io_test_case TYPE REF TO zcl_eit1_test_case.

  METHODS: save.
ENDINTERFACE.
