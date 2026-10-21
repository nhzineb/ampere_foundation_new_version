# ==============================================================================
# STAGE 4: LOOKER 26.4+ NATIVE TABBED DASHBOARD
# (05_dashboards/sdv_tc_runs_foundation.dashboard.lkml)
# Migrated from Spotfire workbook: SDV_TC_Runs__Foundation (2).dxp
# Strictly NO `model:` property in filters or elements (per user instructions).
# Consolidates the 7 Spotfire Pages into Looker's maximum 5 native LookML
# dashboard tabs, with Cross-Filtering + bottom Detailed View tables.
# ==============================================================================

- dashboard: sdv_tc_runs_foundation
  title: "SDV TC Runs — Foundation (Spotfire Migration)"
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: "Migrated from Spotfire SDV_TC_Runs__Foundation (2).dxp. Replaces Spotfire Pages with Looker 26.4+ native tabs (max 5 tabs per LookML dashboard), Markings (1–3) with Cross-Filtering + bottom Detailed View tables, and Document Properties with LookML parameters."

  # Looker Native Built-In Dashboard Tabs (LookML validator max: 5 tabs)
  tabs:
    - name: tab_1_tc_last_runs_results
      label: "1. TC LAST RUNS Results"
    - name: tab_2_tc_all_and_first_runs
      label: "2. TC ALL & First Runs"
    - name: tab_3_automation_and_runs
      label: "3. Automation & Runs"
    - name: tab_4_quality_issues_and_readiness
      label: "4. QUALITY 1/3 & 2/3 (Issues & Readiness)"
    - name: tab_5_quality_crosstable_all_data
      label: "5. QUALITY 3/3 (CrossTable & All Data)"

  filters:
    - name: vehicle_project
      title: "Vehicle Project (TS_Vehicle_Project)"
      type: field_filter
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.ts_vehicle_project
      ui_config:
        type: tag_list
        display: popover

    - name: tc_domain
      title: "TC Domain"
      type: field_filter
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.tc_domain
      ui_config:
        type: tag_list
        display: popover

    - name: milestone
      title: "Milestone"
      type: field_filter
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.milestone
      listens_to_filters: [vehicle_project]
      ui_config:
        type: dropdown_menu
        display: inline

    - name: valid_baseline
      title: "Valid Baseline"
      type: field_filter
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.valid_baseline
      listens_to_filters: [vehicle_project, tc_domain]
      ui_config:
        type: tag_list
        display: popover

    - name: req_mysf
      title: "Req MySF"
      type: field_filter
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.req_mysf
      listens_to_filters: [vehicle_project, tc_domain]
      ui_config:
        type: tag_list
        display: popover

    - name: tc_brand_filter
      title: "TC Brand (Any)"
      type: field_filter
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.tc_brand_filter
      ui_config:
        type: tag_list
        display: popover

    - name: accepted_only
      title: "Accepted / Approved / Rework TC Only (AcceptedOnly)"
      type: field_filter
      default_value: "Yes"
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.accepted_only_scope
      ui_config:
        type: button_toggles
        display: inline

    - name: tc_in_ts_only
      title: "TC in a Test Set Only (TCinTSOnly)"
      type: field_filter
      default_value: "Yes"
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.tc_in_ts_only_scope
      ui_config:
        type: button_toggles
        display: inline

    - name: exclude_backlog_descoped
      title: "Exclude Backlog & Descoped (isBacklogDescoped)"
      type: field_filter
      default_value: "Yes"
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.exclude_backlog_descoped_scope
      ui_config:
        type: button_toggles
        display: inline

    - name: horizontal_axis_selector
      title: "Horizontal Axis (Spotfire tr.horizontalAxis)"
      type: field_filter
      default_value: "ts_vehicle_project"
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.tr_horizontal_axis_selector
      ui_config:
        type: dropdown_menu
        display: inline

    - name: rows_axis_selector
      title: "CrossTable Row Axis (Spotfire RowsAxis)"
      type: field_filter
      default_value: "tc_domain"
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.rows_axis_selector
      ui_config:
        type: dropdown_menu
        display: inline

    - name: column_axis_selector
      title: "CrossTable Column Axis (Spotfire ColumnAxis)"
      type: field_filter
      default_value: "ts_domain"
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.column_axis_selector
      ui_config:
        type: dropdown_menu
        display: inline

    - name: items_count_selector
      title: "Items Count Metric (Spotfire ItemsCount)"
      type: field_filter
      default_value: "ts_id"
      explore: sdv_tc_runs_foundation
      field: sdv_tc_runs.items_count_selector
      ui_config:
        type: dropdown_menu
        display: inline

  elements:
    # --------------------------------------------------------------------------
    # TAB 1: TC LAST RUNS Results (Spotfire Page 1)
    # --------------------------------------------------------------------------
    - name: kpi_last_run_total_tc
      title: "Last Run — Total TCs"
      tab_name: tab_1_tc_last_runs_results
      type: single_value
      explore: sdv_tc_runs_foundation
      fields: [sdv_tc_runs.last_run_total_tc_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 0
      width: 6
      height: 3

    - name: kpi_last_run_pass_rate
      title: "Last Run — Pass Rate (%)"
      tab_name: tab_1_tc_last_runs_results
      type: single_value
      explore: sdv_tc_runs_foundation
      fields: [sdv_tc_runs.last_run_pass_rate]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 6
      width: 6
      height: 3

    - name: kpi_last_run_failed_tc
      title: "Last Run — Failed TCs"
      tab_name: tab_1_tc_last_runs_results
      type: single_value
      explore: sdv_tc_runs_foundation
      fields: [sdv_tc_runs.last_run_failed_tc_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 12
      width: 6
      height: 3

    - name: kpi_last_run_blocked_tc
      title: "Last Run — Blocked TCs"
      tab_name: tab_1_tc_last_runs_results
      type: single_value
      explore: sdv_tc_runs_foundation
      fields: [sdv_tc_runs.last_run_blocked_tc_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 18
      width: 6
      height: 3

    - name: last_runs_results_bar
      title: "LAST Runs Results (by Dynamic Axis)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.dynamic_horizontal_axis]
      measures: [
        sdv_tc_runs.last_run_passed_tc_count,
        sdv_tc_runs.last_run_failed_tc_count,
        sdv_tc_runs.last_run_blocked_tc_count,
        sdv_tc_runs.last_run_not_executed_tc_count
      ]
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
        horizontal_axis_selector: sdv_tc_runs.tr_horizontal_axis_selector
      row: 3
      col: 0
      width: 12
      height: 8

    - name: last_runs_results_pie
      title: "LAST Runs Results (Share by Status)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_pie
      explore: sdv_tc_runs_foundation
      dimensions: [fact_tc_dynamic_last_run.last_run_result]
      measures: [sdv_tc_runs.last_run_total_tc_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 3
      col: 12
      width: 6
      height: 8

    - name: last_run_week_bar
      title: "Last Run Week Evolution"
      tab_name: tab_1_tc_last_runs_results
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [fact_tc_dynamic_last_run.last_run_week, fact_tc_dynamic_last_run.last_run_result]
      pivots: [fact_tc_dynamic_last_run.last_run_result]
      measures: [sdv_tc_runs.last_run_total_tc_count]
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 3
      col: 18
      width: 6
      height: 8

    - name: last_runs_detailed_view_grid
      title: "LAST Runs Results - Detailed View (Cross-Filtered Details-on-Demand)"
      tab_name: tab_1_tc_last_runs_results
      type: looker_grid
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs.tc_id,
        sdv_tc_runs.tc_name,
        sdv_tc_runs.tc_domain,
        sdv_tc_runs.tc_brand_display,
        sdv_tc_runs.ts_id,
        sdv_tc_runs.ts_name,
        sdv_tc_runs.ts_vehicle_project,
        sdv_tc_runs.milestone,
        fact_tc_dynamic_last_run.last_run_tr_id,
        fact_tc_dynamic_last_run.last_run_result,
        fact_tc_dynamic_last_run.last_run_week
      ]
      measures: [sdv_tc_runs.failed_last_run_issues_list]
      filters:
        fact_tc_dynamic_last_run.is_dynamic_last_run: "yes"
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 11
      col: 0
      width: 24
      height: 8

    # --------------------------------------------------------------------------
    # TAB 2: TC ALL & First Runs (Spotfire Pages 2 & 3)
    # --------------------------------------------------------------------------
    - name: kpi_all_runs_count
      title: "All Executed Runs (TR)"
      tab_name: tab_2_tc_all_and_first_runs
      type: single_value
      explore: sdv_tc_runs_foundation
      fields: [sdv_tc_runs.executed_tr_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 0
      width: 8
      height: 3

    - name: kpi_first_run_total_tc
      title: "First Run — Total TCs"
      tab_name: tab_2_tc_all_and_first_runs
      type: single_value
      explore: sdv_tc_runs_foundation
      fields: [sdv_tc_runs.first_run_total_tc_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 8
      width: 8
      height: 3

    - name: kpi_first_run_pass_rate
      title: "First Run — Right-First-Time Rate (%)"
      tab_name: tab_2_tc_all_and_first_runs
      type: single_value
      explore: sdv_tc_runs_foundation
      fields: [sdv_tc_runs.first_run_pass_rate]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 16
      width: 8
      height: 3

    - name: all_runs_week_bar
      title: "All Runs per Week (Page 2)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tr_run_week, sdv_tc_runs.tr_result]
      pivots: [sdv_tc_runs.tr_result]
      measures: [sdv_tc_runs.unique_tr_count]
      filters:
        sdv_tc_runs.is_executed_run: "yes"
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 3
      col: 0
      width: 9
      height: 8

    - name: first_runs_week_bar
      title: "First Runs per Week (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tr_run_week, sdv_tc_runs.tr_result]
      pivots: [sdv_tc_runs.tr_result]
      measures: [sdv_tc_runs.unique_tc_count]
      filters:
        sdv_tc_runs.is_first_run: "yes"
        sdv_tc_runs.is_executed_run: "yes"
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 3
      col: 9
      width: 9
      height: 8

    - name: first_runs_pie
      title: "First Runs Breakdown (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_pie
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tr_result]
      measures: [sdv_tc_runs.unique_tc_count]
      filters:
        sdv_tc_runs.is_first_run: "yes"
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 3
      col: 18
      width: 6
      height: 8

    - name: all_runs_detailed_view_grid
      title: "ALL Runs Results - Detailed View (Page 2)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_grid
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs.tr_id,
        sdv_tc_runs.tc_id,
        sdv_tc_runs.tc_name,
        sdv_tc_runs.ts_id,
        sdv_tc_runs.ts_name,
        sdv_tc_runs.tr_result,
        sdv_tc_runs.tr_run_date_date,
        sdv_tc_runs.tr_regression,
        sdv_tc_runs.issue_id
      ]
      filters:
        sdv_tc_runs.is_executed_run: "yes"
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 11
      col: 0
      width: 12
      height: 8

    - name: first_runs_detailed_view_grid
      title: "First Runs Results - Detailed View (Page 3)"
      tab_name: tab_2_tc_all_and_first_runs
      type: looker_grid
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs.tc_id,
        sdv_tc_runs.tc_name,
        sdv_tc_runs.tr_id,
        sdv_tc_runs.tr_result,
        sdv_tc_runs.tr_run_week,
        sdv_tc_runs.tr_run_date_date
      ]
      filters:
        sdv_tc_runs.is_first_run: "yes"
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 11
      col: 12
      width: 12
      height: 8

    # --------------------------------------------------------------------------
    # TAB 3: Automation & Runs (Spotfire Page 4)
    # --------------------------------------------------------------------------
    - name: kpi_tc_with_auto_request
      title: "TCs with an Automation Request"
      tab_name: tab_3_automation_and_runs
      type: single_value
      explore: sdv_tc_runs_foundation
      fields: [sdv_tc_runs.tc_with_automation_request_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
      row: 0
      col: 0
      width: 6
      height: 3

    - name: auto_req_in_ts_bar
      title: "TC with an Auto Request in a TS or not"
      tab_name: tab_3_automation_and_runs
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.auto_ts_runs, sdv_tc_runs.automation_status]
      pivots: [sdv_tc_runs.automation_status]
      measures: [sdv_tc_runs.unique_tc_count]
      filters:
        sdv_tc_runs.has_automation_request: "yes"
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
      row: 0
      col: 6
      width: 18
      height: 6

    - name: auto_req_last_runs_bar
      title: "LAST Runs Results for TC with an Auto Request"
      tab_name: tab_3_automation_and_runs
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tc_domain]
      measures: [
        sdv_tc_runs.last_run_passed_tc_count,
        sdv_tc_runs.last_run_failed_tc_count,
        sdv_tc_runs.last_run_blocked_tc_count,
        sdv_tc_runs.last_run_not_executed_tc_count
      ]
      filters:
        sdv_tc_runs.has_automation_request: "yes"
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
      row: 6
      col: 0
      width: 12
      height: 7

    - name: manual_auto_runs_per_week_bar
      title: "Nb of Manual / Automatics runs per week"
      tab_name: tab_3_automation_and_runs
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tr_run_week, sdv_tc_runs.tc_type]
      pivots: [sdv_tc_runs.tc_type]
      measures: [sdv_tc_runs.unique_tr_count]
      filters:
        sdv_tc_runs.is_executed_run: "yes"
      stacking: normal
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
      row: 6
      col: 12
      width: 12
      height: 7

    - name: auto_requests_detailed_view_grid
      title: "Automation Requests - Detailed View"
      tab_name: tab_3_automation_and_runs
      type: looker_grid
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs.tc_id,
        sdv_tc_runs.tc_name,
        sdv_tc_runs.automation_id,
        sdv_tc_runs.automation_name,
        sdv_tc_runs.automation_status,
        sdv_tc_runs.automation_bench_type,
        sdv_tc_runs.automation_framework,
        sdv_tc_runs.automation_reference_ticket,
        sdv_tc_runs.auto_ts_runs,
        sdv_tc_runs.tc_type,
        sdv_tc_runs.tc_domain
      ]
      filters:
        sdv_tc_runs.has_automation_request: "yes"
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        tc_in_ts_only: sdv_tc_runs.tc_in_ts_only_scope
      row: 13
      col: 0
      width: 24
      height: 8

    # --------------------------------------------------------------------------
    # TAB 4: QUALITY 1/3 & 2/3 (Spotfire Pages 5 & 6 — Issues & TS Readiness)
    # --------------------------------------------------------------------------
    - name: quality_1_no_issue_bar
      title: "Quality 1/3 — Failed / Blocked Not Linked to an Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tc_domain]
      measures: [sdv_tc_runs.failed_blocked_without_issue_tc_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 0
      width: 8
      height: 8

    - name: quality_1_closed_issue_bar
      title: "Quality 1/3 — Failed / Blocked Linked to Closed Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tc_domain]
      measures: [sdv_tc_runs.failed_blocked_closed_issue_tc_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 8
      width: 8
      height: 8

    - name: quality_1_derogated_issue_bar
      title: "Quality 1/3 — Failed / Blocked Linked to Derogated Issue"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tc_domain]
      measures: [sdv_tc_runs.failed_blocked_derogated_issue_tc_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 0
      col: 16
      width: 8
      height: 8

    - name: quality_1_detailed_view_grid
      title: "Quality 1/3 — Failed / Blocked & Issue Linkage Detailed View"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_grid
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs.tc_id,
        sdv_tc_runs.tc_name,
        sdv_tc_runs.tc_domain,
        fact_tc_dynamic_last_run.last_run_tr_id,
        fact_tc_dynamic_last_run.last_run_result,
        sdv_tc_runs.qua_tr_without_issues,
        sdv_tc_runs.issue_id,
        sdv_tc_runs.issue_status,
        sdv_tc_runs.issue_criticity,
        sdv_tc_runs.issue_resolution,
        sdv_tc_runs.issue_fix_version,
        sdv_tc_runs.issue_summary
      ]
      filters:
        fact_tc_dynamic_last_run.is_dynamic_last_run: "yes"
        fact_tc_dynamic_last_run.last_run_result: "Failed, Blocked"
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 8
      col: 0
      width: 24
      height: 8

    - name: quality_2_tc_not_in_ts_bar
      title: "Quality 2/3 — TC Not in a TS"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tc_domain]
      measures: [sdv_tc_runs.tc_not_in_ts_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 16
      col: 0
      width: 12
      height: 8

    - name: quality_2_tc_not_ready_bar
      title: "Quality 2/3 — TC Not Ready in a TS"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_column
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.tc_domain]
      measures: [sdv_tc_runs.tc_not_ready_in_ts_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 16
      col: 12
      width: 12
      height: 8

    - name: quality_2_detailed_view_grid
      title: "Quality 2/3 — TC Not in a TS / Not Ready Detailed View"
      tab_name: tab_4_quality_issues_and_readiness
      type: looker_grid
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs.tc_id,
        sdv_tc_runs.tc_name,
        sdv_tc_runs.tc_status,
        sdv_tc_runs.tc_domain,
        sdv_tc_runs.ts_id,
        sdv_tc_runs.ts_name,
        sdv_tc_runs.qua_tc_in_ts,
        sdv_tc_runs.qua_tc_not_ready
      ]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        accepted_only: sdv_tc_runs.accepted_only_scope
        exclude_backlog_descoped: sdv_tc_runs.exclude_backlog_descoped_scope
      row: 24
      col: 0
      width: 24
      height: 8

    # --------------------------------------------------------------------------
    # TAB 5: QUALITY 3/3 (Spotfire Page 7 — Dynamic CrossTable & All Data)
    # --------------------------------------------------------------------------
    - name: quality_3_dynamic_crosstable
      title: "Quality 3/3 — Dynamic CrossTable (RowsAxis x ColumnAxis x ItemsCount)"
      tab_name: tab_5_quality_crosstable_all_data
      type: looker_grid
      explore: sdv_tc_runs_foundation
      dimensions: [sdv_tc_runs.dynamic_rows_axis, sdv_tc_runs.dynamic_column_axis]
      pivots: [sdv_tc_runs.dynamic_column_axis]
      measures: [sdv_tc_runs.dynamic_items_unique_count]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
        rows_axis_selector: sdv_tc_runs.rows_axis_selector
        column_axis_selector: sdv_tc_runs.column_axis_selector
        items_count_selector: sdv_tc_runs.items_count_selector
      row: 0
      col: 0
      width: 24
      height: 8

    - name: quality_3_all_data_grid
      title: "All Data - Detailed View"
      tab_name: tab_5_quality_crosstable_all_data
      type: looker_grid
      explore: sdv_tc_runs_foundation
      dimensions: [
        sdv_tc_runs.req_id,
        sdv_tc_runs.req_name,
        sdv_tc_runs.req_baseline,
        sdv_tc_runs.req_mysf,
        sdv_tc_runs.req_asil,
        sdv_tc_runs.tc_id,
        sdv_tc_runs.tc_name,
        sdv_tc_runs.tc_status,
        sdv_tc_runs.tc_domain,
        sdv_tc_runs.tc_brand_display,
        sdv_tc_runs.ts_id,
        sdv_tc_runs.ts_name,
        sdv_tc_runs.ts_vehicle_project,
        sdv_tc_runs.valid_baseline,
        sdv_tc_runs.milestone,
        sdv_tc_runs.tr_id,
        sdv_tc_runs.tr_result,
        sdv_tc_runs.tr_run_date_date,
        sdv_tc_runs.tr_run_week,
        sdv_tc_runs.issue_id,
        sdv_tc_runs.issue_status,
        sdv_tc_runs.issue_criticity,
        sdv_tc_runs.automation_id,
        sdv_tc_runs.task_id,
        sdv_tc_runs.partition_week_int
      ]
      listen:
        vehicle_project: sdv_tc_runs.ts_vehicle_project
        tc_domain: sdv_tc_runs.tc_domain
        milestone: sdv_tc_runs.milestone
        valid_baseline: sdv_tc_runs.valid_baseline
        req_mysf: sdv_tc_runs.req_mysf
        tc_brand_filter: sdv_tc_runs.tc_brand_filter
      row: 8
      col: 0
      width: 24
      height: 10
