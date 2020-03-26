CLASS zcl_eit2_xml_diff DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_pri TYPE string
        iv_sec TYPE string.
    METHODS show_dialog_screen.
    METHODS free.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_pri TYPE string.
    DATA mv_sec TYPE string.
    DATA: mo_html_control TYPE REF TO cl_gui_html_viewer.
    METHODS get_mime_obj
      IMPORTING
        mime_url     TYPE string
      EXPORTING
        et_html_soli TYPE soli_tab.
ENDCLASS.



CLASS zcl_eit2_xml_diff IMPLEMENTATION.

  METHOD constructor.

    me->mv_pri = iv_pri.
    me->mv_sec = iv_sec.

  ENDMETHOD.
  METHOD show_dialog_screen.
    DATA lv_html_url TYPE c LENGTH 255.
    DATA lt_html_soli TYPE soli_tab.

    DATA(lo_custom_container) = NEW
      cl_gui_custom_container( container_name = 'CUSTOM_CONTAINER' ).

    mo_html_control = NEW
     cl_gui_html_viewer( parent = lo_custom_container ).

    get_mime_obj(
      EXPORTING
      mime_url = '/SAP/PUBLIC/EITT/01_jsdiff_example.html'
      IMPORTING
      et_html_soli = lt_html_soli ).

    mo_html_control->load_data(
          IMPORTING
            assigned_url = lv_html_url
          CHANGING
            data_table   = lt_html_soli ).

    mo_html_control->show_url(
       EXPORTING
         url = lv_html_url ).


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


    DATA(lv_xml1) = mv_pri.
    DATA(lv_xml2) = mv_sec.

    REPLACE ALL OCCURRENCES OF '&oldStr&' IN editor_string WITH lv_xml1.
    REPLACE ALL OCCURRENCES OF '&newStr&' IN editor_string WITH lv_xml2.
*    replace all occurrences of '&&width&&' in editor_string with width.

    et_html_soli =  cl_bcs_convert=>string_to_soli( iv_string = editor_string ).
  ENDMETHOD.


  METHOD free.
    mo_html_control->free(
*      EXCEPTIONS
*        cntl_error        = 1
*        cntl_system_error = 2
*        others            = 3
    ).
    IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
