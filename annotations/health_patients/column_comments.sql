-- Column annotations for HEALTH_PATIENTS

-- PATIENT_ID
alter table health_patients modify patient_id annotation display_label 'Patient ID';
alter table health_patients modify patient_id annotation semantic_type 'identifier';
alter table health_patients modify patient_id annotation ai_context 'Unique numeric identifier for each patient. Primary key, NOT NULL.';

-- FIRST_NAME
alter table health_patients modify first_name annotation display_label 'First Name';
alter table health_patients modify first_name annotation primary_display_column 'true';
alter table health_patients modify first_name annotation semantic_type 'person_name';
alter table health_patients modify first_name annotation ai_context 'Patient first name in mixed case. NOT NULL.';

-- LAST_NAME
alter table health_patients modify last_name annotation display_label 'Last Name';
alter table health_patients modify last_name annotation primary_display_column 'true';
alter table health_patients modify last_name annotation semantic_type 'person_name';
alter table health_patients modify last_name annotation ai_context 'Patient last name in mixed case. NOT NULL.';

-- UPPER_FIRST
alter table health_patients modify upper_first annotation display_label 'Upper First';
alter table health_patients modify upper_first annotation ai_context 'Patient first name stored in uppercase for case-insensitive lookups. Derived from FIRST_NAME.';

-- UPPER_LAST
alter table health_patients modify upper_last annotation display_label 'Upper Last';
alter table health_patients modify upper_last annotation ai_context 'Patient last name stored in uppercase for case-insensitive lookups. Derived from LAST_NAME.';

-- CELL_PHONE
alter table health_patients modify cell_phone annotation display_label 'Cell Phone';
alter table health_patients modify cell_phone annotation format_mask '(###) ###-####';
alter table health_patients modify cell_phone annotation semantic_type 'phone_number';
alter table health_patients modify cell_phone annotation ai_context 'Patient cell phone number in (###) ###-#### format.';

-- EMAIL_ADDRESS
alter table health_patients modify email_address annotation display_label 'Personal Email Address';
alter table health_patients modify email_address annotation semantic_type 'email';
alter table health_patients modify email_address annotation ai_context 'Patient personal email address in Firstname.Lastname@internalmail format.';

-- CITY
alter table health_patients modify city annotation display_label 'City';
alter table health_patients modify city annotation search_facet 'true';
alter table health_patients modify city annotation semantic_type 'city';
alter table health_patients modify city annotation ai_context 'City of the patient residence.';

-- LONGITUDE
alter table health_patients modify longitude annotation display_label 'Longitude';
alter table health_patients modify longitude annotation semantic_type 'longitude';
alter table health_patients modify longitude annotation ai_context 'Geographic longitude coordinate of the patient location.';

-- LATITUDE
alter table health_patients modify latitude annotation display_label 'Latitude';
alter table health_patients modify latitude annotation semantic_type 'latitude';
alter table health_patients modify latitude annotation ai_context 'Geographic latitude coordinate of the patient location.';

-- STATE
alter table health_patients modify state annotation display_label 'State';
alter table health_patients modify state annotation search_facet 'true';
alter table health_patients modify state annotation semantic_type 'state';
alter table health_patients modify state annotation ai_context 'US state name (full name, not abbreviation) of the patient residence.';

-- POSTAL_CODE
alter table health_patients modify postal_code annotation display_label 'Postal Code';
alter table health_patients modify postal_code annotation search_facet 'true';
alter table health_patients modify postal_code annotation semantic_type 'postal_code';
alter table health_patients modify postal_code annotation ai_context 'US postal (ZIP) code of the patient residence, stored as VARCHAR2.';

-- COUNTY
alter table health_patients modify county annotation display_label 'County';
alter table health_patients modify county annotation search_facet 'true';
alter table health_patients modify county annotation semantic_type 'county';
alter table health_patients modify county annotation ai_context 'County name within the state of the patient residence.';

-- SEX
alter table health_patients modify sex annotation display_label 'Sex';
alter table health_patients modify sex annotation search_facet 'true';
alter table health_patients modify sex annotation semantic_type 'gender';
alter table health_patients modify sex annotation ai_context 'Patient biological sex. Values: Female, Male.';

-- DOB
alter table health_patients modify dob annotation display_label 'Date of Birth';
alter table health_patients modify dob annotation format_mask 'DD-MON-YYYY';
alter table health_patients modify dob annotation semantic_type 'date_of_birth';
alter table health_patients modify dob annotation ai_context 'Patient date of birth.';

-- YEAR_OF_BIRTH
alter table health_patients modify year_of_birth annotation display_label 'Year of Birth';
alter table health_patients modify year_of_birth annotation search_facet 'true';
alter table health_patients modify year_of_birth annotation format_mask 'YYYY';
alter table health_patients modify year_of_birth annotation ai_context 'Four-digit year extracted from date of birth, stored as VARCHAR2.';

-- LAST_FEELING
alter table health_patients modify last_feeling annotation display_label 'Last Feeling';
alter table health_patients modify last_feeling annotation search_facet 'true';
alter table health_patients modify last_feeling annotation semantic_type 'health_status';
alter table health_patients modify last_feeling annotation ai_context 'Patient self-reported health feeling at last status update. Values: Good, Fair, Poor.';

-- LAST_STATUS_UPDATE
alter table health_patients modify last_status_update annotation display_label 'Last Status Update';
alter table health_patients modify last_status_update annotation format_mask 'DD-MON-YYYY';
alter table health_patients modify last_status_update annotation ai_context 'Date of the most recent patient status/feeling update.';

-- CREATED
alter table health_patients modify created annotation display_label 'Created';
alter table health_patients modify created annotation format_mask 'DD-MON-YYYY';
alter table health_patients modify created annotation ai_context 'Date the patient record was created in the system.';
