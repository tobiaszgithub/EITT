
CLASS zcl_eit2_projects_tree DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF t_project_tree_key,
        project_id        TYPE zteit_projects-project_id,
        parent_project_id TYPE zteit_projects-parent_project_id,
      END OF t_project_tree_key .

    EVENTS node_double_click
      EXPORTING
        VALUE(ev_project_id) TYPE zteit_projects-project_id OPTIONAL.

    METHODS constructor
      IMPORTING
        !io_container TYPE REF TO cl_gui_container
      RAISING
        zcx_eit1_exception .
    METHODS free .
  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA go_simple_tree TYPE REF TO cl_simple_tree_model .

    METHODS create_root_node .
    METHODS create_stag_objects_and_subobj
      RAISING
        zcx_eit1_exception .
    METHODS create_functional_area_nodes
      RAISING
        zcx_eit1_exception .
    METHODS on_expand_no_children
          FOR EVENT expand_no_children OF cl_simple_tree_model
      IMPORTING
          !node_key .
    METHODS on_node_double_click
          FOR EVENT node_double_click OF cl_simple_tree_model
      IMPORTING
          !node_key .
ENDCLASS.



CLASS zcl_eit2_projects_tree IMPLEMENTATION.


  METHOD constructor.
    DATA lt_events TYPE cntl_simple_events.
    DATA ls_events TYPE cntl_simple_event.
    DATA: lx_exc TYPE REF TO zcx_eit1_exception.
    lx_exc = NEW #( ).


    CREATE OBJECT go_simple_tree
      EXPORTING
        node_selection_mode         = cl_simple_tree_model=>node_sel_mode_single   " Nodes: Single or Multiple Selection
*       HIDE_SELECTION              =     " Visibility of Selection
      EXCEPTIONS
        illegal_node_selection_mode = 1
        OTHERS                      = 2.
    IF sy-subrc <> 0.

      lx_exc->append_sy_message( ).
      RAISE EXCEPTION lx_exc.

    ENDIF.

    ls_events-eventid = cl_simple_tree_model=>eventid_node_double_click.
    ls_events-appl_event = abap_true.
    INSERT ls_events INTO TABLE lt_events.



    go_simple_tree->set_registered_events(
      EXPORTING
        events                    =   lt_events
      EXCEPTIONS
        illegal_event_combination = 1
        unknown_event             = 2
        OTHERS                    = 3
    ).
    IF sy-subrc <> 0.
      lx_exc->append_sy_message( ).
      RAISE EXCEPTION lx_exc.
    ENDIF.

    SET HANDLER me->on_node_double_click FOR go_simple_tree.

    go_simple_tree->create_tree_control(
      EXPORTING
*      LIFETIME                     =     " "
        parent                       =  io_container
*      SHELLSTYLE                   =     " "
*    importing
*      CONTROL                      =     " "
      EXCEPTIONS
        lifetime_error               = 1
        cntl_system_error            = 2
        create_error                 = 3
        failed                       = 4
        tree_control_already_created = 5
        OTHERS                       = 6
    ).
    IF sy-subrc <> 0.
      lx_exc->append_sy_message( ).
      RAISE EXCEPTION lx_exc.
    ENDIF.

    me->create_root_node( ).
    me->create_functional_area_nodes( ).
    me->create_stag_objects_and_subobj( ).
