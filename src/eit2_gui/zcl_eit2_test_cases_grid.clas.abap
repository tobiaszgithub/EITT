CLASS zcl_eit2_test_cases_grid DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    EVENTS user_command
       EXPORTING
         VALUE(e_ucomm) TYPE sy-ucomm OPTIONAL .
    EVENTS hotspot_click
      EXPORTING
        VALUE(e_row_id) TYPE lvc_s_row OPTIONAL
        VALUE(e_column_id) TYPE lvc_s_col OPTIONAL
        VALUE(es_row_no) TYPE lvc_s_roid OPTIONAL .

    METHODS render.
    METHODS compare_payloads RAISING zcx_eit1_exception.
    METHODS save_tests.
    METHODS execute_test RAISING zcx_eit1_exception.
    METHODS constructor IMPORTING iv_project_id TYPE zteit_test_cases-project_id.
    METHODS download_payloads
      RAISING zcx_eit1_exception.
    METHODS free.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF t_outtab.
            INCLUDE TYPE zst_eit2_test_cases_grid.
    TYPES: celltab TYPE lvc_t_styl.
    TYPES: END OF t_outtab.
    TYPES: tt_outtab TYPE STANDARD TABLE OF t_outtab.
    DATA mv_project_id TYPE zteit_test_cases-project_id.
    DATA mo_container TYPE REF TO cl_gui_custom_container .
    DATA mo_grid  TYPE REF TO cl_gui_alv_grid.
    DATA: mt_outtab     TYPE tt_outtab,
          deleted_rows  TYPE tt_outtab,
          inserted_rows TYPE tt_outtab,
          modified_rows TYPE tt_outtab.
    METHODS get_fieldcatalog
      RETURNING
        VALUE(rt_fcat) TYPE lvc_t_fcat.
    METHODS select_data
      CHANGING
        ct_data TYPE tt_outtab.
    METHODS fill_celltab
      IMPORTING
        iv_mode    TYPE string
      CHANGING
        ct_celltab TYPE lvc_t_styl.
    METHODS update_database.
    METHODS update_delta_tables
      IMPORTING
        io_data_changed TYPE REF TO cl_alv_changed_data_protocol.
    METHODS prepare_icon_column
      CHANGING
        ct_outtab TYPE tt_outtab.
    METHODS handle_toolbar
          FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
          !e_object
          !e_interactive .

    METHODS handle_toolbar_ucomm
          FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
          !e_ucomm .
    CONSTANTS mc_container_name TYPE scrfname VALUE 'CC_TESTS_GRID' .

    METHODS:
      handle_data_changed
                    FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed.

    METHODS handle_hotspot_click
          FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING
          !es_row_no
          !e_row_id
          !e_column_id .

    METHODS icon_create
      IMPORTING
        !iv_name       TYPE string
        !iv_info       TYPE string
      RETURNING
        VALUE(rv_icon) TYPE zde_eitt_test_status_icon .

    METHODS handle_f4 FOR EVENT onf4 OF cl_gui_alv_grid
      IMPORTING e_fieldname
                  es_row_no
                  er_event_data.
ENDCLASS.



