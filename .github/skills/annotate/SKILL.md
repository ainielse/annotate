---
name: annotate
description: 'Generate Oracle 26ai table and column annotation scripts. Use when: annotate tables, create annotations, add annotations, generate annotations, inspect data model, annotation scripts, display_label, ai_context, semantic_type, search_facet, format_mask, primary_display_column. Supports batch processing with wildcard patterns (e.g., HEALTH%, EMP, DEPT). Can enrich annotations from APEX UI Defaults or APEX Application inspection.'
argument-hint: 'Table name(s) or patterns, e.g.: HEALTH_PATIENTS or EMP, DEPT, HEALTH%'
---

# Oracle 26ai Annotation Generator

Generate `display_label`, `format_mask`, `primary_display_column`, `search_facet`, `semantic_type`, and `ai_context` annotations for Oracle 26ai tables by inspecting the data model and optionally APEX metadata.

**Prerequisites:** SQLcl MCP server must be available and connected to the target database.

## Procedure

### Step 0 — Parse Input & Configure

1. Parse the user's input for one or more table patterns separated by commas (e.g., `EMP, DEPT, HEALTH%`).
2. Wildcards use SQL `LIKE` syntax: `%` for multi-char, `_` for single-char.
3. Connect to the database via SQLcl MCP:
   - Use `list-connections` to show available connections.
   - Ask the user which connection to use (present the list).
   - Use `connect` with the chosen connection name.
4. Resolve each pattern:

```sql
SELECT table_name FROM user_tables WHERE table_name LIKE '<PATTERN>' ORDER BY 1;
```

5. Combine results, deduplicate, and confirm the resolved table list with the user.
6. Ask the user which context source to use:
   - **None** — data model inspection only
   - **UI Defaults** — also query APEX UI Defaults views
   - **APEX Application** — also inspect an APEX application (ask for Application ID)

### Step 1 — For Each Table, Gather Context

#### 1a. Core Data Model Inspection (always)

Run these queries for every table:

```sql
-- Column structure
SELECT column_name, data_type, data_length, data_precision, data_scale, nullable, column_id
  FROM user_tab_columns WHERE table_name = '<TABLE>' ORDER BY column_id;

-- Constraints (PKs, FKs, unique)
SELECT c.constraint_name, c.constraint_type, cc.column_name, c.r_constraint_name
  FROM user_constraints c
  JOIN user_cons_columns cc ON c.constraint_name = cc.constraint_name
 WHERE c.table_name = '<TABLE>' ORDER BY c.constraint_type, cc.position;

-- Sample data (10 rows)
SELECT * FROM <TABLE> FETCH FIRST 10 ROWS ONLY;

-- Row count
SELECT COUNT(*) AS total_rows FROM <TABLE>;

-- Distinct value counts for string columns (to identify search_facet candidates)
-- For each VARCHAR2 column:
SELECT '<COLUMN>' AS col, COUNT(DISTINCT <COLUMN>) AS distinct_count FROM <TABLE>;
-- Or combine into a single query for efficiency.

-- Existing comments
SELECT comments FROM user_tab_comments WHERE table_name = '<TABLE>';
SELECT column_name, comments FROM user_col_comments WHERE table_name = '<TABLE>' ORDER BY column_name;

-- Existing annotations (Oracle 26ai) — WARN USER IF FOUND
SELECT annotation_name, annotation_value FROM user_annotations WHERE object_name = '<TABLE>' AND object_type = 'TABLE';
SELECT column_name, annotation_name, annotation_value FROM user_annotations WHERE object_name = '<TABLE>' AND object_type = 'COLUMN' ORDER BY column_name;
```

If existing annotations are found, **warn the user** and list them. Ask whether to:
- **Skip** columns/tables that already have annotations
- **Overwrite** existing annotations
- **Merge** (only add missing annotation types, keep existing values)

#### 1b. APEX UI Defaults (if user chose "UI Defaults")

See [apex-views.md](./references/apex-views.md) for full query details and column mappings.

