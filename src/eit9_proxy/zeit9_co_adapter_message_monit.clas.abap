class ZEIT9_CO_ADAPTER_MESSAGE_MONIT definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods RESEND_MESSAGES
    importing
      !INPUT type ZEIT9_RESEND_MESSAGES_IN_DOC
    exporting
      !OUTPUT type ZEIT9_RESEND_MESSAGES_OUT_DOC
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_RESEND_MESSAGES_COM_S
      ZEIT9_CX_RESEND_MESSAGES_COM_1 .
  methods GET_USER_DEFINED_SEARCH_MESSAG
    importing
      !INPUT type ZEIT9_GET_USER_DEFINED_SEARCH1
    exporting
      !OUTPUT type ZEIT9_GET_USER_DEFINED_SEARCH
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_USER_DEFINED_SEAR .
  methods GET_USER_DEFINED_SEARCH_FILTER
    importing
      !INPUT type ZEIT9_GET_USER_DEFINED_SEARCH3
    exporting
      !OUTPUT type ZEIT9_GET_USER_DEFINED_SEARCH2
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_USER_DEFINED_SEA1 .
  methods GET_USER_DEFINED_SEARCH_EXTRAC
    importing
      !INPUT type ZEIT9_GET_USER_DEFINED_SEARCH5
    exporting
      !OUTPUT type ZEIT9_GET_USER_DEFINED_SEARCH4
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_USER_DEFINED_SEA2 .
  methods GET_USER_DEFINED_SEARCH_ATTRIB
    importing
      !INPUT type ZEIT9_GET_USER_DEFINED_SEARCH7
    exporting
      !OUTPUT type ZEIT9_GET_USER_DEFINED_SEARCH6
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_USER_DEFINED_SEA3
      ZEIT9_CX_GET_USER_DEFINED_SEA4 .
  methods GET_STATUS_DETAILS
    importing
      !INPUT type ZEIT9_GET_STATUS_DETAILS_IN_DO
    exporting
      !OUTPUT type ZEIT9_GET_STATUS_DETAILS_OUT_D
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_STATUS_DETAILS_CO .
  methods GET_SERVICES
    importing
      !INPUT type ZEIT9_GET_SERVICES_IN_DOC
    exporting
      !OUTPUT type ZEIT9_GET_SERVICES_OUT_DOC
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_SERVICES_COM_SAP .
  methods GET_PREDECESSOR_MESSAGE_ID
    importing
      !INPUT type ZEIT9_GET_PREDECESSOR_MESSAGE1
    exporting
      !OUTPUT type ZEIT9_GET_PREDECESSOR_MESSAGE
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_PREDECESSOR_MESSA .
  methods GET_PARTIES
    importing
      !INPUT type ZEIT9_GET_PARTIES_IN_DOC
    exporting
      !OUTPUT type ZEIT9_GET_PARTIES_OUT_DOC
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_PARTIES_COM_SAP_A .
  methods GET_MESSAGE_LIST
    importing
      !INPUT type ZEIT9_GET_MESSAGE_LIST_IN_DOC
    exporting
      !OUTPUT type ZEIT9_GET_MESSAGE_LIST_OUT_DOC
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_MESSAGE_LIST_COM .
  methods GET_MESSAGE_BYTES_JAVA_LANG_ST
    importing
      !INPUT type ZEIT9_GET_MESSAGE_BYTES_JAVA_1
    exporting
      !OUTPUT type ZEIT9_GET_MESSAGE_BYTES_JAVA_L
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_MESSAGE_BYTES_JAV
      ZEIT9_CX_GET_MESSAGE_BYTES_JA1 .
  methods GET_MESSAGE_BYTES_JAVA_LANG_S1
    importing
      !INPUT type ZEIT9_GET_MESSAGE_BYTES_JAVA_3
    exporting
      !OUTPUT type ZEIT9_GET_MESSAGE_BYTES_JAVA_2
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_MESSAGE_BYTES_JA2
      ZEIT9_CX_GET_MESSAGE_BYTES_JA3 .
  methods GET_MESSAGES_WITH_SUCCESSORS
    importing
      !INPUT type ZEIT9_GET_MESSAGES_WITH_SUCCE1
    exporting
      !OUTPUT type ZEIT9_GET_MESSAGES_WITH_SUCCES
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_MESSAGES_WITH_SUC .
  methods GET_MESSAGES_BY_KEYS
    importing
      !INPUT type ZEIT9_GET_MESSAGES_BY_KEYS_IN
    exporting
      !OUTPUT type ZEIT9_GET_MESSAGES_BY_KEYS_OUT
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_MESSAGES_BY_KEYS .
  methods GET_MESSAGES_BY_IDS
    importing
      !INPUT type ZEIT9_GET_MESSAGES_BY_IDS_IN_D
    exporting
      !OUTPUT type ZEIT9_GET_MESSAGES_BY_IDS_OUT
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_MESSAGES_BY_IDS_C .
  methods GET_LOG_ENTRIES
    importing
      !INPUT type ZEIT9_GET_LOG_ENTRIES_IN_DOC
    exporting
      !OUTPUT type ZEIT9_GET_LOG_ENTRIES_OUT_DOC
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_LOG_ENTRIES_COM_S
      ZEIT9_CX_GET_LOG_ENTRIES_COM_1 .
  methods GET_LOGGED_MESSAGE_BYTES
    importing
      !INPUT type ZEIT9_GET_LOGGED_MESSAGE_BYTE1
    exporting
      !OUTPUT type ZEIT9_GET_LOGGED_MESSAGE_BYTES
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_LOGGED_MESSAGE_BY
      ZEIT9_CX_GET_LOGGED_MESSAGE_B1 .
  methods GET_INTERFACES
    importing
      !INPUT type ZEIT9_GET_INTERFACES_IN_DOC
    exporting
      !OUTPUT type ZEIT9_GET_INTERFACES_OUT_DOC
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_INTERFACES_COM_SA .
  methods GET_INTEGRATION_FLOWS
    importing
      !INPUT type ZEIT9_GET_INTEGRATION_FLOWS_IN
    exporting
      !OUTPUT type ZEIT9_GET_INTEGRATION_FLOWS_OU
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_INTEGRATION_FLOWS .
  methods GET_ERROR_CODES
    importing
      !INPUT type ZEIT9_GET_ERROR_CODES_IN_DOC
    exporting
      !OUTPUT type ZEIT9_GET_ERROR_CODES_OUT_DOC
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_ERROR_CODES_COM_S .
  methods GET_CONNECTIONS
    importing
      !INPUT type ZEIT9_GET_CONNECTIONS_IN_DOC
    exporting
      !OUTPUT type ZEIT9_GET_CONNECTIONS_OUT_DOC
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_CONNECTIONS_COM_S .
  methods GET_ALL_AVAILABLE_STATUS_DETAI
    importing
      !INPUT type ZEIT9_GET_ALL_AVAILABLE_STATU1
    exporting
      !OUTPUT type ZEIT9_GET_ALL_AVAILABLE_STATUS
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_GET_ALL_AVAILABLE_STA .
  methods FAIL_EOIO_MESSAGE
    importing
      !INPUT type ZEIT9_FAIL_EOIO_MESSAGE_IN_DOC
    exporting
      !OUTPUT type ZEIT9_FAIL_EOIO_MESSAGE_OUT_DO
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_FAIL_EOIO_MESSAGE_COM .
  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods CANCEL_MESSAGES
    importing
      !INPUT type ZEIT9_CANCEL_MESSAGES_IN_DOC
    exporting
      !OUTPUT type ZEIT9_CANCEL_MESSAGES_OUT_DOC
    raising
      CX_AI_SYSTEM_FAULT
      ZEIT9_CX_CANCEL_MESSAGES_COM_S
      ZEIT9_CX_CANCEL_MESSAGES_COM_1 .