CLASS zcl_eit2_test_cases_grid IMPLEMENTATION.


  METHOD compare_payloads.
    DATA: lt_index_rows TYPE lvc_t_row,
          lt_row_no     TYPE lvc_t_roid.

    mo_grid->get_selected_rows(
      IMPORTING
        et_index_rows = lt_index_rows    " Indexes of Selected Rows
        et_row_no     = lt_row_no    " Numeric IDs of Selected Rows
    ).
    CHECK lt_row_no IS NOT INITIAL.
    DATA(ls_outtab) = mt_outtab[ lt_row_no[ 1 ]-row_id ].


    DATA: lo_payload_repository TYPE REF TO zcl_eit1_payload_repository.
    lo_payload_repository = NEW #( ).

    DATA(lo_payload_pri) = lo_payload_repository->get_payload_by_guid(
                    iv_guid = ls_outtab-payload_msgguid_am_exp ).

    DATA(lo_payload_sec) = lo_payload_repository->get_payload_by_guid(
                    iv_guid = ls_outtab-payload_msgguid_am_act ).
    DATA(lv_xml1) = lo_payload_pri->zif_eit1_content~get_content( ).
    DATA(lv_xml2) = lo_payload_sec->zif_eit1_content~get_content( ).

    lv_xml1 = NEW zcl_eit1_xml_pretty_printer(
                                iv_xml = lv_xml1 )->pprint( ).
    lv_xml2 = NEW zcl_eit1_xml_pretty_printer(
                                iv_xml = lv_xml2 )->pprint( ).

    CALL FUNCTION 'ZEIT2_XML_DIFF'
      EXPORTING
        iv_pri = lv_xml1    " primary xml
        iv_sec = lv_xml2.     " secondary xml
  ENDMETHOD.


  METHOD constructor.
    mv_project_id = iv_project_id.
  ENDMETHOD.


  METHOD download_payloads.
    save_tests( ).

    DATA: lt_index_rows TYPE lvc_t_row,
          lt_row_no     TYPE lvc_t_roid.
    DATA lo_test_case_rep TYPE REF TO zcl_eit1_test_case_repository.
    FIELD-SYMBOLS: <ls_outtab> TYPE zcl_eit2_test_cases_grid=>t_outtab.
    mo_grid->get_selected_rows(
      IMPORTING
        et_index_rows = lt_index_rows    " Indexes of Selected Rows
        et_row_no     = lt_row_no    " Numeric IDs of Selected Rows
    ).
    CHECK lt_row_no IS NOT INITIAL.
    lo_test_case_rep = NEW #( ).

    LOOP AT lt_row_no INTO DATA(ls_current_row).
      DATA(lo_test_case) = lo_test_case_rep->get_test_case_by_id(
                            iv_id = mt_outtab[ ls_current_row-row_id ]-test_case_id ).
      TRY.
          lo_test_case->download_payloads( ).

        CATCH zcx_eit1_exception  INTO DATA(lx_exc).
          lo_test_case->set_status( iv_status = zcl_eit1_test_case=>c_status-failure ).
      ENDTRY.
      lo_test_case_rep->update_test_case( io_test_case = lo_test_case ).

      ASSIGN mt_outtab[ ls_current_row-row_id ] TO <ls_outtab>.
      MOVE-CORRESPONDING lo_test_case->ms_test_case TO <ls_outtab>.
    ENDLOOP.
    IF lx_exc IS BOUND.
      RAISE EXCEPTION lx_exc.
    ENDIF.

  ENDMETHOD.


  METHOD execute_test.
    DATA: lt_index_rows TYPE lvc_t_row,
          lt_row_no     TYPE lvc_t_roid.
    DATA lo_test_case_rep TYPE REF TO zcl_eit1_test_case_repository.
    FIELD-SYMBOLS: <ls_outtab> TYPE zcl_eit2_test_cases_grid=>t_outtab.

    DATA(lo_log) = zcl_eit1_logger=>get( ).

    mo_grid->get_selected_rows(
      IMPORTING
        et_index_rows = lt_index_rows    " Indexes of Selected Rows
        et_row_no     = lt_row_no    " Numeric IDs of Selected Rows
    ).
    CHECK lt_row_no IS NOT INITIAL.
    lo_test_case_rep = NEW #( ).

    LOOP AT lt_row_no INTO DATA(ls_current_row).
      DATA(lo_test_case) = lo_test_case_rep->get_test_case_by_id(
                            iv_id = mt_outtab[ ls_current_row-row_id ]-test_case_id ).

      TRY.
          lo_test_case->execute( ).

        CATCH zcx_eit1_exception  INTO DATA(lx_exc).
          lo_test_case->set_status( iv_status = zcl_eit1_test_case=>c_status-failure ).
          lo_log->add( lx_exc->get_messages( ) ).
      ENDTRY.
      lo_test_case_rep->update_test_case( io_test_case = lo_test_case ).

      ASSIGN mt_outtab[ ls_current_row-row_id ] TO <ls_outtab>.
      MOVE-CORRESPONDING lo_test_case->ms_test_case TO <ls_outtab>.
    ENDLOOP.
*    IF lx_exc IS BOUND.
*      RAISE EXCEPTION lx_exc.
*    ENDIF.
  ENDMETHOD.


  METHOD fill_celltab.
    DATA: ls_celltab TYPE lvc_s_styl,
          l_mode     TYPE raw4.
