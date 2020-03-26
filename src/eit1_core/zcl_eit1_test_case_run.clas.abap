CLASS ZCL_EIT1_TEST_CASE_RUN DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        io_act TYPE REF TO zif_eit1_content
        io_exp TYPE REF TO zif_eit1_content.
    METHODS execute
      RETURNING
        VALUE(rv_is_successful) TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mo_act TYPE REF TO zif_eit1_content.
    DATA mo_exp TYPE REF TO zif_eit1_content.
    DATA mo_texts_diff TYPE REF TO zif_eit1_texts_diff.
ENDCLASS.



CLASS ZCL_EIT1_TEST_CASE_RUN IMPLEMENTATION.

  METHOD constructor.

    me->mo_act = io_act.
    me->mo_exp = io_exp.
    "mo_texts_diff = NEW zcl_eit1_texts_diff( ).
  ENDMETHOD.

  METHOD execute.
    DATA(lv_act_content) = mo_act->get_content( ).
    DATA(lv_exp_content) = mo_exp->get_content( ).

    IF lv_act_content EQ lv_exp_content.
      rv_is_successful = abap_true.
    ENDIF.

*    DATA(lt_comparison_result) = mo_texts_diff->compare(
*      EXPORTING
*        iv_pri              = lv_act_content
*        iv_sec              = lv_exp_content ).
  ENDMETHOD.

ENDCLASS.
