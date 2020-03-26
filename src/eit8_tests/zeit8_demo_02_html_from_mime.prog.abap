REPORT zeit8_demo_02_html_from_mime.

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
    CONSTANTS:
      BEGIN OF c_cntl_lifetime,
        default     TYPE i VALUE 0,
        dynpro      TYPE i VALUE 1,
        imode       TYPE i VALUE 2,
        transaction TYPE i VALUE 3,
        session     TYPE i VALUE 4,
      END OF c_cntl_lifetime .

    DATA(custom_container) = NEW
*      cl_gui_custom_container( container_name = 'CUSTOM_CONTAINER' ).
  cl_gui_dialogbox_container(
*        parent                      =
        width                       = 1200
        height                      = 300
*        style                       =
*        repid                       =
*        dynnr                       =
*        lifetime                    = c_cntl_lifetime-dynpro
*        top                         = 0
*        left                        = 0
*        caption                     =
*        no_autodef_progid_dynnr     =
*        metric                      = 0
*        name                        =
    ).
    custom_container->set_visible(
      EXPORTING
        visible           =  ''   " Visible
*      EXCEPTIONS
*        cntl_error        = 1
*        cntl_system_error = 2
*        others            = 3
    ).
    IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

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

    custom_container->set_visible(
      EXPORTING
        visible           =  'X'   " Visible
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

  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*&      Module  PBO_100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_100 OUTPUT.
  mime_demo=>main( ).
ENDMODULE.