* This forms sets the style of columns 'PRICE', FLDATE and PLANETYPE
* editable

    IF iv_mode EQ 'RW'.
      l_mode = cl_gui_alv_grid=>mc_style_enabled.
    ELSE.                                "p_mode eq 'RO'
      l_mode = cl_gui_alv_grid=>mc_style_disabled.
    ENDIF.

    ls_celltab-fieldname = 'payload_msgguid_am_exp'.
    ls_celltab-style = l_mode.
    INSERT ls_celltab INTO TABLE ct_celltab.
    ls_celltab-fieldname = 'PRICE'.
    ls_celltab-style = l_mode.
    INSERT ls_celltab INTO TABLE ct_celltab.
    ls_celltab-fieldname = 'PLANETYPE'.
    ls_celltab-style = l_mode.
    INSERT ls_celltab INTO TABLE ct_celltab.
  ENDMETHOD.


  METHOD free.

    IF mo_grid IS BOUND.
      mo_grid->free(
          EXCEPTIONS
*            cntl_error        = 1
*            cntl_system_error = 2
            OTHERS            = 3
      ).
      IF sy-subrc <> 0.
*         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      CLEAR mo_grid.
    ENDIF.
    IF mo_container IS BOUND.

      mo_container->free(
          EXCEPTIONS
*            cntl_error        = 1
*            cntl_system_error = 2
            OTHERS            = 3
      ).
      IF sy-subrc <> 0.
*         MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      CLEAR mo_container.
    ENDIF.


  ENDMETHOD.


  METHOD get_fieldcatalog.
    DATA: lt_fcat TYPE lvc_t_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
*       i_buffer_active        =     " Buffer active
        i_structure_name       = 'ZST_EIT2_TEST_CASES_GRID' "'ZTBC_EXAMPL_HEAD'    " Structure name (structure, table, view)
      CHANGING
        ct_fieldcat            = lt_fcat   " Field Catalog with Field Descriptions
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
    ENDIF.

    LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<ls_fcat>).
      <ls_fcat>-col_opt = 'X'.
    ENDLOOP.


    LOOP AT lt_fcat ASSIGNING <ls_fcat>.
      IF    <ls_fcat>-fieldname EQ 'PI_MSGGUID'
             OR <ls_fcat>-fieldname EQ 'PAYLOAD_MSGGUID_BM'
             OR <ls_fcat>-fieldname EQ 'PAYLOAD_MSGGUID_AM_EXP'
             OR <ls_fcat>-fieldname EQ 'PAYLOAD_MSGGUID_AM_ACT'
             OR <ls_fcat>-fieldname EQ 'PAYLOAD_MSGGUID_SYN_RESP_EXP'
             OR <ls_fcat>-fieldname EQ 'PAYLOAD_MSGGUID_SYN_RESP_ACT'
             OR <ls_fcat>-fieldname EQ 'DESCRIPTION'.

* §1.Set status of columns FLDATA, PRICE and PLANETYPE to editable.
*    Since all cells are set to non-editable (see step 3) the cells
*    of this columns will only be editable for new lines.

        <ls_fcat>-edit = 'X'.

* Field 'checktable' is set to avoid shortdumps that are caused
* by inconsistend data in check tables. You may comment this out
* when the test data of the flight model is consistent in your system.
        <ls_fcat>-checktable = '!'.        "do not check foreign keys

        "MODIFY pt_fieldcat FROM ls_fcat.
      ELSEIF
         <ls_fcat>-fieldname = 'SENDER_SERVICE'
         OR <ls_fcat>-fieldname = 'INTERFACE'
         OR <ls_fcat>-fieldname = 'INTERFACE_NAMESPACE'
          OR <ls_fcat>-fieldname = 'RFCDEST'
          OR <ls_fcat>-fieldname = 'SYSTEM_NAME'
          OR <ls_fcat>-fieldname = 'TEST_TYPE'
          OR <ls_fcat>-fieldname = 'LOGICAL_PORT_NAME'
          OR <ls_fcat>-fieldname = 'PROJECT_ID'
          OR <ls_fcat>-fieldname = 'INTERFACE_NAME'.

* §2.Use field AUTO_VALUE of the fieldcatalog to preset values when new
*    lines are added.

        <ls_fcat>-auto_value = 'X'.
        <ls_fcat>-checktable = '!'.   "do not check foreign key relations

        <ls_fcat>-edit = 'X'.
        "  MODIFY pt_fieldcat FROM ls_fcat.
      ENDIF.

      IF <ls_fcat>-fieldname = 'PAYLOAD_MSGGUID_BM_ICON'
        OR <ls_fcat>-fieldname = 'PAYLOAD_MSGGUID_AM_EXP_ICON'
        OR <ls_fcat>-fieldname = 'PAYLOAD_MSGGUID_AM_ACT_ICON'.
        <ls_fcat>-hotspot = 'X'.
      ENDIF.

      IF <ls_fcat>-fieldname = 'TEST_STATUS'.
        <ls_fcat>-tech = 'X'.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_fcat ASSIGNING <ls_fcat>.
      IF    <ls_fcat>-fieldname EQ 'PI_MSGGUID'.
        <ls_fcat>-f4availabl = 'X'.
      ENDIF.
    ENDLOOP.


    rt_fcat = lt_fcat.
  ENDMETHOD.


  METHOD handle_data_changed.

