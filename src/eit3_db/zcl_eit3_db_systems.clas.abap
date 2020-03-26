CLASS zcl_eit3_db_systems DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_eit3_db_systems.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_eit3_db_systems IMPLEMENTATION.
  METHOD zif_eit3_db_systems~select_single_by_key.
    SELECT SINGLE * INTO @rs_system FROM zteit_systems
        WHERE system_name = @iv_system_name.
  ENDMETHOD.

ENDCLASS.
