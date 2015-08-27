REPORT ZVC_PLAN_TM MESSAGE-ID DB.

include zvc_plan_data.
include zvc_plan_sscrn.
include zvc_plan_forms.

START-OF-SELECTION.
  PERFORM check_sel_screen.
  PERFORM main.
END-OF-SELECTION.
