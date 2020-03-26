CLASS zcl_eit1_payload_repository DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_eit1_payload_repository.
    ALIASES get_payload_by_guid FOR zif_eit1_payload_repository~get_payload_by_guid.
    ALIASES insert_payload FOR zif_eit1_payload_repository~insert_payload.
    ALIASES delete_payload FOR zif_eit1_payload_repository~delete_payload.
    ALIASES update_payload FOR zif_eit1_payload_repository~update_payload.
    ALIASES save FOR zif_eit1_payload_repository~save.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_eit1_payload_repository IMPLEMENTATION.
  METHOD zif_eit1_payload_repository~get_payload_by_guid.
    DATA:       BEGIN OF ls_clustkey,
                  msgguid TYPE zde_eitt_msgguid,
                  pid     TYPE sxmspid,
                  vers    TYPE sxmslsqnbr,
                END OF ls_clustkey.
    DATA ls_message_clu TYPE zteit_msg_cluste.
    DATA lt_res           TYPE sxmsrest.
    DATA: ls_content TYPE zst_eit1_content .

    IF iv_guid IS INITIAL.
      ro_payload = NEW #(
      iv_guid = iv_guid
      is_content = ls_content ).
      RETURN.
    ENDIF.

    ls_clustkey-msgguid = iv_guid.
    ls_clustkey-pid = 'SENDER'.
    ls_clustkey-vers = '000'.

    IMPORT lt_res TO lt_res
        FROM DATABASE zteit_msg_cluste(is) TO ls_message_clu ID ls_clustkey.

    DATA(ls_res) = VALUE #( lt_res[ 1 ] OPTIONAL ).

    ls_content-content_id = ls_res-resname.
    ls_content-content = ls_res-rescontent.
    ls_content-content_type = ls_res-resattrib.

    ro_payload = NEW #(
    iv_guid = iv_guid
    is_content = ls_content ).

  ENDMETHOD.

  METHOD zif_eit1_payload_repository~insert_payload.

    DATA ls_message_clu TYPE zteit_msg_cluste.
    DATA lt_res           TYPE sxmsrest.
    DATA ls_res TYPE LINE OF sxmsrest.

    DATA:       BEGIN OF clustkey,
                  msgguid TYPE zde_eitt_msgguid,
                  pid     TYPE sxmspid,
                  vers    TYPE sxmslsqnbr,
                END OF clustkey.

    CHECK io_payload->mv_guid IS NOT INITIAL.

    clustkey-msgguid = io_payload->mv_guid.
    clustkey-pid = 'SENDER'.
    clustkey-vers = '000'.

    ls_res-linecount = '000001'.
    ls_res-resname = io_payload->ms_content-content_id.
    ls_res-rescontent = io_payload->ms_content-content.
    ls_res-resattrib = io_payload->ms_content-content_type.

    lt_res = VALUE #( ( ls_res ) ).

    EXPORT lt_res FROM lt_res
        TO DATABASE zteit_msg_cluste(is) FROM ls_message_clu ID clustkey.

  ENDMETHOD.

  METHOD zif_eit1_payload_repository~delete_payload.

  ENDMETHOD.

  METHOD zif_eit1_payload_repository~update_payload.
    DATA ls_message_clu TYPE zteit_msg_cluste.
    DATA lt_res           TYPE sxmsrest.
    DATA ls_res TYPE LINE OF sxmsrest.

    DATA:       BEGIN OF clustkey,
                  msgguid TYPE zde_eitt_msgguid,
                  pid     TYPE sxmspid,
                  vers    TYPE sxmslsqnbr,
                END OF clustkey.

    CHECK io_payload->mv_guid IS NOT INITIAL.

    clustkey-msgguid = io_payload->mv_guid.
    clustkey-pid = 'SENDER'.
    clustkey-vers = '000'.

    ls_res-linecount = '000001'.
    ls_res-resname = io_payload->ms_content-content_id.
    ls_res-rescontent = io_payload->ms_content-content.
    ls_res-resattrib = io_payload->ms_content-content_type.

    lt_res = VALUE #( ( ls_res ) ).

    EXPORT lt_res FROM lt_res
        TO DATABASE zteit_msg_cluste(is) FROM ls_message_clu ID clustkey.
  ENDMETHOD.

  METHOD zif_eit1_payload_repository~save.

  ENDMETHOD.

ENDCLASS.
