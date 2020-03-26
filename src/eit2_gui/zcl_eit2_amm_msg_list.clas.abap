CLASS zcl_eit2_amm_msg_list DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: ms_selected_msg  TYPE zst_eit1_msg_list_result,
          mt_selected_msgs TYPE ztt_eit1_amm_msg_list_result.
    METHODS constructor
      IMPORTING
        iv_system_name TYPE zde_eitt_system_name
        is_filter      TYPE zst_eit1_amm_msg_list_filter.

    METHODS show_dialog_screen.
    METHODS free.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA ms_filter TYPE zst_eit1_amm_msg_list_filter.
    DATA mv_system_name TYPE zde_eitt_system_name.
    DATA mo_container  TYPE REF TO cl_gui_custom_container.
    DATA mo_grid  TYPE REF TO cl_gui_alv_grid.
    DATA: mt_outtab        TYPE ztt_eit1_amm_msg_list_result.
    METHODS get_fieldcatalog
      RETURNING
        VALUE(rt_fcat) TYPE lvc_t_fcat.
    METHODS handle_toolbar_ucomm
          FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
          !e_ucomm .
    METHODS handle_toolbar
          FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
          !e_object
          !e_interactive .
ENDCLASS.



CLASS zcl_eit2_amm_msg_list IMPLEMENTATION.


  METHOD constructor.

    me->mv_system_name = iv_system_name.
    me->ms_filter = is_filter.

  ENDMETHOD.


  METHOD show_dialog_screen.

    DATA lo_amm TYPE REF TO zcl_eit1_amm_service.

    DATA lo_system TYPE REF TO zcl_eit1_conf_system.

    lo_system = NEW zcl_eit1_conf_system( iv_system_name = mv_system_name ).

    lo_amm = NEW zcl_eit1_amm_service( iv_log_port_name = lo_system->ms_system-amm_logical_port ).

    mt_outtab = lo_amm->zif_eit1_amm_service~get_message_list( is_filter = ms_filter ).


    DATA  lt_fieldcatalog  TYPE lvc_t_fcat.
    DATA ls_layout  TYPE lvc_s_layo  .
    DATA: ls_variant           TYPE disvariant.
    IF mo_container IS NOT BOUND.
      mo_container = NEW
        cl_gui_custom_container( container_name = 'CUSTOM_CONTAINER' ).
    ENDIF.

    IF mo_grid IS BOUND.
      mo_grid->refresh_table_display( ).
    ELSE.
      mo_grid = NEW #( i_parent = mo_container ).

      lt_fieldcatalog = get_fieldcatalog( ).
      ls_layout-sel_mode = 'A'.
      ls_layout-col_opt = 'X'.

      mo_grid->set_table_for_first_display(
        EXPORTING
*          i_buffer_active               =     " Buffering Active
*          i_bypassing_buffer            =     " Switch Off Buffer
*          i_consistency_check           =     " Starting Consistency Check for Interface Error Recognition
*          i_structure_name              =     " Internal Output Table Structure Name
          is_variant                    = ls_variant    " Layout
     "     i_save                        = ls_save    " Save Layout
*          i_default                     = 'X'    " Default Display Variant
          is_layout                     = ls_layout    " Layout
*          is_print                      =     " Print Control
*          it_special_groups             =     " Field Groups
"          it_toolbar_excluding          = lt_toolbar_excluding    " Excluded Toolbar Standard Functions
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

      SET HANDLER me->handle_toolbar FOR mo_grid.
      SET HANDLER me->handle_toolbar_ucomm FOR mo_grid.

      CALL METHOD mo_grid->set_toolbar_interactive.
    ENDIF.

*    "temporart solution
*    DATA: o_alv TYPE REF TO cl_salv_table.
*    DATA: lx_msg TYPE REF TO cx_salv_msg.
*    TRY.
*        cl_salv_table=>factory(
*          IMPORTING
*            r_salv_table = o_alv
*          CHANGING
*            t_table      = mt_outtab ).
*      CATCH cx_salv_msg INTO lx_msg.
*    ENDTRY.
*
*    o_alv->display( ).

  ENDMETHOD.

  METHOD get_fieldcatalog.
    DATA: lt_fcat TYPE lvc_t_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
*       i_buffer_active        =     " Buffer active
        i_structure_name       = 'ZST_EIT1_MSG_LIST_RESULT' "'ZTBC_EXAMPL_HEAD'    " Structure name (structure, table, view)
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

    rt_fcat = lt_fcat.
  ENDMETHOD.


  METHOD handle_toolbar.
    DATA: ls_toolbar TYPE stb_button,
          lv_index   TYPE i VALUE 1.

*    ls_toolbar = VALUE #( function = 'CANCEL_DATA' icon = icon_cancel
*                          quickinfo = 'Cancel test'(005) text = 'Cancel test'(006)
*                          disabled = ' '  ).
*    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
*    lv_index = lv_index + 1.

    ls_toolbar = VALUE #( function = 'SELECT_MSG' icon = icon_system_save
                          quickinfo = 'Select message'(001) text = 'Select message'(001)
                          disabled = ' '  ).
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
    lv_index = lv_index + 1.

    ls_toolbar = VALUE #( function = 'TRANSFER_AS_TESTS' icon = icon_get_area
                          quickinfo = 'Transfer msg as test'(002) text = 'Transfer msg as test'(002)
                          disabled = ' '  ).
    INSERT ls_toolbar INTO e_object->mt_toolbar INDEX lv_index.
    lv_index = lv_index + 1.

  ENDMETHOD.


  METHOD handle_toolbar_ucomm.
    DATA: lt_index_rows TYPE lvc_t_row,
          lt_row_no     TYPE lvc_t_roid.
    DATA lt_msg  TYPE ztt_eit1_amm_msg_list_result.
    mo_grid->get_selected_rows(
      IMPORTING
        et_index_rows = lt_index_rows    " Indexes of Selected Rows
        et_row_no     = lt_row_no    " Numeric IDs of Selected Rows
    ).

    LOOP AT lt_row_no INTO DATA(ls_row).
      DATA(ls_msg) = mt_outtab[ ls_row-row_id ].
      APPEND ls_msg TO lt_msg.
    ENDLOOP.

    CASE e_ucomm.
      WHEN 'SELECT_MSG'.
        ms_selected_msg = lt_msg[ 1 ].
      WHEN 'TRANSFER_AS_TESTS'.
        mt_selected_msgs = lt_msg.
    ENDCASE.

    cl_gui_cfw=>set_new_ok_code(
      EXPORTING
        new_code = 'ENTER'    " New OK_CODE
*      IMPORTING
*        rc       =     " Return code
    ).

    CALL METHOD cl_gui_cfw=>flush
*      EXCEPTIONS
*        cntl_system_error = 1
*        cntl_error        = 2
*        others            = 3
      .
    IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
*      IMPORTING
*        return_code =     " Return Code
    .


  ENDMETHOD.

  METHOD free.
    IF mo_grid IS BOUND.
      mo_grid->free(
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3
  ).
      IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.

    IF mo_container IS BOUND.
      mo_container->free(
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3
  ).
      IF sy-subrc <> 0.
*     MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.



  ENDMETHOD.

ENDCLASS.
