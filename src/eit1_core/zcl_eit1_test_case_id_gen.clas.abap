CLASS zcl_eit1_test_case_id_gen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES zif_eit1_number_generator.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_eit1_test_case_id_gen IMPLEMENTATION.
  METHOD zif_eit1_number_generator~get_next.
    DATA: lv_test_case_id TYPE zteit_test_cases-test_case_id.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'    " Number range number
        object                  = 'ZEITT'    " Name of number range object
*       quantity                = '1'    " Number of numbers
*       subobject               = SPACE    " Value of subobject
*       toyear                  = '0000'    " Value of To-fiscal year
*       ignore_buffer           = SPACE    " Ignore object buffering
      IMPORTING
        number                  = lv_test_case_id    " free number
*       quantity                =     " Number of numbers
*       returncode              =     " Return code
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
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_msg).
      zcx_eit1_exception=>raise_from_sy( ).

    ENDIF.

    rv_value = lv_test_case_id.
  ENDMETHOD.

ENDCLASS.
