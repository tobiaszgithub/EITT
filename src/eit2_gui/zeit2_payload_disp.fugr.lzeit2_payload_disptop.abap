FUNCTION-POOL ZEIT2_PAYLOAD_DISP.               "MESSAGE-ID ..

DATA gv_pri TYPE string.
DATA gv_sec TYPE string.
data gv_payload_guid type zde_eitt_msgguid.
* INCLUDE LZEIT2_XML_DIFFD...                " Local class definition
DATA go_xml_diff TYPE REF TO zcl_eit2_xml_diff.
data go_payload_disp type REF TO zcl_eit2_payload_disp.
