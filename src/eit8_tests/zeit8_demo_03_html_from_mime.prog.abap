REPORT zeit8_demo_03_html_from_mime.

CLASS mime_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
  PRIVATE SECTION.
    TYPES: mime_line(1022) TYPE x,
           mime_tab        TYPE STANDARD TABLE OF mime_line
                                WITH EMPTY KEY.
    CLASS-METHODS get_mime_obj
      IMPORTING
        mime_url              TYPE csequence
      EXPORTING
        VALUE(et_mime_tab)    TYPE mime_tab
        VALUE(et_editor_soli) TYPE soli_tab.
ENDCLASS.

CLASS mime_demo IMPLEMENTATION.
  METHOD main.
    DATA html_url TYPE c LENGTH 255.

    DATA(custom_container) = NEW
      cl_gui_custom_container( container_name = 'CUSTOM_CONTAINER' ).
    DATA(html_control) = NEW
     cl_gui_html_viewer( parent = custom_container ).

    get_mime_obj(
        EXPORTING
      mime_url = '/SAP/PUBLIC/EITT/01_jsdiff_example.html'
      IMPORTING
        et_mime_tab = DATA(html_tab)
        et_editor_soli = DATA(html_soli_tab)
        ).
    html_control->load_data(
      IMPORTING
        assigned_url = html_url
      CHANGING
        data_table   = html_soli_tab ).

    html_control->show_url(
       EXPORTING
         url = html_url ).
  ENDMETHOD.

  METHOD get_mime_obj.
    cl_mime_repository_api=>get_api( )->get(
      EXPORTING i_url = mime_url
      IMPORTING e_content = DATA(mime_wa)
      EXCEPTIONS OTHERS = 4 ).
    IF sy-subrc = 4.
      RETURN.
    ENDIF.

    DATA: converter TYPE REF TO cl_abap_conv_in_ce.
    DATA: editor_string TYPE string.

    CALL METHOD cl_abap_conv_in_ce=>create
      EXPORTING
        encoding = 'UTF-8'
        input    = mime_wa
      RECEIVING
        conv     = converter.

    CALL METHOD converter->read
      IMPORTING
        data = editor_string.

    DATA: lo_payload_repository TYPE REF TO zcl_eit1_payload_repository.
    lo_payload_repository = NEW #( ).

    DATA(lo_payload1) = lo_payload_repository->get_payload_by_guid(
                    iv_guid = 'D89D67C504821ED9B281A9234DE6030C' ).

    DATA(lo_payload2) = lo_payload_repository->get_payload_by_guid(
                    iv_guid = 'D89D67C504821ED9B281AC11B297830B' ).
    DATA(lv_xml1) = lo_payload1->zif_eit1_content~get_content( ).
    DATA(lv_xml2) = lo_payload2->zif_eit1_content~get_content( ).

    lv_xml1 = NEW zcl_eit1_xml_pretty_printer(
                                iv_xml = lv_xml1 )->pprint( ).
    lv_xml2 = NEW zcl_eit1_xml_pretty_printer(
                                iv_xml = lv_xml2 )->pprint( ).

    REPLACE ALL OCCURRENCES OF '&oldStr&' IN editor_string WITH lv_xml1.
    REPLACE ALL OCCURRENCES OF '&newStr&' IN editor_string WITH lv_xml2.
*    replace all occurrences of '&&width&&' in editor_string with width.

    et_editor_soli =  cl_bcs_convert=>string_to_soli( iv_string = editor_string ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  CALL SCREEN 100 STARTING AT 10 08.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_100'.
*  SET TITLEBAR 'xxx'.
  mime_demo=>main( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'ENTER' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
