*&---------------------------------------------------------------------*
*&  Include           ZVC_PLAN_FORMS
*&---------------------------------------------------------------------*
form check_sel_screen .
  IF p_name IS INITIAL.
    MESSAGE E607.
  ENDIF.

  IF P_VAR IS INITIAL.
    MESSAGE E611.
  ENDIF.
endform.

form text_exception  using    p_lang      TYPE sy-langu
                              p_function  TYPE SEOSCOKEY
                     changing p_shorttext.

data lv_exception type vseoexcep.
call function 'SEO_EXCEPTION_GET'
  exporting
    exckey             = p_function
 importing
    exception          = lv_exception
 .
if sy-subrc <> 0.
  p_shorttext  = 'Что-то пошло не так'.
endif.
  p_shorttext  = lv_exception-descript.
endform.

form main .
  lo_abapjob_tmpl = cl_bp_job_factory=>make_abap_job_tmpl( ).
  lo_periodicjob = cl_bp_job_factory=>make_periodic_job( ).
  lo_trigger = cl_tc_trigger_factory=>make_date_trigger( ).

  create object lo_periodicity.
  concatenate  p_name '_' p_var into lv_name.

  lo_abapjob_tmpl->set_name( i_name = lv_name ).
  lo_abapjob_tmpl->set_report( i_report = p_name ).
  lo_abapjob_tmpl->set_variant( i_variant = p_var ).
  lo_abapjob_tmpl->set_language( i_language = sy-langu ).
  lo_abapjob_tmpl->set_effective_user( i_authcknam = p_uname ).
  lo_abapjob_tmpl->plan_job( ).

  lo_periodicity->set_event_periodic( ).
  if p_minute = 'X'.
     num_minutes = p_value.
     lo_periodicity->set_num_minutes( i_minutes = num_minutes ).
  endIF.
  if p_hour   = 'X'.
     num_hours = p_value.
     lo_periodicity->set_num_hours( i_hours = num_hours ).
  endif.
  if p_day    = 'X'.
     num_days = p_value.
     lo_periodicity->set_num_days( i_days = num_days ).
  endif.
  if p_week   = 'X'.
     num_weeks = p_value.
     lo_periodicity->set_num_weeks( i_weeks = num_weeks ).
  endif.
  if p_month  = 'X'.
     num_months = p_value.
     lo_periodicity->set_num_months( i_months = num_months ).
  endif.


  " Дата и время начала выполнения задания
  lo_trigger->set_sdlstrtdt( i_sdlstrtdt = p_sdate ).
  lo_trigger->set_sdlstrttm( i_sdlstrttm = p_stime ).

  " Дата и время окончания выполнения задания
  lo_trigger->set_laststrtdt( i_laststrtdt = p_edate ).
  lo_trigger->set_laststrttm( i_laststrttm = p_etime ).


  lo_periodicjob->set_name( i_name = lv_name ).
  lo_periodicjob->set_trg_type( i_trg_type = 'DATE' ).
  lo_periodicjob->attach_job_template( i_job_template = lo_abapjob_tmpl ).
  lo_periodicjob->attach_periodicity( i_periodicity = lo_periodicity ).

     lo_periodicjob->release_job(
                                  exporting
                                    i_trg_obj = lo_trigger
                                  exceptions
                                    cant_start_immediate   = 1
                                    invalid_startdate      = 2
                                    jobname_missing        = 3
                                    job_close_failed       = 4
                                    job_nosteps            = 5
                                    job_notex              = 6
                                    lock_failed            = 7
                                    )
      .

      lv_funct-clsname = 'IF_BP_JOB_ENGINE'.
      lv_funct-cmpname = 'RELEASE_JOB'.

      if sy-subrc <> 0.
        case sy-subrc.
          when 1. lv_funct-sconame = 'CANT_START_IMMEDIATE'.
          when 2. lv_funct-sconame = 'INVALID_STARTDATE'.
          when 3. lv_funct-sconame =  'JOBNAME_MISSING'.
          when 4. lv_funct-sconame =  'JOB_CLOSE_FAILED'.
          when 5. lv_funct-sconame =  'JOB_NOSTEPS'.
          when 6. lv_funct-sconame =  'JOB_NOTEX'.
          when 7. lv_funct-sconame =  'LOCK_FAILED'.
          when others.
                  shorttext = 'Пушномолочная свинья несушка'.
        endcase.
        perform text_exception using    sy-langu lv_funct
                               changing shorttext.
        MESSAGE shorttext type 'E'.
      endif.
      CONCATENATE 'Задание' lv_name ' запланировано.' INTO shorttext.
      MESSAGE shorttext TYPE 'S'.
endform.
