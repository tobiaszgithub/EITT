INTERFACE zif_eit3_db_systems
  PUBLIC .
  METHODS select_single_by_key
    IMPORTING iv_system_name   TYPE zteit_systems-system_name
    RETURNING VALUE(rs_system) TYPE zteit_systems.
ENDINTERFACE.
