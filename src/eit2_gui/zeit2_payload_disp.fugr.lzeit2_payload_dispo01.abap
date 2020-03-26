*----------------------------------------------------------------------*
***INCLUDE LZEIT2_XML_DIFFO01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  PBO_100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
*  SET TITLEBAR 'xxx'.
*  go_xml_diff = NEW zcl_eit2_xml_diff( iv_pri = gv_pri
*                                          iv_sec = gv_sec ).

*  go_xml_diff->show_dialog_screen( ).
  IF go_payload_disp IS INITIAL.
    go_payload_disp = NEW zcl_eit2_payload_disp( iv_payload = gv_pri
                                                 iv_payload_guid = gv_payload_guid  ).
    go_payload_disp->show_dialog( ).
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PAI_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_100 INPUT.
  CASE sy-ucomm.
    WHEN 'ENTER' OR 'CANCEL'.
      go_payload_disp->free( ).
      clear go_payload_disp.
      LEAVE TO SCREEN 0.
    WHEN 'EDIT'.
      go_payload_disp->toggle_change_mode( ).
    WHEN 'PRETTY'.
      go_payload_disp->pretty_print( ).

    WHEN 'SAVE'.
      go_payload_disp->save( ).
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
