CLASS zcl_eit2_testing_cockpit DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    DATA mv_dynnr_ui TYPE sydynnr READ-ONLY.
    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_eit2_testing_cockpit
                               RAISING   zcx_eit1_exception.
    METHODS constructor RAISING zcx_eit1_exception.
    METHODS handle_user_command
      IMPORTING
        !iv_fcode TYPE sy-ucomm
      RAISING
        zcx_eit1_exception.
    METHODS render_tests_grid.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA mo_instance TYPE REF TO zcl_eit2_testing_cockpit.
    DATA mo_container_tree TYPE REF TO cl_gui_docking_container .
    DATA mo_control_tree TYPE REF TO zcl_eit2_projects_tree.
    DATA mo_tests_grid TYPE REF TO zcl_eit2_test_cases_grid.
    METHODS init_ctrl_tree
      RAISING
        zcx_eit1_exception.
    METHODS on_tests_grid_user_command
          FOR EVENT user_command  OF zcl_eit2_test_cases_grid
      IMPORTING
          e_ucomm.
    METHODS on_control_tree_node_dbl_click
          FOR EVENT node_double_click OF zcl_eit2_projects_tree
      IMPORTING
          ev_project_id.
ENDCLASS.



CLASS zcl_eit2_testing_cockpit IMPLEMENTATION.


  METHOD constructor.
*    mv_dynnr_ui = c_dynnr-entry_screen. "'0201'
*    mv_repid_ui = c_repid-main_program.
    mv_dynnr_ui = '102'.
    init_ctrl_tree( ).
  ENDMETHOD.


  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.

    ro_instance = mo_instance.
  ENDMETHOD.


  METHOD handle_user_command.

    CASE iv_fcode.
      WHEN 'COMPARE_PAYLOADS'.
        mo_tests_grid->compare_payloads( ).
      WHEN 'SAVE_TESTS'.
        mo_tests_grid->save_tests( ).
      WHEN 'EXECUTE_TEST'.
        mo_tests_grid->execute_test( ).
        "mo_tests_grid->render( ).
      WHEN 'DOWNLOAD_PAYLOADS'.
        mo_tests_grid->download_payloads( ).
      WHEN 'CHECK'.
        zcl_eit1_logger=>get( )->fullscreen( ).
    ENDCASE.

  ENDMETHOD.


  METHOD init_ctrl_tree.
    DATA: lx_exc TYPE REF TO zcx_eit1_exception.

    lx_exc = NEW #( ).

    CREATE OBJECT mo_container_tree
      EXPORTING
        side                        = cl_gui_docking_container=>dock_at_left    " Side to Which Control is Docked
        extension                   = 300    " Control Extension
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      lx_exc->append_sy_message( ).
      RAISE EXCEPTION lx_exc.
    ENDIF.

    CREATE OBJECT mo_control_tree
      EXPORTING
        io_container = mo_container_tree.

    SET HANDLER on_control_tree_node_dbl_click FOR mo_control_tree.

  ENDMETHOD.


  METHOD on_control_tree_node_dbl_click.

    mv_dynnr_ui = '0201'.
    IF mo_tests_grid IS BOUND.
      mo_tests_grid->free( ).
    ENDIF.
    mo_tests_grid = NEW #( iv_project_id = ev_project_id ).

    SET HANDLER on_tests_grid_user_command FOR mo_tests_grid.
  ENDMETHOD.


  METHOD on_tests_grid_user_command.
    TRY.
        me->handle_user_command( iv_fcode = e_ucomm ).
      CATCH zcx_eit1_exception  INTO DATA(lx_error).
        lx_error->display_log(
*          EXPORTING
*            iv_object        = 'ZBC'    " Application Log: Object Name (Application Code)
*            iv_subobject     =     " Application Log: Subobject
*            iv_title         =     " Application Log: Screen title
*            iv_show_tree     =
*            iv_standard_disp =
*            iv_extnumber     =
        ).
    ENDTRY.

    mo_tests_grid->render( ).

  ENDMETHOD.


  METHOD render_tests_grid.
    mo_tests_grid->render( ).
  ENDMETHOD.
ENDCLASS.
