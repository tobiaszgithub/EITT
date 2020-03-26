INTERFACE zif_eit1_number_generator
  PUBLIC .
  METHODS get_next RETURNING VALUE(rv_value) TYPE i
                   RAISING   zcx_eit1_exception.
ENDINTERFACE.
