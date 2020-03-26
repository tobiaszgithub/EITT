*----------------------------------------------------------------------*
***INCLUDE ZEIT2_TESTS_EXECUTE_OUTPUT.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  SET_STATUS_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_status_0101 OUTPUT.
  IF gv_edit = abap_true.
    SET TITLEBAR 'SCREEN_0101_EDIT'.
    SET PF-STATUS 'SCREEN_0101_NORMAL'.
  ELSE.
    SET TITLEBAR 'SCREEN_0101_NORMAL'.
    SET PF-STATUS 'SCREEN_0101_NORMAL' EXCLUDING 'SAVE'.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  START_CONTROL_HANDLING  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE start_control_handling OUTPUT.
  "TRY.
      go_testing_cockpit = zcl_eit2_testing_cockpit=>get_instance( ).
*    CATCH zcx_eit2_testing_exception INTO DATA(gx_exc).
*      gx_exc->display_log(
**      EXPORTING
**        iv_object        = 'ZBC'    " Application Log: Object Name (Application Code)
**        iv_subobject     =     " Application Log: Subobject
**        iv_title         =     " Application Log: Screen title
**        iv_show_tree     =     " Indicator for Show Tree
**        iv_standard_disp =     " Standard Display
**        iv_extnumber     =     " External number
*      ).
*  ENDTRY.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SHOW_TESTS_GRID_0201  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE show_tests_grid_0201 OUTPUT.
  go_testing_cockpit->render_tests_grid( ).
ENDMODULE.
