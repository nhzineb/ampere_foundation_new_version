# ==============================================================================
# LAYER 1: BASE SOURCE VIEW (01_views/sources/sdv_tc_runs.view.lkml)
# Strict 1:1 mapping to the final BigQuery table (105 columns in exact ordinal order).
# Respects exact column names and BigQuery data types:
#   - NUMERIC, INT64 -> type: number
#   - STRING         -> type: string
#   - DATETIME       -> dimension_group (type: time, datatype: datetime)
#   - BOOL           -> type: yesno
#   - ARRAY<STRING>  -> TC_Brand (hidden raw array; exposed via display & EXISTS filter in refinement)
# ==============================================================================

view: sdv_tc_runs {
  sql_table_name: `@{GCP_PROJECT}.@{DATASET_NAME}.@{TABLE_NAME}` ;;

  # ----------------------------------------------------------------------------
  # Verified Unique Primary Key (Composite grain across Req, TC, TS, TR, Issue, Automation, Task, Baselines)
  # Required for Looker Symmetric Aggregates to prevent fan-out across M:N entities
  # ----------------------------------------------------------------------------
  dimension: sdv_tc_runs_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(
      COALESCE(CAST(${TABLE}.Req_Id AS STRING), 'NA'), '|',
      COALESCE(${TABLE}.Req_Baseline, 'NA'), '|',
      COALESCE(CAST(${TABLE}.TC_Id AS STRING), 'NA'), '|',
      COALESCE(${TABLE}.Valid_Baseline, 'NA'), '|',
      COALESCE(CAST(${TABLE}.TS_Id AS STRING), 'NA'), '|',
      COALESCE(CAST(${TABLE}.TR_Id AS STRING), 'NA'), '|',
      COALESCE(CAST(${TABLE}.Issue_CBId AS STRING), 'NA'), '|',
      COALESCE(${TABLE}.Issue_Id, 'NA'), '|',
      COALESCE(${TABLE}.Automation_Id, 'NA'), '|',
      COALESCE(${TABLE}.Task_Id, 'NA')
    ) ;;
  }

  # ----------------------------------------------------------------------------
  # Columns 1 - 28: Core Traceability & Test Run (TR) Attributes
  # ----------------------------------------------------------------------------

  # 1. Req_Id (NUMERIC, YES)
  dimension: req_id {
    label: "Req ID"
    group_label: "4. Requirement (Req)"
    type: number
    sql: ${TABLE}.Req_Id ;;
  }

  # 2. Req_Baseline (STRING, YES)
  dimension: req_baseline {
    label: "Req Baseline"
    group_label: "4. Requirement (Req)"
    type: string
    sql: ${TABLE}.Req_Baseline ;;
  }

  # 3. TC_Id (NUMERIC, YES)
  dimension: tc_id {
    label: "TC ID"
    group_label: "1. Test Case (TC)"
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  # 4. Valid_Baseline (STRING, YES)
  dimension: valid_baseline {
    label: "Valid Baseline"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.Valid_Baseline ;;
  }

  # 5. TS_Id (NUMERIC, YES)
  dimension: ts_id {
    label: "TS ID"
    group_label: "2. Test Set (TS)"
    type: number
    sql: ${TABLE}.TS_Id ;;
  }

  # 6. TR_Id (NUMERIC, YES)
  dimension: tr_id {
    label: "TR ID"
    group_label: "3. Test Run (TR)"
    type: number
    sql: ${TABLE}.TR_Id ;;
  }

  # 7. TR_RunDate (DATETIME, YES)
  dimension_group: tr_run_date {
    label: "TR Run Date"
    group_label: "3. Test Run (TR)"
    type: time
    datatype: datetime
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.TR_RunDate ;;
  }

  # 8. TR_LastRunDate (STRING, YES)
  dimension: tr_last_run_date {
    label: "TR Last Run Date"
    group_label: "3. Test Run (TR)"
    type: string
    sql: ${TABLE}.TR_LastRunDate ;;
  }

  # 9. TR_RunWeek (STRING, YES)
  dimension: tr_run_week {
    label: "TR Run Week"
    group_label: "3. Test Run (TR)"
    type: string
    sql: ${TABLE}.TR_RunWeek ;;
  }

  # 10. Issue_CBId (NUMERIC, YES)
  dimension: issue_cb_id {
    label: "Issue CB ID"
    group_label: "5. Issue / Defect"
    type: number
    sql: ${TABLE}.Issue_CBId ;;
  }

  # 11. TR_Result (STRING, YES)
  dimension: tr_result {
    label: "TR Result"
    group_label: "3. Test Run (TR)"
    type: string
    sql: ${TABLE}.TR_Result ;;
  }

  # 12. TR_Relevant_Status (INT64, YES)
  dimension: tr_relevant_status {
    label: "TR Relevant Status"
    group_label: "3. Test Run (TR)"
    type: number
    sql: ${TABLE}.TR_Relevant_Status ;;
  }

  # 13. TR_First_Relevant_Status (INT64, YES)
  dimension: tr_first_relevant_status {
    label: "TR First Relevant Status"
    group_label: "3. Test Run (TR)"
    type: number
    sql: ${TABLE}.TR_First_Relevant_Status ;;
  }

  # 14. TR_LastRevelant (STRING, YES) — exact column spelling preserved
  dimension: tr_last_revelant {
    label: "TR Last Relevant"
    group_label: "3. Test Run (TR)"
    type: string
    sql: ${TABLE}.TR_LastRevelant ;;
  }

  # 15. TR_Relevant_Run (INT64, YES)
  dimension: tr_relevant_run {
    label: "TR Relevant Run"
    group_label: "3. Test Run (TR)"
    type: number
    sql: ${TABLE}.TR_Relevant_Run ;;
  }

  # 16. TR_LastRevelantBefore (STRING, YES) — exact column spelling preserved
  dimension: tr_last_revelant_before {
    label: "TR Last Relevant Before"
    group_label: "3. Test Run (TR)"
    type: string
    sql: ${TABLE}.TR_LastRevelantBefore ;;
  }

  # 17. isLastRun (BOOL, YES)
  dimension: is_last_run {
    label: "Is Last Run (Table Flag)"
    group_label: "3. Test Run (TR)"
    type: yesno
    sql: ${TABLE}.isLastRun ;;
  }

  # 18. Issue_Id (STRING, YES)
  dimension: issue_id {
    label: "Issue ID"
    group_label: "5. Issue / Defect"
    type: string
    sql: ${TABLE}.Issue_Id ;;
  }

  # 19. Issue_Status (STRING, YES)
  dimension: issue_status {
    label: "Issue Status"
    group_label: "5. Issue / Defect"
    type: string
    sql: ${TABLE}.Issue_Status ;;
  }

  # 20. Issue_Criticity (STRING, YES)
  dimension: issue_criticity {
    label: "Issue Criticity"
    group_label: "5. Issue / Defect"
    type: string
    sql: ${TABLE}.Issue_Criticity ;;
  }

  # 21. Issue_Resolution (STRING, YES)
  dimension: issue_resolution {
    label: "Issue Resolution"
    group_label: "5. Issue / Defect"
    type: string
    sql: ${TABLE}.Issue_Resolution ;;
  }

  # 22. Issue_Fix_Version (STRING, YES)
  dimension: issue_fix_version {
    label: "Issue Fix Version"
    group_label: "5. Issue / Defect"
    type: string
    sql: ${TABLE}.Issue_Fix_Version ;;
  }

  # 23. isFirstRun (BOOL, YES)
  dimension: is_first_run {
    label: "Is First Run"
    group_label: "3. Test Run (TR)"
    type: yesno
    sql: ${TABLE}.isFirstRun ;;
  }

  # 24. TR_nbIssuesInvalid (INT64, YES)
  dimension: tr_nb_issues_invalid {
    label: "TR Nb Issues Invalid"
    group_label: "3. Test Run (TR)"
    type: number
    sql: ${TABLE}.TR_nbIssuesInvalid ;;
  }

  # 25. TR_nbIssuesClosed (INT64, YES)
  dimension: tr_nb_issues_closed {
    label: "TR Nb Issues Closed"
    group_label: "3. Test Run (TR)"
    type: number
    sql: ${TABLE}.TR_nbIssuesClosed ;;
  }

  # 26. TR_Regression (STRING, YES)
  dimension: tr_regression {
    label: "TR Regression"
    group_label: "3. Test Run (TR)"
    type: string
    sql: ${TABLE}.TR_Regression ;;
  }

  # 27. TS_ISP_Id (STRING, YES)
  dimension: ts_isp_id {
    label: "TS ISP ID"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_Id ;;
  }

  # 28. UpdateDateData (DATETIME, YES)
  dimension_group: update_date_data {
    label: "Update Date Data"
    group_label: "8. Quality & Partition Metadata"
    type: time
    datatype: datetime
    timeframes: [raw, time, date, week, month, year]
    sql: ${TABLE}.UpdateDateData ;;
  }

  # ----------------------------------------------------------------------------
  # Columns 29 - 46: Test Case (TC) Attributes
  # ----------------------------------------------------------------------------

  # 29. TC_Bench_Type (STRING, YES)
  dimension: tc_bench_type {
    label: "TC Bench Type"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Bench_Type ;;
  }

  # 30. TC_CBProjectName (STRING, YES)
  dimension: tc_cb_project_name {
    label: "TC CB Project Name"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_CBProjectName ;;
  }

  # 31. TC_Domain (STRING, YES)
  dimension: tc_domain {
    label: "TC Domain"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Domain ;;
  }

  # 32. TC_Estimated_Duration (NUMERIC, YES)
  dimension: tc_estimated_duration {
    label: "TC Estimated Duration"
    group_label: "1. Test Case (TC)"
    type: number
    sql: ${TABLE}.TC_Estimated_Duration ;;
  }

  # 33. TC_Execution_Organization (STRING, YES)
  dimension: tc_execution_organization {
    label: "TC Execution Organization"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Execution_Organization ;;
  }

  # 34. TC_Feature (STRING, YES)
  dimension: tc_feature {
    label: "TC Feature"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Feature ;;
  }

  # 35. TC_DUT (STRING, YES)
  dimension: tc_dut {
    label: "TC DUT"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_DUT ;;
  }

  # 36. TC_Name (STRING, YES)
  dimension: tc_name {
    label: "TC Name"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Name ;;
  }

  # 37. TC_Status (STRING, YES)
  dimension: tc_status {
    label: "TC Status"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Status ;;
  }

  # 38. TC_Type (STRING, YES)
  dimension: tc_type {
    label: "TC Type"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Type ;;
  }

  # 39. TC_UID (STRING, YES)
  dimension: tc_uid {
    label: "TC UID"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_UID ;;
  }

  # 40. TC_Domain_Leader (STRING, YES)
  dimension: tc_domain_leader {
    label: "TC Domain Leader"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Domain_Leader ;;
  }

  # 41. TC_Validation_Leader (STRING, YES)
  dimension: tc_validation_leader {
    label: "TC Validation Leader"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Validation_Leader ;;
  }

  # 42. TC_Validation_Team (STRING, YES)
  dimension: tc_validation_team {
    label: "TC Validation Team"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Validation_Team ;;
  }

  # 43. TC_Brand (ARRAY<STRING>, NO) — Hidden raw array; exposed via non-flattening EXISTS filter & display string in refinement
  dimension: tc_brand {
    hidden: yes
    sql: ${TABLE}.TC_Brand ;;
  }

  # 44. TC_LastUpdate (STRING, YES)
  dimension: tc_last_update {
    label: "TC Last Update"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_LastUpdate ;;
  }

  # 45. TC_System_Owner (STRING, YES)
  dimension: tc_system_owner {
    label: "TC System Owner"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_System_Owner ;;
  }

  # 46. TC_Engineering_Level (STRING, YES)
  dimension: tc_engineering_level {
    label: "TC Engineering Level"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Engineering_Level ;;
  }

  # ----------------------------------------------------------------------------
  # Columns 47 - 61: Test Set (TS) Attributes
  # ----------------------------------------------------------------------------

  # 47. TS_Bench_Id (NUMERIC, YES)
  dimension: ts_bench_id {
    label: "TS Bench ID"
    group_label: "2. Test Set (TS)"
    type: number
    sql: ${TABLE}.TS_Bench_Id ;;
  }

  # 48. TS_Bench_Type (STRING, YES)
  dimension: ts_bench_type {
    label: "TS Bench Type"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Bench_Type ;;
  }

  # 49. TS_Domain (STRING, YES)
  dimension: ts_domain {
    label: "TS Domain"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Domain ;;
  }

  # 50. TS_Items_Under_Test (STRING, YES)
  dimension: ts_items_under_Test {
    label: "TS Items Under Test"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Items_Under_Test ;;
  }

  # 51. TS_Name (STRING, YES)
  dimension: ts_name {
    label: "TS Name"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Name ;;
  }

  # 52. TS_Status (STRING, YES)
  dimension: ts_status {
    label: "TS Status"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Status ;;
  }

  # 53. TS_Validation_Team (STRING, YES)
  dimension: ts_validation_team {
    label: "TS Validation Team"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Validation_Team ;;
  }

  # 54. TS_PCU_Releases (STRING, YES)
  dimension: ts_pcu_releases {
    label: "TS PCU Releases"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_PCU_Releases ;;
  }

  # 55. TS_PIU_Releases (STRING, YES)
  dimension: ts_piu_releases {
    label: "TS PIU Releases"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_PIU_Releases ;;
  }

  # 56. TS_IVC_Releases (STRING, YES)
  dimension: ts_ivc_releases {
    label: "TS IVC Releases"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_IVC_Releases ;;
  }

  # 57. TS_CDC_Releases (STRING, YES)
  dimension: ts_cdc_releases {
    label: "TS CDC Releases"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_CDC_Releases ;;
  }

  # 58. TS_Other_Releases (STRING, YES)
  dimension: ts_other_releases {
    label: "TS Other Releases"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Other_Releases ;;
  }

  # 59. TS_Vehicle_Project (STRING, YES)
  dimension: ts_vehicle_project {
    label: "TS Vehicle Project"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Vehicle_Project ;;
  }

  # 60. TS_Type (STRING, YES)
  dimension: ts_type {
    label: "TS Type"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Type ;;
  }

  # 61. TS_Baseline (STRING, YES)
  dimension: ts_baseline {
    label: "TS Baseline"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.TS_Baseline ;;
  }

  # ----------------------------------------------------------------------------
  # Columns 62 - 70: Requirement (Req) & Issue Summary Attributes
  # ----------------------------------------------------------------------------

  # 62. Req_MySF (STRING, YES)
  dimension: req_mysf {
    label: "Req MySF"
    group_label: "4. Requirement (Req)"
    type: string
    sql: ${TABLE}.Req_MySF ;;
  }

  # 63. Req_ASIL (STRING, YES)
  dimension: req_asil {
    label: "Req ASIL"
    group_label: "4. Requirement (Req)"
    type: string
    sql: ${TABLE}.Req_ASIL ;;
  }

  # 64. Req_Name (STRING, YES)
  dimension: req_name {
    label: "Req Name"
    group_label: "4. Requirement (Req)"
    type: string
    sql: ${TABLE}.Req_Name ;;
  }

  # 65. Req_Regulation (STRING, YES)
  dimension: req_regulation {
    label: "Req Regulation"
    group_label: "4. Requirement (Req)"
    type: string
    sql: ${TABLE}.Req_Regulation ;;
  }

  # 66. Req_Safety_Related (STRING, YES)
  dimension: req_safety_related {
    label: "Req Safety Related"
    group_label: "4. Requirement (Req)"
    type: string
    sql: ${TABLE}.Req_Safety_Related ;;
  }

  # 67. Req_ValidationMethods (STRING, YES)
  dimension: req_validation_methods {
    label: "Req Validation Methods"
    group_label: "4. Requirement (Req)"
    type: string
    sql: ${TABLE}.Req_ValidationMethods ;;
  }

  # 68. Req_RequirementCategory (STRING, YES)
  dimension: req_requirement_category {
    label: "Req Requirement Category"
    group_label: "4. Requirement (Req)"
    type: string
    sql: ${TABLE}.Req_RequirementCategory ;;
  }

  # 69. Req_Supplier (STRING, YES)
  dimension: req_supplier {
    label: "Req Supplier"
    group_label: "4. Requirement (Req)"
    type: string
    sql: ${TABLE}.Req_Supplier ;;
  }

  # 70. Issue_Summary (STRING, YES)
  dimension: issue_summary {
    label: "Issue Summary"
    group_label: "5. Issue / Defect"
    type: string
    sql: ${TABLE}.Issue_Summary ;;
  }

  # ----------------------------------------------------------------------------
  # Columns 71 - 90: TS_ISP & Req_ISP Attributes
  # ----------------------------------------------------------------------------

  # 71. TS_ISP_CBId (NUMERIC, YES)
  dimension: ts_isp_cb_id {
    label: "TS ISP CB ID"
    group_label: "6. ISP (TS & Req)"
    type: number
    sql: ${TABLE}.TS_ISP_CBId ;;
  }

  # 72. TS_ISP_Status (STRING, YES)
  dimension: ts_isp_status {
    label: "TS ISP Status"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_Status ;;
  }

  # 73. TS_ISP_Resolution (STRING, YES)
  dimension: ts_isp_resolution {
    label: "TS ISP Resolution"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_Resolution ;;
  }

  # 74. TS_ISP_Summary (STRING, YES)
  dimension: ts_isp_summary {
    label: "TS ISP Summary"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_Summary ;;
  }

  # 75. TS_ISP_Fix_Version (STRING, YES)
  dimension: ts_isp_fix_version {
    label: "TS ISP Fix Version"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_Fix_Version ;;
  }

  # 76. TS_ISP_Committed_Sprint (STRING, YES)
  dimension: ts_isp_committed_sprint {
    label: "TS ISP Committed Sprint"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_Committed_Sprint ;;
  }

  # 77. TS_ISP_Requested_Planning (STRING, YES)
  dimension: ts_isp_requested_planning {
    label: "TS ISP Requested Planning"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_Requested_Planning ;;
  }

  # 78. TS_ISP_Validation_Team (STRING, YES)
  dimension: ts_isp_validation_team {
    label: "TS ISP Validation Team"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_Validation_Team ;;
  }

  # 79. TS_ISP_Brand (STRING, YES)
  dimension: ts_isp_brand {
    label: "TS ISP Brand"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_Brand ;;
  }

  # 80. TS_ISP_MyFeature (STRING, YES)
  dimension: ts_isp_my_feature {
    label: "TS ISP MyFeature"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.TS_ISP_MyFeature ;;
  }

  # 81. Req_ISP_Id (STRING, YES)
  dimension: req_isp_id {
    label: "Req ISP ID"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.Req_ISP_Id ;;
  }

  # 82. Req_ISP_CBId (NUMERIC, YES)
  dimension: req_isp_cb_id {
    label: "Req ISP CB ID"
    group_label: "6. ISP (TS & Req)"
    type: number
    sql: ${TABLE}.Req_ISP_CBId ;;
  }

  # 83. Req_ISP_Status (STRING, YES)
  dimension: req_isp_status {
    label: "Req ISP Status"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.Req_ISP_Status ;;
  }

  # 84. Req_ISP_Resolution (STRING, YES)
  dimension: req_isp_resolution {
    label: "Req ISP Resolution"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.Req_ISP_Resolution ;;
  }

  # 85. Req_ISP_Summary (STRING, YES)
  dimension: req_isp_summary {
    label: "Req ISP Summary"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.Req_ISP_Summary ;;
  }

  # 86. Req_ISP_Fix_Version (STRING, YES)
  dimension: req_isp_fix_version {
    label: "Req ISP Fix Version"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.Req_ISP_Fix_Version ;;
  }

  # 87. Req_ISP_Committed_Sprint (STRING, YES)
  dimension: req_isp_committed_sprint {
    label: "Req ISP Committed Sprint"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.Req_ISP_Committed_Sprint ;;
  }

  # 88. Req_ISP_Requested_Planning (STRING, YES)
  dimension: req_isp_requested_planning {
    label: "Req ISP Requested Planning"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.Req_ISP_Requested_Planning ;;
  }

  # 89. Req_ISP_Validation_Team (STRING, YES)
  dimension: req_isp_validation_team {
    label: "Req ISP Validation Team"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.Req_ISP_Validation_Team ;;
  }

  # 90. Req_ISP_Brand (STRING, YES)
  dimension: req_isp_brand {
    label: "Req ISP Brand"
    group_label: "6. ISP (TS & Req)"
    type: string
    sql: ${TABLE}.Req_ISP_Brand ;;
  }

  # ----------------------------------------------------------------------------
  # Columns 91 - 99: Automation, Milestone, Capitalization & Task Attributes
  # ----------------------------------------------------------------------------

  # 91. Automation_Id (STRING, YES)
  dimension: automation_id {
    label: "Automation ID"
    group_label: "7. Automation & Task"
    type: string
    sql: ${TABLE}.Automation_Id ;;
  }

  # 92. Automation_Name (STRING, YES)
  dimension: automation_name {
    label: "Automation Name"
    group_label: "7. Automation & Task"
    type: string
    sql: ${TABLE}.Automation_Name ;;
  }

  # 93. Automation_Status (STRING, YES)
  dimension: automation_status {
    label: "Automation Status"
    group_label: "7. Automation & Task"
    type: string
    sql: ${TABLE}.Automation_Status ;;
  }

  # 94. Automation_Bench_Type (STRING, YES)
  dimension: automation_bench_type {
    label: "Automation Bench Type"
    group_label: "7. Automation & Task"
    type: string
    sql: ${TABLE}.Automation_Bench_Type ;;
  }

  # 95. Automation_Framework (STRING, YES)
  dimension: automation_framework {
    label: "Automation Framework"
    group_label: "7. Automation & Task"
    type: string
    sql: ${TABLE}.Automation_Framework ;;
  }

  # 96. Automation_Reference_Ticket (STRING, YES)
  dimension: automation_reference_ticket {
    label: "Automation Reference Ticket"
    group_label: "7. Automation & Task"
    type: string
    sql: ${TABLE}.Automation_Reference_Ticket ;;
  }

  # 97. Milestone (STRING, YES)
  dimension: milestone {
    label: "Milestone"
    group_label: "2. Test Set (TS)"
    type: string
    sql: ${TABLE}.Milestone ;;
  }

  # 98. TC_Capitalization (STRING, YES)
  dimension: tc_capitalization {
    label: "TC Capitalization"
    group_label: "1. Test Case (TC)"
    type: string
    sql: ${TABLE}.TC_Capitalization ;;
  }

  # 99. Task_Id (STRING, YES)
  dimension: task_id {
    label: "Task ID"
    group_label: "7. Automation & Task"
    type: string
    sql: ${TABLE}.Task_Id ;;
  }

  # ----------------------------------------------------------------------------
  # Columns 100 - 105: Spotfire Pre-Materialized Columns & Partition Key
  # ----------------------------------------------------------------------------

  # 100. Auto_TS_Runs (STRING, YES)
  dimension: auto_ts_runs {
    label: "Auto TS Runs"
    group_label: "7. Automation & Task"
    type: string
    sql: ${TABLE}.Auto_TS_Runs ;;
  }

  # 101. Partition_week_int (INT64, YES)
  dimension: partition_week_int {
    label: "Partition Week (Int)"
    group_label: "8. Quality & Partition Metadata"
    type: number
    sql: ${TABLE}.Partition_week_int ;;
  }

  # 102. QUA_TC_in_TS (STRING, YES)
  dimension: qua_tc_in_ts {
    label: "QUA TC in TS"
    group_label: "8. Quality & Partition Metadata"
    type: string
    sql: ${TABLE}.QUA_TC_in_TS ;;
  }

  # 103. QUA_TC_NotReady (STRING, YES)
  dimension: qua_tc_not_ready {
    label: "QUA TC Not Ready"
    group_label: "8. Quality & Partition Metadata"
    type: string
    sql: ${TABLE}.QUA_TC_NotReady ;;
  }

  # 104. QUA_TRWithoutIssues (STRING, YES)
  dimension: qua_tr_without_issues {
    label: "QUA TR Without Issues"
    group_label: "8. Quality & Partition Metadata"
    type: string
    sql: ${TABLE}.QUA_TRWithoutIssues ;;
  }

  # 105. Admin_Rank (INT64, YES)
  dimension: admin_rank {
    label: "Admin Rank"
    group_label: "8. Quality & Partition Metadata"
    type: number
    sql: ${TABLE}.Admin_Rank ;;
  }
}
