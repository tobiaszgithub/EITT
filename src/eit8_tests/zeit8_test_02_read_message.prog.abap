*&---------------------------------------------------------------------*
*& Report  zeit8_test_02_read_message
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_test_02_read_message.

TYPES: BEGIN OF ts_resource,

         resource TYPE REF TO if_xms_resource,

         name     TYPE string,

         ref      TYPE string,

         kind     TYPE char1,

       END OF ts_resource.

DATA: persist       TYPE REF TO cl_xms_persist,

      g_message     TYPE REF TO if_xms_message,

      l_pro_s       TYPE sxms_pro_s,

      l_pro_t       TYPE REF TO sxms_pro_t,

      l_manifest    TYPE REF TO cl_xms_msghdr30_manifest,

      super_xstring TYPE xstring,

      super_string  TYPE string,

      gt_raw_lines  TYPE sxmsraw512lines,

      binary,

      l_mf_s        TYPE sxms_mf_s,

      l_mf_t        TYPE sxms_mf_t,

      gv_length     TYPE int4,

      l_resource    TYPE REF TO if_xms_resource,

      lt_resource   TYPE TABLE OF ts_resource,

      ls_resource   TYPE ts_resource.

FIELD-SYMBOLS: <fs1> TYPE sxms_pro_t.

CREATE OBJECT persist.

CALL METHOD persist->read_msg_pub
"call method persist->read_persist_tab_version 590C75F0F50611DC81E000110A31811B
  EXPORTING
    im_msgguid = 'F7E02E28752CBA4B889B9C00AC306CD3'
    im_pid     = 'CENTRAL'
    im_version = '000'
    im_client  = '001'
  IMPORTING
    ex_message = g_message.

l_pro_t = g_message->getbodies( ).

ASSIGN l_pro_t->* TO <fs1>.

LOOP AT <fs1> INTO l_pro_s.

  IF l_pro_s-lcname = cl_xms_manifest=>lcname.

    l_manifest ?= l_pro_s-prop.

    l_mf_t = l_manifest->get_payload_refs( ).

    REFRESH lt_resource.

    LOOP AT l_mf_t INTO l_mf_s.

      CLEAR ls_resource.

      l_resource = g_message->getattachmentbyname( l_mf_s-href ).

      IF NOT l_resource IS INITIAL.

        ls_resource-resource = l_resource.

        ls_resource-name = l_mf_s-name.

        ls_resource-ref = l_mf_s-href.

        ls_resource-kind = l_resource->getkind( ).

        super_xstring = l_resource->getbinarydata( ).

        APPEND ls_resource TO lt_resource.

      ENDIF.

    ENDLOOP.

  ENDIF.

ENDLOOP.

*xmbph = cl_xms_profile=>getinstance(

"name = cl_xms_profile=>profile_name_xmb ).

*TRY.

"extmessage = xmbph->serialize( intmessage = g_message ).

"CATCH cx_xms_exception .

"CATCH cx_xms_system_error .

*ENDTRY.

*

*TRY.

"super_xstring = extmessage->WRITETO( ).

"CATCH cx_xms_exception .

*ENDTRY.

binary = 'X'.

PERFORM display_xml.

CLEAR: binary.

CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
    bin_filesize  = gv_length
    filename      = 'c:\a.xml'
    filetype      = 'BIN'
  TABLES
    data_tab      = gt_raw_lines
  EXCEPTIONS
    invalid_type  = 03
    no_batch      = 04
    unknown_error = 05
    OTHERS        = 99.

"&----

*& Form display_xml

"&----

"text

"----

"--> p1 text

"<-- p2 text

"----

FORM display_xml .

  DATA: str_l            TYPE i,

        lv_len           TYPE i,

        lv_offset        TYPE i,

        lv_len_tmp       TYPE i,

        ls_raw_line(512) TYPE x,

        gv_type(50)      TYPE c,

        l_xstring        TYPE xstring.

  "constants

  CONSTANTS: true  TYPE boolean VALUE 'X',

             false TYPE boolean VALUE ' '.

  IF strlen( super_string ) = 0 AND xstrlen( super_xstring ) = 0.

    EXIT.

  ENDIF.

  "Conversion only if the output is to be displayed in the HTML-Viewer

  "additional actions for non binary sources

  IF binary = false.

    "convert string to xstring

    CALL METHOD cl_xms_main=>convert_string_to_xstring
      EXPORTING
        im_string   = super_string
        im_encoding = 'UTF-8'
        "im_endian = im_endian
        "im_replacement = im_replacement
        "im_ignore_conv_err = im_ignore_conv_err
      IMPORTING
        ex_xstring  = super_xstring
        ex_length   = gv_length.

    gv_type = 'application'.

  ELSE.

    gv_length = xstrlen( super_xstring ).

  ENDIF.

  lv_len = gv_length.

  lv_offset = 0.

  lv_len_tmp = lv_len.

  "break string into lines of 512 bytes

  IF lv_len_tmp > 512.

    DO.

      ls_raw_line = super_xstring+lv_offset(512).

      APPEND ls_raw_line TO gt_raw_lines.

      lv_offset = lv_offset + 512.

      lv_len_tmp = lv_len_tmp - 512.

      IF lv_len_tmp < 512.

        EXIT.

      ENDIF.

    ENDDO.

  ENDIF.

  IF lv_len_tmp > 0.

    ls_raw_line = super_xstring+lv_offset(lv_len_tmp).

    APPEND ls_raw_line TO gt_raw_lines.

  ENDIF.

  CLEAR: super_string, super_xstring.

ENDFORM. " display_xml
