*"* use this source file for your ABAP unit test classes
CLASS lcl_db_mock_system DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_eit3_db_systems.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_db_mock_system IMPLEMENTATION.

  METHOD zif_eit3_db_systems~select_single_by_key.

    CASE iv_system_name.
      WHEN 'system1'.
        rs_system-system_name = iv_system_name.
        rs_system-amm_logical_port = 'log_port1'.
        rs_system-ico_rfc_dest = 'rfc_des1'.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

CLASS ltcl_conf_system DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      select_data_exists FOR TESTING RAISING cx_static_check,
      select_data_not_exists FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_conf_system IMPLEMENTATION.

  METHOD select_data_exists.
    DATA(lo_mock_system) = NEW lcl_db_mock_system( ).
    DATA(lo_cut) = NEW zcl_eit1_conf_system(
        iv_system_name     = 'system1'
        io_systems_db    = lo_mock_system
    ).
    cl_abap_unit_assert=>assert_not_initial( act = lo_cut->ms_system ).
    cl_abap_unit_assert=>assert_not_initial( act = lo_cut->ms_system-amm_logical_port ).
    cl_abap_unit_assert=>assert_not_initial( act = lo_cut->ms_system-ico_rfc_dest ).

  ENDMETHOD.

  METHOD select_data_not_exists.
    DATA(lo_mock_system) = NEW lcl_db_mock_system( ).

    TRY.
        DATA(lo_cut) = NEW zcl_eit1_conf_system(
            iv_system_name     = 'system_not_exists'
            io_systems_db    = lo_mock_system
        ).
        cl_abap_unit_assert=>fail(
            msg    =    'System not exists, so constructor should raise exception'
        ).
      CATCH zcx_eit1_exception INTO DATA(lx_exc).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
