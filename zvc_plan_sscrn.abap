*&---------------------------------------------------------------------*
*&  Include           ZVC_PLAN_SSCRN
*&---------------------------------------------------------------------*
selection-screen begin of block part0 with frame title text-000.
select-options:
            p_lifnr  for zvcparwh-lifnr_ref   no-extension no intervals obligatory,
            so_lifnr for zvcparwh-lifnr       no-extension no intervals
            .

parameters:
            p_name     type btcprog obligatory," MATCHCODE OBJECT PROGNAME,
            p_var      type btcvariant obligatory,
            p_uname    type btcauthnam default sy-uname obligatory
            .
selection-screen end of block part0.

selection-screen begin of block part1 with frame title text-001.
parameters: p_sdate   type sydats default sy-datum,
            p_stime   type sytime,
            p_edate   type sydats default sy-datum,
            p_etime   type sytime
            .
selection-screen end of block part1.

selection-screen begin of block part2 with frame title text-002.
parameters: p_month   radiobutton group rad1,
            p_week    radiobutton group rad1,
            p_day     radiobutton group rad1,
            p_hour    radiobutton group rad1,
            p_minute  radiobutton group rad1 default 'X',
            p_value   type c length 4
            .
selection-screen end of block part2.

AT SELECTION-SCREEN ON p_name.
  IF p_name IS INITIAL.
    MESSAGE E607.
  ENDIF.

AT SELECTION-SCREEN ON P_VAR.
  IF P_VAR IS INITIAL.
    MESSAGE E611.
  ENDIF.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_name.

   CALL FUNCTION 'REPOSITORY_INFO_SYSTEM_F4'
         EXPORTING
              OBJECT_TYPE           = 'PROG'
              OBJECT_NAME           =  p_name
              SUPPRESS_SELECTION    = 'X'
         IMPORTING
              OBJECT_NAME_SELECTED  = p_name
         EXCEPTIONS
              CANCEL      = 01
              OTHERS      = 02.
   CASE SY-SUBRC.
     WHEN 01.
       EXIT.
     WHEN 02.
       MESSAGE S093 WITH TEXT-002.
       EXIT.
   ENDCASE.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_VAR.
  CALL FUNCTION 'RS_VARIANT_CATALOG'
       EXPORTING
            REPORT               = p_name
      IMPORTING
           SEL_VARIANT          =  P_VAR
*           SEL_VARIANT_TEXT     =
      EXCEPTIONS
           NO_REPORT            = 1
           REPORT_NOT_EXISTENT  = 2
           REPORT_NOT_SUPPLIED  = 3
           NO_VARIANTS          = 4
           NO_VARIANT_SELECTED  = 5
           OTHERS               = 6        .
   CASE SY-SUBRC.
     WHEN 1.
       MESSAGE S287. "das programm hat keine selektionen (typ s)
     WHEN 2.
       MESSAGE S628 WITH P_NAME. "Der Report ist nicht in der Bibliothek
     WHEN 3.
       MESSAGE S607.   " Bitte einen Programmnamen angeben
     WHEN 4.
       MESSAGE S613 WITH P_NAME.  "fќr rep & sind keine var. angelegt
     WHEN 5.
     WHEN 6.
       MESSAGE S093 WITH TEXT-004.
   ENDCASE.