*

    SET HANDLER me->on_expand_no_children FOR go_simple_tree.

  ENDMETHOD.


  METHOD create_functional_area_nodes.
    DATA: lt_projects TYPE STANDARD TABLE OF zteit_projects,
          lx_exc      TYPE REF TO zcx_eit1_exception.

    lx_exc = NEW #( ).
    FIELD-SYMBOLS: <ls_funct_area> TYPE zteit_projects.

    SELECT * FROM zteit_projects
        INTO TABLE @lt_projects
        WHERE parent_project_id = ''.

    LOOP AT lt_projects ASSIGNING <ls_funct_area>.
      go_simple_tree->add_node(
        EXPORTING
          node_key                =  CONV #( <ls_funct_area>-project_id )   " Node key
*            relative_node_key       =     " Key of Related Node
*            relationship            =     " Relationship
          isfolder                =  'X'   " 'X': Node is Folder; ' ': Node is Leaf
          text                    =  CONV #( <ls_funct_area>-project_id )   " Node text
*            hidden                  =     " 'X': Node is Invisible
*            disabled                =     " 'X': Node Cannot be Selected
*            style                   =     " See Method Documentation
*            no_branch               =     " 'X': Do Not Draw Hierarchy Lines
*            expander                =     " See Method Documentation
*            image                   =     " See Method Documentation
*            expanded_image          =     " See Method Documentation
*            drag_drop_id            =     " See Method Documentation
*            user_object             =     " User Object
        EXCEPTIONS
          node_key_exists         = 1
          illegal_relationship    = 2
          relative_node_not_found = 3
          node_key_empty          = 4
          OTHERS                  = 5
      ).
      IF sy-subrc <> 0.
        lx_exc->append_sy_message( ).
        RAISE EXCEPTION lx_exc.
      ENDIF.



    ENDLOOP.


  ENDMETHOD.


  METHOD create_root_node.

  ENDMETHOD.


  METHOD create_stag_objects_and_subobj.


    DATA: lt_projects TYPE STANDARD TABLE OF zteit_projects,

          lx_exc      TYPE REF TO zcx_eit1_exception.
    DATA: ls_node_key        TYPE t_project_tree_key,
          ls_parent_node_key TYPE t_project_tree_key,
          lt_subprojects     TYPE STANDARD TABLE OF zteit_projects,
          ls_header_project  TYPE zteit_projects.

    DATA: ls_parent_project TYPE zteit_projects,
          ls_subproject     TYPE zteit_projects.

    lx_exc = NEW #( ).

    FIELD-SYMBOLS: <ls_project> LIKE LINE OF lt_projects.

    SELECT * FROM zteit_projects
        INTO TABLE @lt_projects
        WHERE parent_project_id = ''.

    SELECT * FROM zteit_projects
        INTO TABLE @lt_subprojects
        WHERE parent_project_id <> ''.

    LOOP AT lt_projects ASSIGNING <ls_project>.

      ls_parent_project = <ls_project>.
      DO.

        ls_subproject = VALUE #( lt_subprojects[ parent_project_id = ls_parent_project-project_id ] OPTIONAL ).
        IF ls_subproject IS INITIAL.
          EXIT.
        ENDIF.

        go_simple_tree->add_node(
          EXPORTING
            node_key                = CONV #( ls_subproject-project_id )    " Node key
            relative_node_key       = CONV #( ls_subproject-parent_project_id )    " Key of Related Node
            relationship            = cl_simple_tree_model=>relat_last_child    " Relationship
            isfolder                = '' "'X'    " 'X': Node is Folder; ' ': Node is Leaf
            text                    = |{ ls_subproject-project_id }|    " Node text
*            hidden                  =     " 'X': Node is Invisible
*            disabled                =     " 'X': Node Cannot be Selected
*            style                   =     " See Method Documentation
*            no_branch               =     " 'X': Do Not Draw Hierarchy Lines
             expander                = 'X'    " See Method Documentation
             image                   = '@FO@' "'@7C@'    " See Method Documentation
             expanded_image          = '@FO@'    " See Method Documentation
*            drag_drop_id            =     " See Method Documentation
*            user_object             =     " User Object
          EXCEPTIONS
            node_key_exists         = 1
            illegal_relationship    = 2
            relative_node_not_found = 3
            node_key_empty          = 4
            OTHERS                  = 5
        ).
        IF sy-subrc <> 0.
          lx_exc->append_sy_message( ).
          RAISE EXCEPTION lx_exc.
        ENDIF.

        DELETE lt_subprojects WHERE project_id = ls_subproject-project_id.
        APPEND ls_subproject TO lt_projects.
      ENDDO.

    ENDLOOP.


*    LOOP AT lt_staging_sub ASSIGNING <ls_staging_sub> WHERE header_data <> 'X'.
*
*      ls_node_key-staging_obj = <ls_staging_sub>-staging_obj.
*      ls_node_key-staging_sub = <ls_staging_sub>-staging_subobj.
*
*      ls_parent_node_key-staging_obj = <ls_staging_sub>-staging_obj.
*      ls_parent_node_key-staging_sub = <ls_staging_sub>-parent_subobject.
*      go_simple_tree->add_node(
*        EXPORTING
*          node_key                =  CONV #( ls_node_key )   " Node key
*          relative_node_key       =  CONV #( ls_parent_node_key )  " Key of Related Node
*          relationship            =  cl_simple_tree_model=>relat_last_child   " Relationship
*          isfolder                = 'X'    " 'X': Node is Folder; ' ': Node is Leaf
*          text                    =  |{ <ls_staging_sub>-staging_subobj } - { <ls_staging_sub>-description }|   " Node text
**          hidden                  =     " 'X': Node is Invisible
**          disabled                =     " 'X': Node Cannot be Selected
**          style                   =     " See Method Documentation
**          no_branch               =     " 'X': Do Not Draw Hierarchy Lines
**          expander                =     " See Method Documentation
*          image                   = '@HP@'    " See Method Documentation
*          expanded_image          = '@HP@'   " See Method Documentation
**          drag_drop_id            =     " See Method Documentation
**          user_object             =     " User Object
*        EXCEPTIONS
*          node_key_exists         = 1
*          illegal_relationship    = 2
*          relative_node_not_found = 3
*          node_key_empty          = 4
*          OTHERS                  = 5
*      ).
*      IF sy-subrc <> 0.
*
*      ENDIF.
*    ENDLOOP.

    SELECT * FROM zteit_projects
        INTO TABLE @lt_projects.

    LOOP AT lt_projects ASSIGNING <ls_project>.
      go_simple_tree->expand_node(
        EXPORTING
          node_key            =  CONV #( <ls_project>-project_id )    " Node key
*          expand_predecessors =     " 'X': Expand Predecessor of Node
*          expand_subtree      =     " 'X': Expand all Subsequent Nodes
*          level_count         =     " Number of Lower Levels to be Expanded
        EXCEPTIONS
          node_not_found      = 1
          OTHERS              = 2
      ).
      IF sy-subrc <> 0.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD free.

  ENDMETHOD.


  METHOD on_expand_no_children.

  ENDMETHOD.


  METHOD on_node_double_click.

    DATA: ls_tree_key TYPE t_project_tree_key.

    ls_tree_key = node_key.

    RAISE EVENT node_double_click
      EXPORTING
        ev_project_id = ls_tree_key-project_id
    .
  ENDMETHOD.
ENDCLASS.