* remember new or deleted lines for saving
    update_delta_tables( er_data_changed ).

  ENDMETHOD.


  METHOD handle_f4.

    DATA ls_filter TYPE zst_eit1_amm_msg_list_filter.
    DATA  ls_selected_msg  TYPE zst_eit1_msg_list_result.
    DATA  lt_selected_msgs  TYPE ztt_eit1_amm_msg_list_result.

    FIELD-SYMBOLS <lt_modi> TYPE lvc_t_modi.
    DATA: ls_modi TYPE lvc_s_modi.

    DATA(ls_test_case) = mt_outtab[ es_row_no-row_id ].
    TRY.
        DATA(lo_interface) = NEW zcl_eit1_conf_interface(
            iv_system_name     = ls_test_case-system_name
            iv_interface_name  = ls_test_case-interface_name
        ).
      CATCH zcx_eit1_exception INTO DATA(lx_exc) .
        DATA(lo_logger) = zcl_eit1_logger=>get( ).
        lo_logger->add( lx_exc->get_messages( ) ).
        lo_logger->popup( ).
        RETURN.
    ENDTRY.
*      CATCH zcx_eit1_exception.  "
    ls_filter-from_date = sy-datum.
    ls_filter-from_time = '000000'.
    ls_filter-to_date = sy-datum.
    ls_filter-to_time = '235959'.
    ls_filter-interface_name = ''. "lo_interface->ms_interface-interface_ext.
    ls_filter-interface_namespace = ''. "lo_interface->ms_interface-interface_namespace.
    ls_filter-sender_name = lo_interface->ms_interface-sender_service.

    CALL FUNCTION 'ZEIT2_MESSAGE_SELECTOR'
      EXPORTING
        iv_system_name   = ls_test_case-system_name
        is_filter        = ls_filter
      IMPORTING
        es_selected_msg  = ls_selected_msg
        et_selected_msgs = lt_selected_msgs.

    er_event_data->m_event_handled = 'X'.
    ASSIGN er_event_data->m_data->* TO <lt_modi>.

    IF ls_selected_msg IS NOT INITIAL.
      mt_outtab[ es_row_no-row_id ]-pi_msgguid = ls_selected_msg-message_id.

      ls_modi-row_id = es_row_no-row_id.
      ls_modi-fieldname = e_fieldname.
      ls_modi-value = ls_selected_msg-message_id.
      APPEND ls_modi TO <lt_modi>.
    ENDIF.

    IF lt_selected_msgs IS NOT INITIAL.
      DATA: ls_outtab LIKE LINE OF mt_outtab.
      DATA: ls_new_test_case TYPE zteit_test_cases.
      DATA: lo_repo TYPE REF TO zcl_eit1_test_case_repository.
      lo_repo = NEW #( ).

      LOOP AT lt_selected_msgs INTO DATA(ls_msg).
        ls_new_test_case-description = ls_test_case-description.
        ls_new_test_case-test_type = ls_test_case-test_type.
        ls_new_test_case-system_name = ls_test_case-system_name.
        ls_new_test_case-interface_name = ls_test_case-interface_name.
        ls_new_test_case-pi_msgguid = ls_msg-message_id.

        DATA(lo_new_test_case) = NEW zcl_eit1_test_case(
            is_test_case       = ls_new_test_case
        ).

        lo_repo->insert_test_case( io_test_case = lo_new_test_case ).

        APPEND INITIAL LINE TO mt_outtab ASSIGNING FIELD-SYMBOL(<ls_outtab>).
        ls_modi-row_id = sy-tabix.
        ls_modi-fieldname = 'TEST_CASE_ID'.
        ls_modi-value = lo_new_test_case->ms_test_case-test_case_id.
        APPEND ls_modi TO <lt_modi>.
        MOVE-CORRESPONDING lo_new_test_case->ms_test_case TO <ls_outtab>.


      ENDLOOP.
    ENDIF.


    IF lt_selected_msgs IS NOT INITIAL.

    ENDIF.
    "CALL METHOD cl_gui_cfw=>flush.
    "me->render( ).
  ENDMETHOD.


  METHOD handle_hotspot_click.
    RAISE EVENT hotspot_click
      EXPORTING
        e_row_id    = e_row_id
        e_column_id = e_column_id
        es_row_no   = es_row_no.

    DATA(ls_outtab) = mt_outtab[ e_row_id-index ].

    DATA(lo_payload_rep) = NEW zcl_eit1_payload_repository( ).

    CASE e_column_id.
      WHEN 'PAYLOAD_MSGGUID_BM_ICON'.
        DATA(lv_payload_guid) = ls_outtab-payload_msgguid_bm.
      WHEN 'PAYLOAD_MSGGUID_AM_EXP_ICON'.
        lv_payload_guid = ls_outtab-payload_msgguid_am_exp.
      WHEN 'PAYLOAD_MSGGUID_AM_ACT_ICON'.
        lv_payload_guid = ls_outtab-payload_msgguid_am_act.
    ENDCASE.

    DATA(lo_payload) = lo_payload_rep->get_payload_by_guid( iv_guid = lv_payload_guid ).

    CALL FUNCTION 'ZEIT2_PAYLOAD_DISP'
      EXPORTING
        iv_pri          = lo_payload->zif_eit1_content~get_content( )    " primary xml
        iv_sec          = ''    " secondary xml
        iv_payload_guid = lv_payload_guid.
  ENDMETHOD.


  METHOD handle_toolbar.
    DATA: ls_toolbar TYPE stb_button,
          lv_index   TYPE i VALUE 1.

