CLASS zcl_eit1_xml_ignore_conf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        iv_interface TYPE zteit_interfaces-interface_name.
    METHODS get_expressions
      RETURNING
        VALUE(rt_expressions) TYPE zcl_eit1_xml_ignore_elements=>tt_expression.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_interface TYPE zde_eitt_interface_name.
ENDCLASS.



CLASS zcl_eit1_xml_ignore_conf IMPLEMENTATION.


  METHOD constructor.

    me->mv_interface = iv_interface.

  ENDMETHOD.

  METHOD get_expressions.
*    IF mv_interface EQ 'InvoiceHeader_Out'.
*      rt_expressions = VALUE #(
*             ( expression = '/ns1:BAPI_ACC_INVOICE_RECEIPT_POST/DOCUMENTHEADER/PSTNG_DATE'
*               ns_decls = 'ns1 urn:sap-com:document:sap:rfc:functions' )
*             ( expression = '/n0:BAPI_ACC_INVOICE_RECEIPT_POST.Response/OBJ_KEY'
*               ns_decls = 'n0 urn:sap-com:document:sap:rfc:functions' )

*                ) .
*    ENDIF.

    DATA: li_exit TYPE REF TO zif_eit1_exit.

    li_exit = zcl_eit1_exit=>get_instance( ).
    rt_expressions = li_exit->get_ignore_expressions( iv_interface = mv_interface ).
  ENDMETHOD.

ENDCLASS.
