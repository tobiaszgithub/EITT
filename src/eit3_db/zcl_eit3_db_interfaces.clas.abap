CLASS ZCL_EIT3_DB_INTERFACES DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_eit3_db_interfaces.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EIT3_DB_INTERFACES IMPLEMENTATION.
  METHOD zif_eit3_db_interfaces~select_single_by_key.
    SELECT SINGLE * INTO @rs_interface FROM zteit_interfaces
        WHERE system_name = @iv_system_name
        AND interface_name = @iv_interface_name.
  ENDMETHOD.

ENDCLASS.
