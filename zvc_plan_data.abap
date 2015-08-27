*&---------------------------------------------------------------------*
*&  Include           ZVC_PLAN_DATA
*&---------------------------------------------------------------------*
tables:
     zvcparwh.
data
      lv_name type btcjob.

data:
      num_minutes type  tbtcjob-prdmins,
      num_hours   type  tbtcjob-prdhours,
      num_days    type  tbtcjob-prddays,
      num_weeks   type  tbtcjob-prdweeks,
      num_months  type  tbtcjob-prdmonths
      .

DATA:
      lo_exc_root       type ref to cx_root,
      oref              type ref to cx_root,
      bapi_messages     type bapirettab,
      message_collector type ref to if_reca_message_list.

class CX_LOCAL_EXCEPTION definition
 inheriting from CX_STATIC_CHECK.
endclass.

class CX_DYNAMIC_EXCEPTION definition
 inheriting from CX_DYNAMIC_CHECK.
endclass.


 DATA: lv_funct   TYPE SEOSCOKEY,
       shorttext  TYPE c LENGTH 254
      .


 data:
  lo_periodicjob  type ref to cl_bp_periodic_job,
  lo_periodicity  type ref to cl_bp_job_periodicity,
  lo_trigger      type ref to cl_tc_date_trigger,
  lo_abapjob_tmpl type ref to cl_bp_abap_job_template.
