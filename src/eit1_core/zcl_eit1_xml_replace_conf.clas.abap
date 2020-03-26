CLASS zcl_eit1_xml_replace_conf DEFINITION
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
    DATA: mv_interface TYPE zde_eitt_interface_name .
ENDCLASS.



CLASS zcl_eit1_xml_replace_conf IMPLEMENTATION.


  METHOD constructor.

    me->mv_interface = iv_interface.

  ENDMETHOD.

  METHOD get_expressions.
*    IF mv_interface EQ InvoiceHeader_Out'.
*      rt_expressions = VALUE #(
*             ( expression = '/ns0:invoice-header/ns0:invoice-number'
*               ns_decls = 'ns0 urn:example.com:ExtSys:Invoice' )
*
*                ) .
*    ENDIF.
    DATA: li_exit TYPE REF TO zif_eit1_exit.

    li_exit = zcl_eit1_exit=>get_instance( ).
    rt_expressions = li_exit->get_replace_expressions( iv_interface = mv_interface ).
  ENDMETHOD.

ENDCLASS.
