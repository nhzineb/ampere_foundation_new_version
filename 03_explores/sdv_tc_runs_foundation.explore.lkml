# ==============================================================================
# LAYER 3: EXPLORE (03_explores/sdv_tc_runs_foundation.explore.lkml)
# Strictly no datagroups (per user instructions).
# ==============================================================================

include: "/00_adm/access_grants/access_grants.lkml"
include: "/01_views/sources/sdv_tc_runs.view.lkml"
include: "/01_views/refinements/+sdv_tc_runs.view.lkml"
include: "/01_views/derived_tables/fact_tc_dynamic_last_run.view.lkml"

explore: sdv_tc_runs_foundation {
  label: "SDV TC Runs — Foundation (Spotfire Migration)"
  description: "Governed Looker Explore replacing Spotfire SDV_TC_Runs__Foundation (2).dxp on the final 105-column BigQuery table."
  view_name: sdv_tc_runs

  # Row-Level Security (Multi-value String Filter (advanced) user attribute)
  access_filter: {
    field: sdv_tc_runs.tc_domain
    user_attribute: allowed_sdv_domains
  }

  # Dynamic Last-Run Deduplication View (Replaces Rank([Admin_Rank],[TC_Id])=1)
  join: fact_tc_dynamic_last_run {
    view_label: "Dynamic Last Run (Rank=1)"
    type: left_outer
    relationship: many_to_one
    sql_on: ${sdv_tc_runs.tc_id} = ${fact_tc_dynamic_last_run.tc_id}
      AND ${sdv_tc_runs.tr_id} = ${fact_tc_dynamic_last_run.last_run_tr_id} ;;
  }
}