protected section.
private section.
ENDCLASS.



CLASS ZEIT9_CO_ADAPTER_MESSAGE_MONIT IMPLEMENTATION.


  method CANCEL_MESSAGES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'CANCEL_MESSAGES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZEIT9_CO_ADAPTER_MESSAGE_MONIT'
    logical_port_name   = logical_port_name
  ).

  endmethod.


  method FAIL_EOIO_MESSAGE.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'FAIL_EOIO_MESSAGE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_ALL_AVAILABLE_STATUS_DETAI.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_ALL_AVAILABLE_STATUS_DETAI'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_CONNECTIONS.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_CONNECTIONS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_ERROR_CODES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_ERROR_CODES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_INTEGRATION_FLOWS.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_INTEGRATION_FLOWS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_INTERFACES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_INTERFACES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_LOGGED_MESSAGE_BYTES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_LOGGED_MESSAGE_BYTES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_LOG_ENTRIES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_LOG_ENTRIES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_MESSAGES_BY_IDS.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_MESSAGES_BY_IDS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_MESSAGES_BY_KEYS.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_MESSAGES_BY_KEYS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_MESSAGES_WITH_SUCCESSORS.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_MESSAGES_WITH_SUCCESSORS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_MESSAGE_BYTES_JAVA_LANG_S1.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_MESSAGE_BYTES_JAVA_LANG_S1'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_MESSAGE_BYTES_JAVA_LANG_ST.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_MESSAGE_BYTES_JAVA_LANG_ST'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_MESSAGE_LIST.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_MESSAGE_LIST'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_PARTIES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_PARTIES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_PREDECESSOR_MESSAGE_ID.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_PREDECESSOR_MESSAGE_ID'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_SERVICES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_SERVICES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_STATUS_DETAILS.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_STATUS_DETAILS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_USER_DEFINED_SEARCH_ATTRIB.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_USER_DEFINED_SEARCH_ATTRIB'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_USER_DEFINED_SEARCH_EXTRAC.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_USER_DEFINED_SEARCH_EXTRAC'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_USER_DEFINED_SEARCH_FILTER.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_USER_DEFINED_SEARCH_FILTER'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method GET_USER_DEFINED_SEARCH_MESSAG.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'GET_USER_DEFINED_SEARCH_MESSAG'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method RESEND_MESSAGES.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'INPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of INPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>exporting.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'RESEND_MESSAGES'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
