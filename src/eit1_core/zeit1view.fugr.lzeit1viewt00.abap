*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 28.10.2019 at 08:30:32
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZTEIT_INTERFACES................................*
DATA:  BEGIN OF STATUS_ZTEIT_INTERFACES              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTEIT_INTERFACES              .
CONTROLS: TCTRL_ZTEIT_INTERFACES
            TYPE TABLEVIEW USING SCREEN '0003'.
*...processing: ZTEIT_PROJECTS..................................*
DATA:  BEGIN OF STATUS_ZTEIT_PROJECTS                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTEIT_PROJECTS                .
CONTROLS: TCTRL_ZTEIT_PROJECTS
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZTEIT_SYSTEMS...................................*
DATA:  BEGIN OF STATUS_ZTEIT_SYSTEMS                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTEIT_SYSTEMS                 .
CONTROLS: TCTRL_ZTEIT_SYSTEMS
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZTEIT_INTERFACES              .
TABLES: *ZTEIT_PROJECTS                .
TABLES: *ZTEIT_SYSTEMS                 .
TABLES: ZTEIT_INTERFACES               .
TABLES: ZTEIT_PROJECTS                 .
TABLES: ZTEIT_SYSTEMS                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
