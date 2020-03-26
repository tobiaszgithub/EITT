*"* use this source file for your ABAP unit test classes
CLASS lcl_db_mock_interface DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_eit3_db_interfaces.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_db_mock_interface IMPLEMENTATION.

  METHOD zif_eit3_db_interfaces~select_single_by_key.

    CASE iv_system_name.
      WHEN 'system1'.
        rs_interface-system_name = iv_system_name.
        rs_interface-interface_name = iv_interface_name.
        rs_interface-sender_service = 'sender1'.
        rs_interface-interface_ext = iv_interface_name.
        rs_interface-interface_namespace = 'namespace1'.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_conf_interface DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      select_data_exists FOR TESTING RAISING cx_static_check,
      select_data_not_exists FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_conf_interface IMPLEMENTATION.

  METHOD select_data_exists.
    DATA(lo_mock_interface) = NEW lcl_db_mock_interface( ).
    DATA(lo_cut) = NEW zcl_eit1_conf_interface(
        iv_system_name     = 'system1'
        iv_interface_name  = 'interface1'
        io_interfaces_db    = lo_mock_interface
    ).
    cl_abap_unit_assert=>assert_not_initial( act = lo_cut->ms_interface ).
    cl_abap_unit_assert=>assert_not_initial( act = lo_cut->ms_interface-interface_namespace ).
    cl_abap_unit_assert=>assert_not_initial( act = lo_cut->ms_interface-interface_ext ).
    cl_abap_unit_assert=>assert_not_initial( act = lo_cut->ms_interface-sender_service ).

  ENDMETHOD.

  METHOD select_data_not_exists.
    DATA(lo_mock_interface) = NEW lcl_db_mock_interface( ).

    TRY.
        DATA(lo_cut) = NEW zcl_eit1_conf_interface(
            iv_system_name     = 'system_not_exists'
            iv_interface_name  = 'interface1'
            io_interfaces_db    = lo_mock_interface
        ).
        cl_abap_unit_assert=>fail(
            msg    =    'System not exists, so constructor should raise exception'
        ).
      CATCH zcx_eit1_exception INTO DATA(lx_exc).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
