CLASS zcl_eit1_conf_system DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: ms_system TYPE zteit_systems.
    METHODS constructor
      IMPORTING
                iv_system_name TYPE zteit_systems-system_name
                io_systems_db  TYPE REF TO zif_eit3_db_systems OPTIONAL
      RAISING   zcx_eit1_exception.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_system_name TYPE zteit_systems-system_name.
    DATA: mo_systems_db TYPE REF TO zif_eit3_db_systems.
ENDCLASS.



CLASS ZCL_EIT1_CONF_SYSTEM IMPLEMENTATION.


  METHOD constructor.

    me->mv_system_name = iv_system_name.
    me->mo_systems_db = io_systems_db.

    IF mo_systems_db IS NOT BOUND.
      mo_systems_db = NEW zcl_eit3_db_systems( ).
    ENDIF.

    ms_system = mo_systems_db->select_single_by_key( iv_system_name = mv_system_name ).

    IF sy-subrc <> 0 OR ms_system-ico_rfc_dest IS INITIAL
       OR ms_system-amm_logical_port IS INITIAL.
      MESSAGE e007(zeit1) WITH mv_system_name INTO DATA(lv_msg).
      zcx_eit1_exception=>raise_from_sy( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
