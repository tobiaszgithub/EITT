*&---------------------------------------------------------------------*
*& Report  zeit8_test_03_html_viewer
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_test_05_html_viewer.


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

  add_to_html : '<pre id="display"></pre>'.
  add_to_html : '<div id="destination-elem-id"></div>'.
  add_to_html : ''.
  add_to_html : '<link rel="stylesheet" type="text/css" href="http://cdnjs.cloudflare.com/ajax/libs/diff2html/2.11.2/diff2html.css">'.
  add_to_html : '<script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/diff2html/2.11.2/diff2html.js"></script>'.
  add_to_html : ''.
  add_to_html : '<script src="http://cdnjs.cloudflare.com/ajax/libs/jsdiff/4.0.1/diff.js"></script>'.
  add_to_html : '<script>'.
  add_to_html : ''.
  add_to_html : 'var span = null;'.
  add_to_html : 'var display = document.getElementById(''display'');'.
  add_to_html : 'var fragment = document.createDocumentFragment();'.
  add_to_html : ''.
  add_to_html : 'var oldStr = "Line0\nLine 1\nLine2\nLine2.1\nLine2.2\nLine4\nLine5\n";'.
  add_to_html : 'var newStr = "Linex\nLine 1\nLine2\nLine3\nLine3.1\nLine3.2\nLine4\nLine5\n"'.
  add_to_html : 'var diff = Diff.createTwoFilesPatch("File1", "File1", oldStr, newStr);'.
  add_to_html : ''.
  add_to_html : 'span = document.createElement(''span'');'.
  add_to_html : 'span.appendChild(document'.
  add_to_html : '.createTextNode(diff));'.
  add_to_html : 'fragment.appendChild(span);'.
  add_to_html : 'display.appendChild(fragment);'.
  add_to_html : ''.
  add_to_html : 'var diffHtml = Diff2Html.getPrettyHtml('.
  add_to_html : 'diff,'.
  add_to_html : '{inputFormat: ''diff'', showFiles: true, matching: ''lines'', outputFormat: ''side-by-side''}'.
  add_to_html : ');'.
  add_to_html : 'document.getElementById("destination-elem-id").innerHTML = diffHtml;'.
  add_to_html : '</script>'.


  DATA: editor_x TYPE xstring.
  DATA: editor_string TYPE string.
  DATA: mime_path TYPE string VALUE '/SAP/PUBLIC/EITT/01_jsdiff_example.html'.

  DATA: converter TYPE REF TO cl_abap_conv_in_ce.
  cl_mime_repository_api=>get_api( )->get(
   EXPORTING i_url = mime_path
   IMPORTING e_content = editor_x
   EXCEPTIONS OTHERS = 1 ).
  CHECK sy-subrc EQ 0.


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
