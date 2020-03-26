*&---------------------------------------------------------------------*
*& Report  ZEIT1_TESTS_EXECUTE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit2_tests_execute.

DATA gv_edit                 TYPE abap_bool.
DATA gv_fcode              TYPE sy-ucomm.

DATA go_testing_cockpit TYPE REF TO zcl_eit2_testing_cockpit.

START-OF-SELECTION.

  CALL SCREEN 101.

  INCLUDE zeit2_tests_execute_output.
  INCLUDE zeit2_tests_execute_input.
