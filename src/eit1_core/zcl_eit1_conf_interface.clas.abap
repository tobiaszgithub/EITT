CLASS zcl_eit1_conf_interface DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: ms_interface TYPE zteit_interfaces READ-ONLY.
    METHODS constructor
      IMPORTING
                iv_system_name    TYPE zteit_interfaces-system_name
                iv_interface_name TYPE zteit_interfaces-interface_name
                io_interfaces_db  TYPE REF TO zif_eit3_db_interfaces OPTIONAL
      RAISING   zcx_eit1_exception.
    DATA: mo_interfaces_db TYPE REF TO zif_eit3_db_interfaces.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: mv_system_name TYPE zteit_systems-system_name.
    DATA: mv_interface_name TYPE zteit_interfaces-interface_name.


ENDCLASS.



CLASS zcl_eit1_conf_interface IMPLEMENTATION.


  METHOD constructor.

    me->mv_system_name = iv_system_name.
    me->mv_interface_name = iv_interface_name.
    me->mo_interfaces_db = io_interfaces_db.

    IF mo_interfaces_db IS NOT BOUND.
      mo_interfaces_db = NEW zcl_eit3_db_interfaces( ).
    ENDIF.

    ms_interface = mo_interfaces_db->select_single_by_key(
        iv_system_name    = mv_system_name
        iv_interface_name = mv_interface_name
    ).
*    SELECT SINGLE * INTO @ms_interface FROM zteit_interfaces
*        WHERE system_name = @mv_system_name
*        AND interface_name = @mv_interface_name.

    IF sy-subrc <> 0 OR ms_interface-sender_service IS INITIAL
        OR ms_interface-interface_ext IS INITIAL
        OR ms_interface-interface_namespace IS INITIAL.
      MESSAGE e005(zeit1) WITH mv_system_name mv_interface_name INTO DATA(lv_msg).
      zcx_eit1_exception=>raise_from_sy( ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
