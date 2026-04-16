-- View annotations for HEALTH_STATUS_IMPACT_V
alter view health_status_impact_v annotations (display_label 'Health Status Impacts');
alter view health_status_impact_v annotations (ai_context 'Flattened view of patient-reported health impacts from status updates. Each row represents one impact entry extracted via JSON_TABLE from the IMPACT JSON array in HEALTH_STATUS_UPDATES. Joins to HEALTH_STATUS_UPDATES on STATUS_UPDATE_ID.');
