*----------------------------------------------------------------------*
***INCLUDE LZEIT2_MESSAGE_SELECTORI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PAI_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_100 INPUT.
  CASE sy-ucomm.
    WHEN 'CANCEL'.
      "go_xml_diff->free( ).
      LEAVE TO SCREEN 0.
    WHEN 'ENTER'.
      CALL SCREEN 200 STARTING AT 10 08.
      IF go_amm_msg_list->ms_selected_msg IS NOT INITIAL
        OR go_amm_msg_list->mt_selected_msgs IS NOT INITIAL.
        LEAVE TO SCREEN 0.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_200 INPUT.
  CASE sy-ucomm.
    WHEN 'ENTER' OR 'CANCEL'.
      go_amm_msg_list->free( ).
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
