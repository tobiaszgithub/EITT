*&---------------------------------------------------------------------*
*& Report  zeit8_test_01_cluster_tab
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_test_01_cluster_tab.

DATA: ls_message_clu TYPE zteit_msg_cluste.

DATA:       BEGIN OF clustkey,
              msgguid TYPE sxmsqid,
              pid     TYPE sxmspid,
              vers    TYPE sxmslsqnbr,
            END OF clustkey.
DATA: lt_xres          TYPE sxmsxrest.
DATA ls_xres TYPE sxmsxress.

clustkey-msgguid = cl_system_uuid=>create_uuid_c32_static( ).
clustkey-pid = 'SENDER'.
clustkey-vers = '000'.

ls_xres-linecount = '000001'.
ls_xres-resname = 'cid:payload-adafad234234@sap.com'.
ls_xres-rescontent = '0123456789abcdef'.
ls_xres-resattrib = 'mimetype=text/xml;charset=utf-8'.

APPEND ls_xres TO lt_xres.

EXPORT lt_xres FROM lt_xres
    TO DATABASE zteit_msg_cluste(is) FROM ls_message_clu ID clustkey.
