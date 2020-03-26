INTERFACE ZIF_EIT3_DB_INTERFACES
  PUBLIC .
  METHODS select_single_by_key
    IMPORTING iv_system_name      TYPE zteit_interfaces-system_name
              iv_interface_name   TYPE zteit_interfaces-interface_name
    RETURNING VALUE(rs_interface) TYPE zteit_interfaces.
ENDINTERFACE.
