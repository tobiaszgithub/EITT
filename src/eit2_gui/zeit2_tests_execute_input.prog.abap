*----------------------------------------------------------------------*
***INCLUDE ZEIT2_TESTS_EXECUTE_INPUT.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_command_0101 INPUT.
  DATA lv_answer.
  CASE gv_fcode.
    WHEN 'CANCEL'.
      "go_migration_cockpit->refresh( ).
      LEAVE TO SCREEN 0.
*      IF gs_control_panel_data-subscreen1 EQ '1011' OR
*         gs_control_panel_data-subscreen1 EQ '1012' OR
*         gs_control_panel_data-subscreen2 EQ '1011' OR
*         gs_control_panel_data-subscreen2 EQ '1012'.
*        go_migration_cockpit->refresh( ).
*        LEAVE TO SCREEN 0.
*      ELSE.
*        CALL FUNCTION 'POPUP_TO_CONFIRM'
*          EXPORTING
*            titlebar              = 'Information'
*            text_question         = 'Are you sure you want to leave'
*            text_button_1         = 'Yes'
*            icon_button_1         = 'ICON_OKAY'
*            text_button_2         = 'No'
*            icon_button_2         = 'ICON_CANCEL'
*            display_cancel_button = abap_false
*          IMPORTING
*            answer                = lv_answer ##NO_TEXT.
*
*        IF lv_answer EQ '1'.
*          go_migration_cockpit->refresh( ).
*          LEAVE TO SCREEN 0.
*        ENDIF.
*      ENDIF.
    WHEN 'EXIT'.
      "go_migration_cockpit->refresh( ).
      LEAVE PROGRAM.
    WHEN 'BACK'.
      "go_migration_cockpit->refresh( ).
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  DEFAULT_FCODE_PROCESSING  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE default_fcode_processing INPUT.
  cl_gui_cfw=>dispatch( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.
  TRY.
      go_testing_cockpit->handle_user_command( EXPORTING iv_fcode = gv_fcode ).
    CATCH zcx_eit1_exception INTO DATA(lx_error).
      lx_error->display_log(
*          EXPORTING
*            iv_object        = 'ZBC'    " Application Log: Object Name (Application Code)
*            iv_subobject     =     " Application Log: Subobject
*            iv_title         =     " Application Log: Screen title
*            iv_show_tree     =
*            iv_standard_disp =
*            iv_extnumber     =
      ).
  ENDTRY.
ENDMODULE.
