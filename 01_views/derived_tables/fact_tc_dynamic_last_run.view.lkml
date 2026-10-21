# ==============================================================================
# DYNAMIC LAST-RUN DEDUPLICATION VIEW (01_views/derived_tables/fact_tc_dynamic_last_run.view.lkml)
# Replaces Spotfire Rank([Admin_Rank], [TC_Id]) = 1 across active filter slices.
# Uses BigQuery QUALIFY ROW_NUMBER() OVER (PARTITION BY TC_Id ORDER BY Admin_Rank ASC, TR_RunDate DESC) = 1
# with Liquid {% condition %} pushdown for all active dashboard filters.
# ==============================================================================

view: fact_tc_dynamic_last_run {
  derived_table: {
    sql:
      SELECT
        TC_Id,
        TR_Id AS last_run_tr_id,
        TS_Id AS last_run_ts_id,
        TR_Result AS last_run_result,
        TR_RunDate AS last_run_date,
        TR_RunWeek AS last_run_week,
        Admin_Rank AS last_run_admin_rank,
        TRUE AS is_dynamic_last_run
      FROM `@{GCP_PROJECT}.@{DATASET_NAME}.@{TABLE_NAME}`
      WHERE TC_Id IS NOT NULL
        AND {% condition sdv_tc_runs.tr_run_date_date %} TR_RunDate {% endcondition %}
        AND {% condition sdv_tc_runs.tr_run_week %} TR_RunWeek {% endcondition %}
        AND {% condition sdv_tc_runs.ts_vehicle_project %} TS_Vehicle_Project {% endcondition %}
        AND {% condition sdv_tc_runs.tc_domain %} TC_Domain {% endcondition %}
        AND {% condition sdv_tc_runs.ts_domain %} TS_Domain {% endcondition %}
        AND {% condition sdv_tc_runs.milestone %} Milestone {% endcondition %}
        AND {% condition sdv_tc_runs.valid_baseline %} Valid_Baseline {% endcondition %}
        AND {% condition sdv_tc_runs.ts_baseline %} TS_Baseline {% endcondition %}
        AND {% condition sdv_tc_runs.req_baseline %} Req_Baseline {% endcondition %}
        AND {% condition sdv_tc_runs.req_mysf %} Req_MySF {% endcondition %}
        AND {% condition sdv_tc_runs.tc_validation_team %} TC_Validation_Team {% endcondition %}
        AND {% condition sdv_tc_runs.partition_week_int %} Partition_week_int {% endcondition %}
      QUALIFY ROW_NUMBER() OVER (
        PARTITION BY TC_Id
        ORDER BY
          COALESCE(Admin_Rank, 999999999) ASC,
          COALESCE(TR_RunDate, DATETIME('0001-01-01 00:00:00')) DESC,
          TR_Id DESC
      ) = 1 ;;
  }

  dimension: tc_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.TC_Id ;;
  }

  dimension: last_run_tr_id {
    label: "Dynamic Last Run TR ID"
    type: number
    sql: ${TABLE}.last_run_tr_id ;;
  }

  dimension: last_run_ts_id {
    label: "Dynamic Last Run TS ID"
    type: number
    sql: ${TABLE}.last_run_ts_id ;;
  }

  dimension: last_run_result {
    label: "Dynamic Last Run Result"
    type: string
    sql: ${TABLE}.last_run_result ;;
  }

  dimension_group: last_run_date {
    label: "Dynamic Last Run"
    type: time
    datatype: datetime
    timeframes: [raw, date, week, month, year]
    sql: ${TABLE}.last_run_date ;;
  }

  dimension: last_run_week {
    label: "Dynamic Last Run Week"
    type: string
    sql: ${TABLE}.last_run_week ;;
  }

  dimension: last_run_admin_rank {
    label: "Dynamic Last Run Admin Rank"
    type: number
    sql: ${TABLE}.last_run_admin_rank ;;
  }

  dimension: is_dynamic_last_run {
    label: "Is Dynamic Last Run (Rank=1)"
    description: "True when this row belongs to the #1 ranked run per TC_Id (Rank([Admin_Rank],[TC_Id])=1) within the active filter slice."
    type: yesno
    sql: COALESCE(${TABLE}.is_dynamic_last_run, FALSE) ;;
  }
}
