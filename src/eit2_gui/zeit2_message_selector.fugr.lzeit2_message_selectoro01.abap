*----------------------------------------------------------------------*
***INCLUDE LZEIT2_MESSAGE_SELECTORO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PBO_100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO_200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_200 OUTPUT.
  SET PF-STATUS 'STATUS_100'.

  go_amm_msg_list = NEW zcl_eit2_amm_msg_list(
                          iv_system_name = gv_system_name
                          is_filter = gs_filter ).
  go_amm_msg_list->show_dialog_screen( ).

ENDMODULE.
