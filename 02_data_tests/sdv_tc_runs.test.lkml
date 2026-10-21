# ==============================================================================
# AUTOMATED DATA TESTS (02_data_tests/sdv_tc_runs.test.lkml)
# Verifies composite primary key uniqueness on sdv_tc_runs_foundation
# ==============================================================================

test: sdv_tc_runs_pk_is_unique {
  explore_source: sdv_tc_runs_foundation {
    column: sdv_tc_runs_pk { field: sdv_tc_runs.sdv_tc_runs_pk }
    column: unique_tr_count { field: sdv_tc_runs.unique_tr_count }
    sorts: [sdv_tc_runs.unique_tr_count: desc]
    limit: 1
  }
  assert: pk_has_no_duplicate_runs {
    expression: ${sdv_tc_runs.unique_tr_count} <= 1 ;;
  }
}
