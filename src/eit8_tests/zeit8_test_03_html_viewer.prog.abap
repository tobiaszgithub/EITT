*&---------------------------------------------------------------------*
*& Report  zeit8_test_03_html_viewer
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_test_03_html_viewer.


*** cl_gui_html_viewer instance
DATA : gr_browser TYPE REF TO cl_gui_html_viewer.

*** Data definitions HTML Content
DATA : gv_url(1024)  TYPE c.
DATA : gt_html TYPE TABLE OF char255 WITH HEADER LINE.
DATA : gs_html LIKE LINE OF gt_html.
DATA : gv_color TYPE string VALUE '#e5f1f4'.

*** Internal Table That has main Data
DATA : BEGIN OF gt_main OCCURS 10,
         persno TYPE i,
         name   TYPE string,
         age    TYPE i,
       END OF gt_main.

*** Macro helps to create HTML content table
DEFINE add_to_html.
  clear : gs_html.
  gs_html = &1.
  append gs_html to gt_html.
END-OF-DEFINITION.

*** START-OF-SELECTION
START-OF-SELECTION.

  PERFORM add_data_for_demo.

  CALL SCREEN 100.


*&---------------------------------------------------------------------*
*&      Form  add_data_for_demo
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM add_data_for_demo.

*** Demo table to show
  DATA : lv_temp TYPE string.

  DO 30 TIMES.
    lv_temp = sy-index.
    CONCATENATE 'Employee No ' lv_temp INTO lv_temp SEPARATED BY ' '.

    CLEAR : gt_main.
    gt_main-persno = sy-index + 60 .
    gt_main-name = lv_temp.
    gt_main-age = ( sy-index + 60 ) / 3.
    APPEND gt_main.
  ENDDO.

ENDFORM.                    "add_data_for_demo
*&---------------------------------------------------------------------*
*&      Module  pbo_100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_100 OUTPUT.

  SET PF-STATUS 'PFST100'.
  SET TITLEBAR 'TITLE100'.

*** Show Html Table
  PERFORM html_viewer.

ENDMODULE.                 " pbo_100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  pai_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_100 INPUT.

  CASE sy-ucomm.

    WHEN 'BACK'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.                 " pai_100  INPUT

*&---------------------------------------------------------------------*
*&      Form  html_viewer
*&---------------------------------------------------------------------*
FORM html_viewer .

*** Create Instance Using Default Screen As Parent
  CREATE OBJECT gr_browser
    EXPORTING
      parent = cl_gui_container=>screen0.


*** Create Your HTML Content
  gv_url = 'test.htm'.

*** Html Head
  add_to_html :
  '<html><head><meta http-equiv=Content-Type content="text/html; ',
  'charset=UTF-8"></head><body style="background:#b8fa84">' .

*** Html Body
*** Html Body
  add_to_html : '<b> THANKS to cl_gui_html_viewer </b><br><br><br>'.


*** Html Table Properties : You can also use css
  add_to_html :
    '<table border=1 cellpadding=1 cellspacing=0',
    'width=''500px''><thead>',
    '<tr style="background:lightgray;text-align:center;">',
    '<td colspan=3>',
    '<b > Report Header </b>',
    '</td></tr></thead>'.

*** Add header to html table
  add_to_html :
   '<tr align=center><td style="width:20%;background-color:azure">ID',
   '</td><td style="width:40%;background-color:azure">Name',
 '</td><td style="width:40%;background-color:azure;">Age</td></tr>'.


*** Show your internal table
  LOOP AT gt_main.
    PERFORM add_lines USING
          gt_main-persno gt_main-name gt_main-age.
  ENDLOOP.


*** Close HTML
  add_to_html : '</table></body></html>'.

*** Load HTML Data
  CALL METHOD gr_browser->load_data
    EXPORTING
      url          = gv_url
    IMPORTING
      assigned_url = gv_url
    CHANGING
      data_table   = gt_html[].

*** Show Url
  CALL METHOD gr_browser->show_url
    EXPORTING
      url = gv_url.

  CALL METHOD cl_gui_html_viewer=>set_focus
    EXPORTING
      control           = gr_browser
    EXCEPTIONS
      cntl_error        = 1
      cntl_system_error = 2
      OTHERS            = 3.



ENDFORM.                    " html_viewer
*&---------------------------------------------------------------------*
*&      Form  add_lines
*&---------------------------------------------------------------------*
FORM add_lines USING p_1 p_2 p_3.

  DATA : lv_str1 TYPE string.
  DATA : lv_str2 TYPE string.
  DATA : lv_str3 TYPE string.

*** Zebra Style
  IF gv_color = '#e5f1f4'.
    gv_color = '#f8fbfc'.
  ELSE.
    gv_color = '#e5f1f4'.
  ENDIF.

  lv_str1 = p_1.
  lv_str2 = p_2.
  lv_str3 = p_3.

  CONCATENATE
  '<tr align=center><td style="width:20%;background-color:'
  gv_color '">' lv_str1 '</td>' INTO gs_html.
  APPEND gs_html TO gt_html.

  CONCATENATE
  '<td style="width:40%;background-color:' gv_color '">' lv_str2
  '</td><td style="width:40%;background-color:'
  gv_color '">' lv_str3  '</td></tr>'
  INTO gs_html.
  APPEND gs_html TO gt_html.

ENDFORM.                    "add_lines
