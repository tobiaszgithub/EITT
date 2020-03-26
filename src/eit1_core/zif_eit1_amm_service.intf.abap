INTERFACE zif_eit1_amm_service
  PUBLIC .

  METHODS: get_payload_by_msg_id
    IMPORTING
      iv_message_id         TYPE string
      iv_version            TYPE string
    RETURNING
      VALUE(rs_msg_payload) TYPE zst_eit1_content
    RAISING
      zcx_eit1_exception .

  METHODS: get_payload_by_ref_id
    IMPORTING
      iv_reference_id       TYPE string
      iv_version            TYPE string
    RETURNING
      VALUE(rs_msg_payload) TYPE zst_eit1_content
    RAISING
      zcx_eit1_exception .
  METHODS: get_message_list
    IMPORTING
              is_filter        TYPE zst_eit1_amm_msg_list_filter
    RETURNING VALUE(rt_result) TYPE ztt_eit1_amm_msg_list_result.

ENDINTERFACE.
