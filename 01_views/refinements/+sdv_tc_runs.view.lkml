# ==============================================================================
# LAYER 2: CERTIFIED KPI & PARAMETER REFINEMENTS
# (01_views/refinements/+sdv_tc_runs.view.lkml)
# Translates all 38 Spotfire Calculations, OVER/Rank formulas, Document
# Properties, and non-flattening TC_Brand ARRAY<STRING> filtering from
# SDV_TC_Runs__Foundation (2).dxp into governed LookML.
# ==============================================================================

include: "/01_views/sources/sdv_tc_runs.view.lkml"

view: +sdv_tc_runs {

  # ----------------------------------------------------------------------------
  # 1. Drill Set for Spotfire "Details-on-Demand" Modal Inspection
  # ----------------------------------------------------------------------------
  set: sdv_tc_run_drill_details {
    fields: [
      tc_id,
      tc_name,
      tc_status,
      tc_domain,
      tc_validation_team,
      tc_engineering_level,
      tc_system_owner,
      tc_brand_display,
      ts_id,
      ts_name,
      ts_vehicle_project,
      milestone,
      valid_baseline,
      tr_id,
      tr_result,
      tr_run_date_date,
      tr_run_week,
      issue_id,
      issue_status,
      issue_criticity,
      req_id,
      req_mysf,
      req_asil
    ]
  }

  # ----------------------------------------------------------------------------
  # 2. Non-Flattening ARRAY<STRING> Handling for TC_Brand (Col 43)
  #    Follows filtering_arrays_without_unnesting.md: zero row multiplication!
  # ----------------------------------------------------------------------------
  dimension: tc_brand_display {
    label: "TC Brand (All)"
    group_label: "1. Test Case (TC)"
    description: "Comma-separated display of TC_Brand ARRAY<STRING> without row fan-out."
    type: string
    sql: ARRAY_TO_STRING(${TABLE}.TC_Brand, ', ') ;;
  }

  filter: tc_brand_filter {
    label: "TC Brand (Filter Any)"
    group_label: "1. Test Case (TC)"
    description: "Filters TC_Brand ARRAY<STRING> via correlated EXISTS without unnesting or multiplying rows."
    type: string
    sql: EXISTS (
      SELECT 1
      FROM UNNEST(${TABLE}.TC_Brand) AS brand_elem
      WHERE {% condition tc_brand_filter %} brand_elem {% endcondition %}
    ) ;;
  }

  # ----------------------------------------------------------------------------
  # 3. Spotfire Scope Toggles (Document Properties: AcceptedOnly, TCinTSOnly,
  #    isBacklogDescoped, OnlyLastRun)
  # ----------------------------------------------------------------------------
  dimension: accepted_only_scope {
    label: "Scope Toggle — Accepted / Approved / Rework TC Only (AcceptedOnly)"
    group_label: "9. Spotfire Scope Toggles"
    description: "Spotfire ${AcceptedOnly}: when Yes, restricts to TC_Status IN ('Accepted', 'Approved', 'Rework')."
    type: yesno
    sql: ${tc_status} IN ('Accepted', 'Approved', 'Rework') ;;
  }

  dimension: accepted_approved_strict_scope {
    label: "Scope Toggle — Accepted / Approved TC Only (Executed Runs)"
    group_label: "9. Spotfire Scope Toggles"
    description: "Spotfire filter_executed_accepted_runs: TC_Status IN ('Accepted', 'Approved')."
    type: yesno
    sql: ${tc_status} IN ('Accepted', 'Approved') ;;
  }

  dimension: tc_in_ts_only_scope {
    label: "Scope Toggle — TC in a Test Set Only (TCinTSOnly)"
    group_label: "9. Spotfire Scope Toggles"
    description: "Spotfire ${TCinTSOnly}: when Yes, restricts to rows where TS_Id IS NOT NULL."
    type: yesno
    sql: ${ts_id} IS NOT NULL ;;
  }

  dimension: exclude_backlog_descoped_scope {
    label: "Scope Toggle — Exclude Backlog & Descoped (isBacklogDescoped)"
    group_label: "9. Spotfire Scope Toggles"
    description: "Spotfire ${isBacklogDescoped}: when Yes, excludes TC_Execution_Organization IN ('Backlog', 'Descoped')."
    type: yesno
    sql: COALESCE(${tc_execution_organization}, '') NOT IN ('Backlog', 'Descoped') ;;
  }

  dimension: is_executed_run {
    label: "Is Executed Run (TR_Result != Not Executed)"
    group_label: "9. Spotfire Scope Toggles"
    type: yesno
    sql: ${tr_result} IS NOT NULL AND ${tr_result} != 'Not Executed' ;;
  }

  dimension: has_automation_request {
    label: "Has Automation Request (Automation_Id IS NOT NULL)"
    group_label: "7. Automation & Task"
    type: yesno
    sql: ${automation_id} IS NOT NULL ;;
  }

  # ----------------------------------------------------------------------------
  # 4. Spotfire Document Properties -> Native LookML Parameters + Liquid Axes
  #    Replaces:
  #      - <$esc(${tr.horizontalAxis})>
  #      - <$esc(${tc.feature})>
  #      - <$esc(${ColumnAxis})>
  #      - <$esc(${RowsAxis})>
  #      - UniqueCount($esc(${ItemsCount}))
  # ----------------------------------------------------------------------------
  parameter: tr_horizontal_axis_selector {
    label: "Horizontal Axis Selector (Spotfire tr.horizontalAxis)"
    group_label: "9. Spotfire Dynamic Selectors"
    type: unquoted
    default_value: "ts_vehicle_project"
    allowed_value: { label: "TS Vehicle Project" value: "ts_vehicle_project" }
    allowed_value: { label: "TC Domain" value: "tc_domain" }
    allowed_value: { label: "TS Domain" value: "ts_domain" }
    allowed_value: { label: "Milestone" value: "milestone" }
    allowed_value: { label: "TC Validation Team" value: "tc_validation_team" }
    allowed_value: { label: "TS Validation Team" value: "ts_validation_team" }
    allowed_value: { label: "TC Engineering Level" value: "tc_engineering_level" }
    allowed_value: { label: "TC System Owner" value: "tc_system_owner" }
    allowed_value: { label: "Valid Baseline" value: "valid_baseline" }
    allowed_value: { label: "Req MySF" value: "req_mysf" }
  }

  dimension: dynamic_horizontal_axis {
    label_from_parameter: tr_horizontal_axis_selector
    group_label: "9. Spotfire Dynamic Selectors"
    type: string
    sql:
      {% if tr_horizontal_axis_selector._parameter_value == 'ts_vehicle_project' %}
        ${ts_vehicle_project}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'tc_domain' %}
        ${tc_domain}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'ts_domain' %}
        ${ts_domain}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'milestone' %}
        ${milestone}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'tc_validation_team' %}
        ${tc_validation_team}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'ts_validation_team' %}
        ${ts_validation_team}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'tc_engineering_level' %}
        ${tc_engineering_level}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'tc_system_owner' %}
        ${tc_system_owner}
      {% elsif tr_horizontal_axis_selector._parameter_value == 'valid_baseline' %}
        ${valid_baseline}
      {% else %}
        ${req_mysf}
      {% endif %} ;;
  }

  parameter: tc_feature_axis_selector {
    label: "TC Breakdown Axis Selector (Spotfire tc.feature)"
    group_label: "9. Spotfire Dynamic Selectors"
    type: unquoted
    default_value: "tc_feature"
    allowed_value: { label: "TC Feature" value: "tc_feature" }
    allowed_value: { label: "TC Domain" value: "tc_domain" }
    allowed_value: { label: "TC Bench Type" value: "tc_bench_type" }
    allowed_value: { label: "TC Engineering Level" value: "tc_engineering_level" }
    allowed_value: { label: "TC Validation Team" value: "tc_validation_team" }
  }

  dimension: dynamic_tc_feature_axis {
    label_from_parameter: tc_feature_axis_selector
    group_label: "9. Spotfire Dynamic Selectors"
    type: string
    sql:
      {% if tc_feature_axis_selector._parameter_value == 'tc_feature' %}
        ${tc_feature}
      {% elsif tc_feature_axis_selector._parameter_value == 'tc_domain' %}
        ${tc_domain}
      {% elsif tc_feature_axis_selector._parameter_value == 'tc_bench_type' %}
        ${tc_bench_type}
      {% elsif tc_feature_axis_selector._parameter_value == 'tc_engineering_level' %}
        ${tc_engineering_level}
      {% else %}
        ${tc_validation_team}
      {% endif %} ;;
  }

  parameter: column_axis_selector {
    label: "CrossTable Column Axis (Spotfire ColumnAxis)"
    group_label: "9. Spotfire Dynamic Selectors"
    type: unquoted
    default_value: "ts_domain"
    allowed_value: { label: "TS Domain" value: "ts_domain" }
    allowed_value: { label: "TC Domain" value: "tc_domain" }
    allowed_value: { label: "TC Status" value: "tc_status" }
    allowed_value: { label: "TR Result" value: "tr_result" }
    allowed_value: { label: "TS Vehicle Project" value: "ts_vehicle_project" }
    allowed_value: { label: "Milestone" value: "milestone" }
    allowed_value: { label: "Valid Baseline" value: "valid_baseline" }
  }

  dimension: dynamic_column_axis {
    label_from_parameter: column_axis_selector
    group_label: "9. Spotfire Dynamic Selectors"
    type: string
    sql:
      {% if column_axis_selector._parameter_value == 'ts_domain' %}
        ${ts_domain}
      {% elsif column_axis_selector._parameter_value == 'tc_domain' %}
        ${tc_domain}
      {% elsif column_axis_selector._parameter_value == 'tc_status' %}
        ${tc_status}
      {% elsif column_axis_selector._parameter_value == 'tr_result' %}
        ${tr_result}
      {% elsif column_axis_selector._parameter_value == 'ts_vehicle_project' %}
        ${ts_vehicle_project}
      {% elsif column_axis_selector._parameter_value == 'milestone' %}
        ${milestone}
      {% else %}
        ${valid_baseline}
      {% endif %} ;;
  }

  parameter: rows_axis_selector {
    label: "CrossTable Row Axis (Spotfire RowsAxis)"
    group_label: "9. Spotfire Dynamic Selectors"
    type: unquoted
    default_value: "tc_domain"
    allowed_value: { label: "TC Domain" value: "tc_domain" }
    allowed_value: { label: "TC Validation Team" value: "tc_validation_team" }
    allowed_value: { label: "TS Validation Team" value: "ts_validation_team" }
    allowed_value: { label: "TC System Owner" value: "tc_system_owner" }
    allowed_value: { label: "TC Engineering Level" value: "tc_engineering_level" }
    allowed_value: { label: "Milestone" value: "milestone" }
    allowed_value: { label: "Req ASIL" value: "req_asil" }
  }

  dimension: dynamic_rows_axis {
    label_from_parameter: rows_axis_selector
    group_label: "9. Spotfire Dynamic Selectors"
    type: string
    sql:
      {% if rows_axis_selector._parameter_value == 'tc_domain' %}
        ${tc_domain}
      {% elsif rows_axis_selector._parameter_value == 'tc_validation_team' %}
        ${tc_validation_team}
      {% elsif rows_axis_selector._parameter_value == 'ts_validation_team' %}
        ${ts_validation_team}
      {% elsif rows_axis_selector._parameter_value == 'tc_system_owner' %}
        ${tc_system_owner}
      {% elsif rows_axis_selector._parameter_value == 'tc_engineering_level' %}
        ${tc_engineering_level}
      {% elsif rows_axis_selector._parameter_value == 'milestone' %}
        ${milestone}
      {% else %}
        ${req_asil}
      {% endif %} ;;
  }

  parameter: items_count_selector {
    label: "Items Count Entity Selector (Spotfire ItemsCount)"
    group_label: "9. Spotfire Dynamic Selectors"
    type: unquoted
    default_value: "ts_id"
    allowed_value: { label: "Unique Test Sets (TS_Id)" value: "ts_id" }
    allowed_value: { label: "Unique Test Cases (TC_Id)" value: "tc_id" }
    allowed_value: { label: "Unique Test Runs (TR_Id)" value: "tr_id" }
    allowed_value: { label: "Unique Requirements (Req_Id)" value: "req_id" }
    allowed_value: { label: "Unique Issues (Issue_Id)" value: "issue_id" }
    allowed_value: { label: "Unique Automation Requests (Automation_Id)" value: "automation_id" }
  }

  measure: dynamic_items_unique_count {
    label_from_parameter: items_count_selector
    group_label: "1. Core Entity Counts"
    description: "Replaces Spotfire UniqueCount($esc(${ItemsCount})) on QUALITY 3/3."
    type: number
    sql:
      {% if items_count_selector._parameter_value == 'ts_id' %}
        COUNT(DISTINCT ${ts_id})
      {% elsif items_count_selector._parameter_value == 'tc_id' %}
        COUNT(DISTINCT ${tc_id})
      {% elsif items_count_selector._parameter_value == 'tr_id' %}
        COUNT(DISTINCT ${tr_id})
      {% elsif items_count_selector._parameter_value == 'req_id' %}
        COUNT(DISTINCT ${req_id})
      {% elsif items_count_selector._parameter_value == 'issue_id' %}
        COUNT(DISTINCT ${issue_id})
      {% else %}
        COUNT(DISTINCT ${automation_id})
      {% endif %} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  # ----------------------------------------------------------------------------
  # 5. Core Hub Entity Measures (Symmetric Aggregates replacing Rank(RowId(),...)=1)
  # ----------------------------------------------------------------------------
  measure: unique_tc_count {
    label: "Total Unique Test Cases (TC)"
    group_label: "1. Core Entity Counts"
    description: "Replaces Spotfire UniqueCount([TC_Id]) and Rank(RowId(),[TC_Id])=1."
    type: count_distinct
    sql: ${tc_id} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: unique_tr_count {
    label: "Total Unique Test Runs (TR)"
    group_label: "1. Core Entity Counts"
    description: "Replaces Spotfire UniqueCount([TR_Id]) and Rank(RowId(),[TR_Id])=1."
    type: count_distinct
    sql: ${tr_id} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: unique_ts_count {
    label: "Total Unique Test Sets (TS)"
    group_label: "1. Core Entity Counts"
    description: "Replaces Spotfire UniqueCount([TS_Id])."
    type: count_distinct
    sql: ${ts_id} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: unique_req_count {
    label: "Total Unique Requirements (Req)"
    group_label: "1. Core Entity Counts"
    description: "Replaces Spotfire UniqueCount([Req_Id])."
    type: count_distinct
    sql: ${req_id} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: unique_issue_count {
    label: "Total Unique Issues"
    group_label: "1. Core Entity Counts"
    description: "Replaces Spotfire UniqueCount([Issue_Id])."
    type: count_distinct
    sql: ${issue_id} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: unique_automation_count {
    label: "Total Unique Automation Requests"
    group_label: "1. Core Entity Counts"
    description: "Replaces Spotfire UniqueCount([Automation_Id])."
    type: count_distinct
    sql: ${automation_id} ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  # ----------------------------------------------------------------------------
  # 6. Page 1 ("TC LAST RUNS Results") Bespoke Spoke Measures
  #    Replaces UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 and [TR_Result]='...' then [TC_Id] end)
  # ----------------------------------------------------------------------------
  measure: last_run_total_tc_count {
    label: "Last Run — Total TCs"
    group_label: "2. Page 1: TC Last Runs KPIs"
    description: "Replaces UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [fact_tc_dynamic_last_run.is_dynamic_last_run: "yes"]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: last_run_passed_tc_count {
    label: "Last Run — Passed TCs"
    group_label: "2. Page 1: TC Last Runs KPIs"
    description: "Replaces UniqueCount(case when (Rank([Admin_Rank],[TC_Id])=1) and ([TR_Result]='Passed') then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Passed"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: last_run_failed_tc_count {
    label: "Last Run — Failed TCs"
    group_label: "2. Page 1: TC Last Runs KPIs"
    description: "Replaces UniqueCount(case when (Rank([Admin_Rank],[TC_Id])=1) and ([TR_Result]='Failed') then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Failed"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: last_run_blocked_tc_count {
    label: "Last Run — Blocked TCs"
    group_label: "2. Page 1: TC Last Runs KPIs"
    description: "Replaces UniqueCount(case when (Rank([Admin_Rank],[TC_Id])=1) and ([TR_Result]='Blocked') then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Blocked"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: last_run_not_executed_tc_count {
    label: "Last Run — Not Executed TCs"
    group_label: "2. Page 1: TC Last Runs KPIs"
    description: "Replaces UniqueCount(case when (Rank([Admin_Rank],[TC_Id])=1) and ([TR_Result]='Not Executed') then [TC_Id] else null end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Not Executed"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: last_run_pass_rate {
    label: "Last Run — Pass Rate (%)"
    group_label: "2. Page 1: TC Last Runs KPIs"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${last_run_passed_tc_count}, NULLIF(${last_run_total_tc_count}, 0)) ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  # Replaces Spotfire UniqueConcatenate(Concatenate([Issue_Id],' (',[Issue_Criticity],', ',[Issue_Status],')'))
  dimension: formatted_failed_issue_summary {
    hidden: yes
    type: string
    sql:
      CASE
        WHEN ${issue_id} IS NOT NULL
          AND ${fact_tc_dynamic_last_run.is_dynamic_last_run}
          AND ${fact_tc_dynamic_last_run.last_run_result} = 'Failed'
        THEN CONCAT(${issue_id}, ' (', COALESCE(${issue_criticity}, 'NA'), ', ', COALESCE(${issue_status}, 'NA'), ')')
        ELSE NULL
      END ;;
  }

  measure: failed_last_run_issues_list {
    label: "Failed Last Run Issues (Concatenated)"
    group_label: "2. Page 1: TC Last Runs KPIs"
    description: "Replaces Spotfire UniqueConcatenate(Concatenate([Issue_Id],' (',[Issue_Criticity],', ',[Issue_Status],')'))."
    type: list
    list_field: formatted_failed_issue_summary
  }

  # ----------------------------------------------------------------------------
  # 7. Page 2 ("TC ALL Runs") & Page 3 ("TC First Runs") Measures
  # ----------------------------------------------------------------------------
  measure: executed_tr_count {
    label: "Executed Test Runs (TR_Result != Not Executed)"
    group_label: "3. Pages 2 & 3: All & First Runs KPIs"
    description: "Replaces Spotfire UniqueCount([TR_Id]) with filter_executed_accepted_runs."
    type: count_distinct
    sql: ${tr_id} ;;
    filters: [is_executed_run: "yes"]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: first_run_total_tc_count {
    label: "First Run — Total TCs"
    group_label: "3. Pages 2 & 3: All & First Runs KPIs"
    description: "Replaces Spotfire UniqueCount([TC_Id]) where [isFirstRun] = True."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [is_first_run: "yes"]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: first_run_executed_tc_count {
    label: "First Run — Executed TCs"
    group_label: "3. Pages 2 & 3: All & First Runs KPIs"
    description: "Replaces Spotfire UniqueCount([TC_Id]) where [isFirstRun] = True and [TR_Result] != 'Not Executed'."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [is_first_run: "yes", is_executed_run: "yes"]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: first_run_passed_tc_count {
    label: "First Run — Passed TCs"
    group_label: "3. Pages 2 & 3: All & First Runs KPIs"
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [is_first_run: "yes", tr_result: "Passed"]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: first_run_pass_rate {
    label: "First Run — Right-First-Time Pass Rate (%)"
    group_label: "3. Pages 2 & 3: All & First Runs KPIs"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE(${first_run_passed_tc_count}, NULLIF(${first_run_executed_tc_count}, 0)) ;;
    drill_fields: [sdv_tc_run_drill_details*]
  }

  # ----------------------------------------------------------------------------
  # 8. Page 4 ("Automation & Runs") Measures
  # ----------------------------------------------------------------------------
  measure: tc_with_automation_request_count {
    label: "TCs with Automation Request"
    group_label: "4. Page 4: Automation KPIs"
    description: "Replaces Spotfire UniqueCount([TC_Id]) with filter_automation_requests_scope (not [Automation_Id] is null)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [has_automation_request: "yes"]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  # ----------------------------------------------------------------------------
  # 9. Page 5 ("QUALITY 1/3") & Page 6 ("QUALITY 2/3") Measures
  # ----------------------------------------------------------------------------
  measure: failed_blocked_without_issue_tc_count {
    label: "Quality 1/3 — Failed/Blocked TCs Without Issue"
    group_label: "5. Pages 5 & 6: Quality KPIs"
    description: "Replaces Spotfire UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 and [TR_Result] in ('Failed','Blocked') and [Issue_Id] is null then [TC_Id] end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Failed, Blocked",
      issue_id: "NULL"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: failed_blocked_closed_issue_tc_count {
    label: "Quality 1/3 — Failed/Blocked TCs Linked to Closed Issue"
    group_label: "5. Pages 5 & 6: Quality KPIs"
    description: "Replaces Spotfire UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 and [TR_Result] in ('Failed','Blocked') and [Issue_Status] in ('Closed','Verified','Integrated','Invalid') then [TC_Id] end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Failed, Blocked",
      issue_status: "Closed, Verified, Integrated, Invalid"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: failed_blocked_derogated_issue_tc_count {
    label: "Quality 1/3 — Failed/Blocked TCs Linked to Derogated Issue"
    group_label: "5. Pages 5 & 6: Quality KPIs"
    description: "Replaces Spotfire UniqueCount(case when Rank([Admin_Rank],[TC_Id])=1 and [TR_Result] in ('Failed','Blocked') and [Issue_Status] in ('Derogated') then [TC_Id] end)."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [
      fact_tc_dynamic_last_run.is_dynamic_last_run: "yes",
      fact_tc_dynamic_last_run.last_run_result: "Failed, Blocked",
      issue_status: "Derogated"
    ]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: tc_not_in_ts_count {
    label: "Quality 2/3 — TCs Not in a Test Set"
    group_label: "5. Pages 5 & 6: Quality KPIs"
    description: "Replaces Spotfire UniqueCount([TC_Id]) where [QUA_TC_in_TS] = 'not in a Test Set'."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [qua_tc_in_ts: "not in a Test Set"]
    drill_fields: [sdv_tc_run_drill_details*]
  }

  measure: tc_not_ready_in_ts_count {
    label: "Quality 2/3 — TCs Not Ready in a Test Set"
    group_label: "5. Pages 5 & 6: Quality KPIs"
    description: "Replaces Spotfire UniqueCount([TC_Id]) where [QUA_TC_in_TS] = 'In a Test Set' and [QUA_TC_NotReady] = 'TC not Ready'."
    type: count_distinct
    sql: ${tc_id} ;;
    filters: [qua_tc_in_ts: "In a Test Set", qua_tc_not_ready: "TC not Ready"]
    drill_fields: [sdv_tc_run_drill_details*]
  }
}
