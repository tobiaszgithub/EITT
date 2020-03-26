INTERFACE zif_eit1_exit
  PUBLIC .
  METHODS get_ignore_expressions
    IMPORTING iv_interface          TYPE zteit_interfaces-interface_name
    RETURNING
              VALUE(rt_expressions) TYPE zcl_eit1_xml_ignore_elements=>tt_expression.

  METHODS get_replace_expressions
    IMPORTING iv_interface          TYPE zteit_interfaces-interface_name
    RETURNING
              VALUE(rt_expressions) TYPE zcl_eit1_xml_ignore_elements=>tt_expression.
ENDINTERFACE.
