-- Table annotation for HEALTH_PATIENTS
-- APEX UI Defaults: form_region_title = 'Health Patient', report_region_title = 'Health Patients'
alter table health_patients annotation display_label 'Health Patients';
alter table health_patients annotation ai_context 'Patient demographic and contact information for the health system. Each row represents a unique patient with personal details, geographic location, and self-reported health status.';
