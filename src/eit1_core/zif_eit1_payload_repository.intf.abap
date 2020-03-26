INTERFACE zif_eit1_payload_repository
  PUBLIC .
  METHODS: get_payload_by_guid
    IMPORTING iv_guid           TYPE zteit_msg_cluste-msgguid
    RETURNING VALUE(ro_payload) TYPE REF TO zcl_eit1_payload.

  METHODS: insert_payload
    IMPORTING io_payload TYPE REF TO zcl_eit1_payload.

  METHODS: delete_payload
    IMPORTING iv_guid TYPE zteit_msg_cluste-msgguid.

  METHODS: update_payload
    IMPORTING io_payload TYPE REF TO zcl_eit1_payload.

  METHODS: save.
ENDINTERFACE.
