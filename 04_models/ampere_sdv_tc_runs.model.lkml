# ==============================================================================
# MODEL: 04_models/ampere_sdv_tc_runs.model.lkml
# Strictly no datagroups (per user instructions).
# ==============================================================================

connection: "@{CONNECTION_NAME}"
label: "Ampere SDV IVV — TC Runs Foundation"

include: "/03_explores/sdv_tc_runs_foundation.explore.lkml"
include: "/02_data_tests/sdv_tc_runs.test.lkml"
include: "/05_dashboards/sdv_tc_runs_foundation.dashboard.lookml"
