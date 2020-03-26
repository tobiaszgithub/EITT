INTERFACE zif_eit1_texts_diff
  PUBLIC .
  TYPES: BEGIN OF t_vxabapstring,
           vrsflag TYPE sychar04,
           number  TYPE dbglinno,
           line    TYPE string,
         END OF t_vxabapstring.
  TYPES tt_vxabapstring TYPE STANDARD TABLE OF t_vxabapstring WITH EMPTY KEY.
  METHODS: compare
    IMPORTING iv_pri                     TYPE string
              iv_sec                     TYPE string
    RETURNING VALUE(rt_abapstring_delta) TYPE tt_vxabapstring.

ENDINTERFACE.
