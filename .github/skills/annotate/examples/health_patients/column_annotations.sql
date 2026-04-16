-- Column annotations for HEALTH_PATIENTS

-- PATIENT_ID
alter table health_patients modify patient_id annotations (display_label 'Patient ID');
alter table health_patients modify patient_id annotations (semantic_type 'identifier');
alter table health_patients modify patient_id annotations (ai_context 'Unique numeric identifier for each patient. Primary key, NOT NULL.');

-- FIRST_NAME
alter table health_patients modify first_name annotations (display_label 'First Name');
alter table health_patients modify first_name annotations (primary_display_column 'true');
alter table health_patients modify first_name annotations (semantic_type 'person_name');
alter table health_patients modify first_name annotations (ai_context 'Patient first name in mixed case. NOT NULL.');

-- LAST_NAME
alter table health_patients modify last_name annotations (display_label 'Last Name');
alter table health_patients modify last_name annotations (primary_display_column 'true');
alter table health_patients modify last_name annotations (semantic_type 'person_name');
alter table health_patients modify last_name annotations (ai_context 'Patient last name in mixed case. NOT NULL.');

-- UPPER_FIRST
alter table health_patients modify upper_first annotations (display_label 'Upper First');
alter table health_patients modify upper_first annotations (ai_context 'Patient first name stored in uppercase for case-insensitive lookups. Derived from FIRST_NAME.');

-- UPPER_LAST
alter table health_patients modify upper_last annotations (display_label 'Upper Last');
alter table health_patients modify upper_last annotations (ai_context 'Patient last name stored in uppercase for case-insensitive lookups. Derived from LAST_NAME.');

-- CELL_PHONE
alter table health_patients modify cell_phone annotations (display_label 'Cell Phone');
alter table health_patients modify cell_phone annotations (format_mask '(###) ###-####');
alter table health_patients modify cell_phone annotations (semantic_type 'phone_number');
alter table health_patients modify cell_phone annotations (ai_context 'Patient cell phone number in (###) ###-#### format.');

-- EMAIL_ADDRESS
alter table health_patients modify email_address annotations (display_label 'Personal Email Address');
alter table health_patients modify email_address annotations (semantic_type 'email');
alter table health_patients modify email_address annotations (ai_context 'Patient personal email address in Firstname.Lastname@internalmail format.');

-- CITY
alter table health_patients modify city annotations (display_label 'City');
alter table health_patients modify city annotations (search_facet 'true');
alter table health_patients modify city annotations (semantic_type 'city');
alter table health_patients modify city annotations (ai_context 'City of the patient residence.');

-- LONGITUDE
alter table health_patients modify longitude annotations (display_label 'Longitude');
alter table health_patients modify longitude annotations (semantic_type 'longitude');
alter table health_patients modify longitude annotations (ai_context 'Geographic longitude coordinate of the patient location.');

-- LATITUDE
alter table health_patients modify latitude annotations (display_label 'Latitude');
alter table health_patients modify latitude annotations (semantic_type 'latitude');
alter table health_patients modify latitude annotations (ai_context 'Geographic latitude coordinate of the patient location.');

-- STATE
alter table health_patients modify state annotations (display_label 'State');
alter table health_patients modify state annotations (search_facet 'true');
alter table health_patients modify state annotations (semantic_type 'state');
alter table health_patients modify state annotations (ai_context 'US state name (full name, not abbreviation) of the patient residence.');

-- POSTAL_CODE
alter table health_patients modify postal_code annotations (display_label 'Postal Code');
alter table health_patients modify postal_code annotations (search_facet 'true');
alter table health_patients modify postal_code annotations (semantic_type 'postal_code');
alter table health_patients modify postal_code annotations (ai_context 'US postal (ZIP) code of the patient residence, stored as VARCHAR2.');

-- COUNTY
alter table health_patients modify county annotations (display_label 'County');
alter table health_patients modify county annotations (search_facet 'true');
alter table health_patients modify county annotations (semantic_type 'county');
alter table health_patients modify county annotations (ai_context 'County name within the state of the patient residence.');

-- SEX
alter table health_patients modify sex annotations (display_label 'Sex');
alter table health_patients modify sex annotations (search_facet 'true');
alter table health_patients modify sex annotations (semantic_type 'gender');
alter table health_patients modify sex annotations (ai_context 'Patient biological sex. Values: Female, Male.');

-- DOB
alter table health_patients modify dob annotations (display_label 'Date of Birth');
alter table health_patients modify dob annotations (format_mask 'DD-MON-YYYY');
alter table health_patients modify dob annotations (semantic_type 'date_of_birth');
alter table health_patients modify dob annotations (ai_context 'Patient date of birth.');

-- YEAR_OF_BIRTH
alter table health_patients modify year_of_birth annotations (display_label 'Year of Birth');
alter table health_patients modify year_of_birth annotations (search_facet 'true');
alter table health_patients modify year_of_birth annotations (format_mask 'YYYY');
alter table health_patients modify year_of_birth annotations (ai_context 'Four-digit year extracted from date of birth, stored as VARCHAR2.');

-- LAST_FEELING
alter table health_patients modify last_feeling annotations (display_label 'Last Feeling');
alter table health_patients modify last_feeling annotations (search_facet 'true');
alter table health_patients modify last_feeling annotations (semantic_type 'health_status');
alter table health_patients modify last_feeling annotations (ai_context 'Patient self-reported health feeling at last status update. Values: Good, Fair, Poor.');

-- LAST_STATUS_UPDATE
alter table health_patients modify last_status_update annotations (display_label 'Last Status Update');
alter table health_patients modify last_status_update annotations (format_mask 'DD-MON-YYYY');
alter table health_patients modify last_status_update annotations (ai_context 'Date of the most recent patient status/feeling update.');

-- CREATED
alter table health_patients modify created annotations (display_label 'Created');
alter table health_patients modify created annotations (format_mask 'DD-MON-YYYY');
alter table health_patients modify created annotations (ai_context 'Date the patient record was created in the system.');