```sql
-- Table-level
SELECT table_name, form_region_title, report_region_title
  FROM apex_ui_defaults_tables WHERE table_name = '<TABLE>';

-- Column-level
SELECT column_name, label, help_text, mask_form, mask_report,
       display_in_form, display_in_report, required, alignment,
       group_name, lov_query
  FROM apex_ui_defaults_columns WHERE table_name = '<TABLE>'
 ORDER BY display_seq_form;
```

If these views return ORA-00942 or no rows, log a note and proceed with data inference only.

#### 1c. APEX Application Inspection (if user chose "APEX Application")

See [apex-views.md](./references/apex-views.md) for full query details, column mappings, and error handling.

Query in this order:
1. `apex_application_page_regions` — find pages/regions using the table
2. `apex_application_page_items` — get item labels, format masks, help text, LOVs
3. `apex_appl_page_ig_columns` — get IG column headings, format masks
4. `apex_application_lovs` + `apex_application_lov_entries` — resolve LOV values
5. `apex_application_page_val` — get validation rules

If the table is not found in any page/region, warn the user and fall back to UI Defaults or data inference.

### Step 2 — Apply Decision Heuristics

For each column, determine the value for each annotation type using the priority rules below. Reference [annotation-types.md](./references/annotation-types.md) for detailed guidance on each type and [semantic-types.md](./references/semantic-types.md) for the semantic type catalog.

#### display_label
1. **APEX App**: page item `label` or IG column `heading`
2. **UI Defaults**: `label` from `apex_ui_defaults_columns`
3. **Fallback**: Convert column_name to Title Case. Expand abbreviations: `ID` stays `ID`, `DOB` → context-dependent.

#### format_mask
1. **APEX App**: page item `format_mask` or IG column `format_mask`
2. **UI Defaults**: `mask_form` or `mask_report`
3. **Fallback**: Infer from sample data patterns:
   - Phone `(###) ###-####` → `(###) ###-####`
   - DATE columns → `DD-MON-YY` (match observed format)
   - Year-only strings → `YYYY`
   - Currency → `FML999G999G999G990D00`
4. Only include if a meaningful format exists. Omit for plain text or numeric IDs.

#### primary_display_column
- Name columns (first_name, last_name, full_name) → `'true'`
- Title/description columns that identify the row → `'true'`
- Business-meaningful unique codes → `'true'`
- Limit to 1-3 columns per table
- Never set on surrogate PKs, audit columns, or technical columns

#### search_facet
1. **APEX App**: LOV-backed items → strong signal for `'true'`
2. **Data analysis**: columns with distinct count < ~50 relative to total rows → `'true'`
3. Status, type, category, geographic grouping columns → `'true'`
4. Boolean/flag columns → `'true'`
5. Never set on high-cardinality columns (names, emails, free text, numeric IDs)

#### semantic_type
- Match column name patterns and data characteristics against the [semantic types catalog](./references/semantic-types.md)
- Pick the most specific match
- Omit if no type fits

#### ai_context
1. **APEX App**: combine help_text + LOV values + validation rules + observed data patterns
2. **UI Defaults**: combine help_text + observed data patterns
3. **Fallback**: describe based on column type, sample data, constraints, and relationships
4. Always include: column purpose, data format/patterns, constraints (NOT NULL, FK)
5. For categorical columns: list all observed values
6. For derived columns: note derivation logic
7. Keep concise but comprehensive — this is the most important annotation for AI

### Step 3 — Generate Output Files

See [output-format.md](./references/output-format.md) for the exact file format, directory structure, and canonical examples.

For each table, create:
1. `annotations/<table_name_lowercase>/table_comment.sql` — table-level `display_label` and `ai_context`
2. `annotations/<table_name_lowercase>/column_comments.sql` — per-column annotations

### Step 4 — Report

After generating all files:
1. Show a summary table per table with columns: Column | display_label | format_mask | primary_display_column | search_facet | semantic_type | ai_context (truncated)
2. Note any columns where existing annotations were found and what action was taken
3. List all generated files
4. Ask the user if they want to execute the scripts against the database via SQLcl MCP
