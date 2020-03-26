*&---------------------------------------------------------------------*
*& Report  zeit8_05_logger_example
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zeit8_05_logger_example.

DATA: lo_log TYPE REF TO zif_logger.

lo_log = zcl_logger_factory=>create_log(
             object    = 'ZEITT'
             subobject = 'EXECUTION'
             desc      = 'Easy Interface Testing Tool'
*             context   =
*             settings  =
         ).

lo_log->e( 'You see, what had happened was...' )->e( 'Bad things happened: See details' )->e( 'error' ).

lo_log->i( 'Info' ).

lo_log->fullscreen( ).

DATA: lo_log2 TYPE REF TO zif_logger.

lo_log2 =     zcl_logger_factory=>open_log(
       EXPORTING
         object                   = 'ZEITT'
         subobject                = 'EXECUTION'
         create_if_does_not_exist = abap_true
     ).

lo_log2->s( 'success message' ).

lo_log2->popup( ).
