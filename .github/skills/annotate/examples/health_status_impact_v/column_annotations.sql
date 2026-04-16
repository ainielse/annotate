-- Column annotations for HEALTH_STATUS_IMPACT_V

-- PATIENT_ID
alter view health_status_impact_v modify (patient_id annotations (display_label 'Patient ID'));
alter view health_status_impact_v modify (patient_id annotations (semantic_type 'identifier'));
alter view health_status_impact_v modify (patient_id annotations (ai_context 'Foreign key to HEALTH_PATIENTS. Identifies the patient who reported the impact. NOT NULL.'));

-- STATUS_UPDATE_ID
alter view health_status_impact_v modify (status_update_id annotations (display_label 'Status Update ID'));
alter view health_status_impact_v modify (status_update_id annotations (semantic_type 'identifier'));
alter view health_status_impact_v modify (status_update_id annotations (ai_context 'Foreign key to HEALTH_STATUS_UPDATES. Identifies the status update containing this impact. NOT NULL.'));

-- DATE_PROVIDED
alter view health_status_impact_v modify (date_provided annotations (display_label 'Date Provided'));
alter view health_status_impact_v modify (date_provided annotations (format_mask 'DD-MON-YY'));
alter view health_status_impact_v modify (date_provided annotations (semantic_type 'date'));
alter view health_status_impact_v modify (date_provided annotations (ai_context 'Date the patient provided the status update containing this impact.'));

-- IMPACT
alter view health_status_impact_v modify (impact annotations (display_label 'Impact'));
alter view health_status_impact_v modify (impact annotations (search_facet 'true'));
alter view health_status_impact_v modify (impact annotations (primary_display_column 'true'));
alter view health_status_impact_v modify (impact annotations (ai_context 'Self-reported health impact description extracted from JSON array. Values: Be unable to work, Be unable to do normal activities, Be unable to get care from a healthcare professional.'));