*    ls_toolbar = VALUE #( function = 'CANCEL_DATA' icon = icon_cancel
*                          quickinfo = 'Cancel test'(005) text = 'Cancel test'(006)
*                          disabled = ' '  ).
*    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
*    lv_index = lv_index + 1.

    ls_toolbar = VALUE #( function = 'SAVE_TESTS' icon = icon_system_save
                          quickinfo = 'Save tests'(008) text = 'Save tests'(008)
                          disabled = ' '  ).
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
    lv_index = lv_index + 1.

    ls_toolbar = VALUE #( function = 'DOWNLOAD_PAYLOADS' icon = icon_get_area
                          quickinfo = 'Download Payloads'(009) text = 'Download Payloads'(009)
                          disabled = ' '  ).
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
    lv_index = lv_index + 1.

    ls_toolbar = VALUE #( function = 'EXECUTE_TEST' icon = icon_execute_object
                          quickinfo = 'Execute test'(003) text = 'Execute test'(004)
                          disabled = ' '  ).
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
    lv_index = lv_index + 1.

    ls_toolbar = VALUE #( function = 'COMPARE_PAYLOADS' icon = icon_check
                          quickinfo = 'Compare payloads'(001) text = 'Compare payloads'(002)
                          disabled = ' '  ).
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
    lv_index = lv_index + 1.

    ls_toolbar = VALUE #( butn_type = 3  ).
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
    lv_index = lv_index + 1.

    ls_toolbar = VALUE #( function = 'REFRESH' icon = icon_refresh
                          quickinfo = 'Refresh'(007) text = ''
                          disabled = ' '  ).
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
    lv_index = lv_index + 1.

    ls_toolbar = VALUE #( butn_type = 3  ).
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
    lv_index = lv_index + 1.

  ENDMETHOD.


  METHOD handle_toolbar_ucomm.
    RAISE EVENT user_command EXPORTING e_ucomm = e_ucomm.
  ENDMETHOD.


  METHOD icon_create.
    CALL FUNCTION 'ICON_CREATE'
      EXPORTING
        name   = iv_name    " Icon name  (Name from INCLUDE <ICON> )
*       text   = iv_text    " Icon text (shown behind)
        info   = iv_info "SPACE    " Quickinfo (if SPACE: standard quickinfo)
*       add_stdinf            = 'X'    " 'X': Qinfo.   ' ': No Qinfo, no std. Qinfo
      IMPORTING
        result = rv_icon    " Icon (enter the screen field here)
      EXCEPTIONS
*       icon_not_found        = 1
*       outputfield_too_short = 2
        OTHERS = 3.
    IF sy-subrc <> 0.
* MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD prepare_icon_column.

    DATA(lv_icon_success) = me->icon_create(
                                  iv_name = 'ICON_LED_GREEN'
                                  iv_info = CONV #( 'Success' ) ) .
    DATA(lv_icon_failure) =   me->icon_create(
                              iv_name = 'ICON_LED_RED'
                              iv_info = CONV #( 'Failure' ) ) .
    DATA(lv_icon_not_processed) = me->icon_create(
                              iv_name = 'ICON_NO_STATUS'
                              iv_info = CONV #( 'Not processed' ) ) .
    DATA(lv_icon_warning) =   me->icon_create(
                              iv_name = 'ICON_LED_YELLOW'
                              iv_info = CONV #( 'Warning' ) ) .

    LOOP AT ct_outtab ASSIGNING FIELD-SYMBOL(<ls_outtab>).
      CASE <ls_outtab>-test_status.
        WHEN '1'.
          <ls_outtab>-test_status_icon = lv_icon_success.
        WHEN '2'.
          <ls_outtab>-test_status_icon = lv_icon_failure.
        WHEN '4'.
          <ls_outtab>-test_status_icon = lv_icon_warning.
        WHEN OTHERS.
          <ls_outtab>-test_status_icon = lv_icon_not_processed.
      ENDCASE.
    ENDLOOP.

    LOOP AT ct_outtab ASSIGNING <ls_outtab>.
      <ls_outtab>-payload_msgguid_bm_icon = me->icon_create(
                                iv_name = 'ICON_WD_TEXT_EDIT'
                                iv_info = CONV #( 'Payload BM' ) ) .

      <ls_outtab>-payload_msgguid_am_exp_icon = me->icon_create(
                                iv_name = 'ICON_WD_TEXT_EDIT'
                                iv_info = CONV #( 'Payload AM expected' ) ) .

      <ls_outtab>-payload_msgguid_am_act_icon = me->icon_create(
                                iv_name = 'ICON_WD_TEXT_EDIT'
                                iv_info = CONV #( 'Payload AM actual' ) ) .

    ENDLOOP.

  ENDMETHOD.


  METHOD render.
    DATA: ls_variant           TYPE disvariant,
          ls_save              TYPE char01,
          ls_layout            TYPE lvc_s_layo,
          changing             TYPE ui_functions,
          lt_toolbar_excluding TYPE ui_functions,
          lt_fieldcatalog      TYPE lvc_t_fcat.
    IF mo_container IS NOT BOUND.
      mo_container = NEW #( container_name = mc_container_name ).
    ENDIF.

    IF mo_grid IS BOUND.
      prepare_icon_column( CHANGING ct_outtab = mt_outtab ).
      mo_grid->refresh_table_display(
*        EXPORTING
*          is_stable      =     " With Stable Rows/Columns
*          i_soft_refresh =     " Without Sort, Filter, etc.
*        EXCEPTIONS
*          finished       = 1
*          others         = 2
      ).
      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      "BCALV_EDIT_04
      mo_grid = NEW #( i_parent = mo_container ).

      SET HANDLER handle_data_changed FOR mo_grid.

      select_data( CHANGING ct_data = mt_outtab ).

      prepare_icon_column( CHANGING ct_outtab = mt_outtab ).

      lt_fieldcatalog = get_fieldcatalog( ).

      ls_layout-stylefname = 'CELLTAB'.



      ls_layout-sel_mode = 'A'.
      ls_layout-col_opt = 'X'.

      DATA lt_f4 TYPE lvc_t_f4.
      DATA ls_f4 TYPE lvc_s_f4.

      ls_f4-fieldname = 'PI_MSGGUID'.
      ls_f4-register = 'X'.
      ls_f4-getbefore = 'X'.
      APPEND ls_f4 TO lt_f4.
      mo_grid->register_f4_for_fields( it_f4 = lt_f4 ).

      mo_grid->set_table_for_first_display(
        EXPORTING
*          i_buffer_active               =     " Buffering Active
*          i_bypassing_buffer            =     " Switch Off Buffer
*          i_consistency_check           =     " Starting Consistency Check for Interface Error Recognition
*          i_structure_name              =     " Internal Output Table Structure Name
          is_variant                    = ls_variant    " Layout
          i_save                        = ls_save    " Save Layout
*          i_default                     = 'X'    " Default Display Variant
          is_layout                     = ls_layout    " Layout
*          is_print                      =     " Print Control
*          it_special_groups             =     " Field Groups
          it_toolbar_excluding          = lt_toolbar_excluding    " Excluded Toolbar Standard Functions
*          it_hyperlink                  =     " Hyperlinks
*          it_alv_graphics               =     " Table of Structure DTC_S_TC
*          it_except_qinfo               =     " Table for Exception Quickinfo
*          ir_salv_adapter               =     " Interface ALV Adapter
        CHANGING
          it_outtab                     = mt_outtab    " Output Table
          it_fieldcatalog               = lt_fieldcatalog    " Field Catalog
*          it_sort                       =     " Sort Criteria
*          it_filter                     =     " Filter Criteria
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4
      ).
      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

* set editable cells to ready for input initially
      CALL METHOD mo_grid->set_ready_for_input
        EXPORTING
          i_ready_for_input = 1.


      SET HANDLER me->handle_toolbar FOR mo_grid.
      SET HANDLER me->handle_toolbar_ucomm FOR mo_grid.
      SET HANDLER me->handle_hotspot_click FOR mo_grid.
      SET HANDLER me->handle_f4 FOR mo_grid.
* § 4.Call method 'set_toolbar_interactive' to raise event TOOLBAR.
      CALL METHOD mo_grid->set_toolbar_interactive.

      mo_grid->register_edit_event(
        EXPORTING
          i_event_id =  cl_gui_alv_grid=>mc_evt_enter   " Event ID
*        EXCEPTIONS
*          error      = 1
*          others     = 2
      ).
      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      mo_grid->register_edit_event(
        EXPORTING
          i_event_id =  cl_gui_alv_grid=>mc_evt_modified   " Event ID
*        EXCEPTIONS
*          error      = 1
*          others     = 2
      ).
      IF sy-subrc <> 0.
*       MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD save_tests.
    DATA: l_valid TYPE c.
* §7.Check if any errors exist in protocol by using method
*    CHECK_CHANGED_DATA of your ALV Grid instance.

* The method CHECK_CHANGED_DATA checks all new cells syntactically,
* raises event DATA_CHANGED and looks then for any entries
* in the error protocol. If any exist the parameter e_valid
* is initial ('X' in the other case).
*
    CALL METHOD mo_grid->check_changed_data
      IMPORTING
        e_valid = l_valid.

    IF l_valid IS INITIAL.
      CALL FUNCTION 'POPUP_TO_INFORM'
        EXPORTING
          titel = text-i06
          txt1  = text-i07
          txt2  = text-i08
          txt3  = text-i09.

    ELSE.
      update_database( ).
      MESSAGE s000(0k) WITH text-s01.
    ENDIF.
  ENDMETHOD.


  METHOD select_data.
    DATA: ls_test_case TYPE zteit_test_cases.
    DATA lt_celltab TYPE lvc_t_styl.
    DATA: lt_projects               TYPE STANDARD TABLE OF zteit_projects,
          lt_projects_for_selection TYPE STANDARD TABLE OF zteit_projects,
          ls_project                TYPE zteit_projects,
          ls_subproject             TYPE zteit_projects.

    SELECT SINGLE * FROM zteit_projects
        INTO @ls_project
        WHERE project_id = @mv_project_id.

    APPEND ls_project TO lt_projects_for_selection.

    SELECT * FROM zteit_projects
        INTO TABLE @lt_projects.

    LOOP AT lt_projects_for_selection INTO ls_project.
      DO.
        ls_subproject = VALUE #( lt_projects[ parent_project_id = ls_project-project_id ] OPTIONAL ).
        IF ls_subproject IS INITIAL.
          EXIT.
        ENDIF.

        DELETE lt_projects WHERE project_id = ls_subproject-project_id.
        APPEND ls_subproject TO lt_projects_for_selection.
      ENDDO.
    ENDLOOP.

    DATA: lr_project_id TYPE RANGE OF zteit_projects-project_id.

    lr_project_id = VALUE #( FOR ls_value IN lt_projects_for_selection
                                ( sign = 'I'
                                  option = 'EQ'
                                  low = ls_value-project_id ) ).

    SELECT * FROM zteit_test_cases INTO TABLE @DATA(lt_test_cases)
        WHERE project_id IN @lr_project_id.

    MOVE-CORRESPONDING lt_test_cases TO mt_outtab.

    LOOP AT mt_outtab ASSIGNING FIELD-SYMBOL(<ls_outtab>).
      DATA(lv_index) = sy-tabix.
      CLEAR lt_celltab.
      fill_celltab( EXPORTING iv_mode = 'RO'
                    CHANGING ct_celltab = lt_celltab ).
      INSERT LINES OF lt_celltab INTO TABLE <ls_outtab>-celltab.
    ENDLOOP.

  ENDMETHOD.


  METHOD update_database.
    DATA ls_outtab  LIKE LINE OF mt_outtab.
    DATA ls_test_case TYPE zteit_test_cases.
    DATA: lt_del_test_cases TYPE STANDARD TABLE OF zteit_test_cases.
    DATA: lt_ins_test_cases TYPE STANDARD TABLE OF zteit_test_cases.
    DATA: lt_upd_test_cases TYPE STANDARD TABLE OF zteit_test_cases.

    LOOP AT deleted_rows INTO ls_outtab.
      MOVE-CORRESPONDING ls_outtab TO ls_test_case.
      APPEND ls_test_case TO lt_del_test_cases.
    ENDLOOP.

    IF lt_del_test_cases IS NOT INITIAL.
      DELETE  zteit_test_cases FROM TABLE lt_del_test_cases.
    ENDIF.

    LOOP AT inserted_rows INTO ls_outtab.
      READ TABLE mt_outtab WITH KEY test_case_id = ls_outtab-test_case_id
        INTO ls_outtab.
      MOVE-CORRESPONDING ls_outtab TO ls_test_case.
      APPEND ls_test_case TO lt_ins_test_cases.
    ENDLOOP.

    IF lt_ins_test_cases IS NOT INITIAL.
      INSERT zteit_test_cases FROM TABLE lt_ins_test_cases.
    ENDIF.

    LOOP AT modified_rows INTO ls_outtab.
      MOVE-CORRESPONDING mt_outtab[ test_case_id = ls_outtab-test_case_id ] TO ls_test_case.
      APPEND ls_test_case TO lt_upd_test_cases.
    ENDLOOP.

    IF lt_upd_test_cases IS NOT INITIAL.
      MODIFY zteit_test_cases FROM TABLE lt_upd_test_cases.
    ENDIF.

    CLEAR deleted_rows.
    CLEAR inserted_rows.
    CLEAR modified_rows.

  ENDMETHOD.


  METHOD update_delta_tables.
    DATA: ls_ins_row TYPE lvc_s_moce,
          ls_del_row TYPE lvc_s_moce,
          ls_outtab  LIKE LINE OF mt_outtab.

    DATA: lv_test_case_id TYPE zteit_test_cases-test_case_id.

    LOOP AT io_data_changed->mt_deleted_rows INTO ls_del_row.
      READ TABLE mt_outtab INTO ls_outtab INDEX ls_del_row-row_id.

      APPEND ls_outtab TO deleted_rows.

* If this line was inserted just before it is deleted:
      DELETE me->inserted_rows
           WHERE test_case_id = ls_outtab-test_case_id.
    ENDLOOP.

    LOOP AT io_data_changed->mt_inserted_rows INTO ls_ins_row.
      io_data_changed->get_cell_value(
        EXPORTING
          i_row_id    = ls_ins_row-row_id    " Row ID
*          i_tabix     =     " Table Index
          i_fieldname =  'TEST_CASE_ID'   " Field Name
        IMPORTING
          e_value     =  lv_test_case_id   " Cell Content
      ).

      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = '01'    " Number range number
          object                  = 'ZEITT'    " Name of number range object
*         quantity                = '1'    " Number of numbers
*         subobject               = SPACE    " Value of subobject
*         toyear                  = '0000'    " Value of To-fiscal year
*         ignore_buffer           = SPACE    " Ignore object buffering
        IMPORTING
          number                  = lv_test_case_id    " free number
*         quantity                =     " Number of numbers
*         returncode              =     " Return code
        EXCEPTIONS
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          buffer_overflow         = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      io_data_changed->modify_cell(
        EXPORTING
          i_row_id    = ls_ins_row-row_id    " Row ID
*          i_tabix     =     " Row Index
          i_fieldname =  'TEST_CASE_ID'   " Field Name
          i_value     =  lv_test_case_id   " Value
      ).
      DATA: lv_test_case_id2 TYPE zteit_test_cases-test_case_id,
            ls_good_cell     LIKE LINE OF io_data_changed->mt_good_cells.
      io_data_changed->get_cell_value(
        EXPORTING
          i_row_id    = ls_ins_row-row_id    " Row ID
*          i_tabix     =     " Table Index
          i_fieldname =  'TEST_CASE_ID'   " Field Name
        IMPORTING
          e_value     = lv_test_case_id2   " Cell Content
      ).

      "READ TABLE mt_outtab INTO ls_outtab INDEX ls_ins_row-row_id.
      ls_outtab-test_case_id = lv_test_case_id.

      APPEND ls_outtab TO inserted_rows.

    ENDLOOP.

    LOOP AT io_data_changed->mt_good_cells INTO ls_good_cell.
      IF line_exists( mt_outtab[ ls_good_cell-row_id ] ).
        ls_outtab = mt_outtab[ ls_good_cell-row_id ].
      ELSE.
        CONTINUE.
      ENDIF.

      IF NOT line_exists( modified_rows[ test_case_id = ls_outtab-test_case_id ] ).
        APPEND ls_outtab TO modified_rows.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
