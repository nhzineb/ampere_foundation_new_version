# ==============================================================================
# PROJECT MANIFEST (manifest.lkml)
# Central constants for Ampere SDV IVV Spotfire-to-Looker Migration
# ==============================================================================

project_name: "ampere-sdv-tc-runs-foundation"

constant: CONNECTION_NAME {
  value: "default_bigquery_connection"
  export: override_optional
}

constant: GCP_PROJECT {
  value: "zineb-sandbox"
  export: override_optional
}

constant: DATASET_NAME {
  value: "ampere_sdv_ivv"
  export: override_optional
}

constant: TABLE_NAME {
  value: "TBL_from_VW_CB_SDV_Spotfire_New_TC_Runs"
  export: override_optional
}
