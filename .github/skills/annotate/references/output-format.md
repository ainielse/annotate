# Output Format Reference

## Directory Structure

Each table or view gets its own directory under `annotations/`:

```
annotations/
├── health_patients/
│   ├── table_annotations.sql
│   └── column_annotations.sql
├── employees/
│   ├── table_annotations.sql
│   └── column_annotations.sql
└── health_status_impact_v/
    ├── table_annotations.sql
    └── column_annotations.sql
```

- Directory name: **lowercase** version of the table/view name
- Two files per object: `table_annotations.sql` and `column_annotations.sql`

## SQL Syntax

Oracle 26ai annotation syntax (not the `ANNOTATIONS (ADD ...)` DDL form). Use `alter table` for tables and `alter view` for views.

### Object-level annotations (tables)

```sql
-- Table annotations for <TABLE_NAME>
-- APEX UI Defaults: form_region_title = '<value>', report_region_title = '<value>'
alter table <table_name> annotations (display_label '<value>');
alter table <table_name> annotations (ai_context '<value>');
```

### Object-level annotations (views)

```sql
-- View annotations for <VIEW_NAME>
alter view <view_name> annotations (display_label '<value>');
alter view <view_name> annotations (ai_context '<value>');
```

- Include APEX UI Default titles as a comment if available
- Object names in SQL are **lowercase**

### Column-level annotations (tables)

```sql
-- Column annotations for <TABLE_NAME>

-- <COLUMN_NAME>
alter table <table_name> modify <column_name> annotations (display_label '<value>');
alter table <table_name> modify <column_name> annotations (format_mask '<value>');
alter table <table_name> modify <column_name> annotations (primary_display_column 'true');
alter table <table_name> modify <column_name> annotations (search_facet 'true');
alter table <table_name> modify <column_name> annotations (semantic_type '<value>');
alter table <table_name> modify <column_name> annotations (ai_context '<value>');
```

### Column-level annotations (views)

**Note:** View column annotations require parentheses around the column specification:

```sql
-- Column annotations for <VIEW_NAME>

-- <COLUMN_NAME>
alter view <view_name> modify (<column_name> annotations (display_label '<value>'));
alter view <view_name> modify (<column_name> annotations (format_mask '<value>'));
alter view <view_name> modify (<column_name> annotations (primary_display_column 'true'));
alter view <view_name> modify (<column_name> annotations (search_facet 'true'));
alter view <view_name> modify (<column_name> annotations (semantic_type '<value>'));
alter view <view_name> modify (<column_name> annotations (ai_context '<value>'));
```

### Overwriting existing annotations (REPLACE keyword)

When the user chooses **Overwrite** for annotations that already exist on a table/view or column, use the `REPLACE` keyword inside the `annotations()` clause. Only use `REPLACE` for annotation names that already exist; new annotation names use the plain syntax.

**Table-level:**
```sql
alter table <table_name> annotations (REPLACE display_label '<new_value>');
alter view <view_name> annotations (REPLACE display_label '<new_value>');
```

**Column-level:**
```sql
alter table <table_name> modify <column_name> annotations (REPLACE display_label '<new_value>');
alter view <view_name> modify (<column_name> annotations (REPLACE display_label '<new_value>'));
```

**Formatting rules:**
- Table and column names in SQL are **lowercase**
- Each column is preceded by a `-- COLUMN_NAME` comment (uppercase) with a blank line before it
- Annotations are ordered consistently: `display_label`, `format_mask`, `primary_display_column`, `search_facet`, `semantic_type`, `ai_context`
- Only include annotations that have a value — omit annotations that don't apply to the column
- Every column MUST have at least `display_label` and `ai_context`
- String values are enclosed in single quotes
- No trailing blank line after the last column

## Canonical Examples

### Table example (HEALTH_PATIENTS)
- [table_annotations.sql](../examples/health_patients/table_annotations.sql)
- [column_annotations.sql](../examples/health_patients/column_annotations.sql)

### View example (HEALTH_STATUS_IMPACT_V)
- [table_annotations.sql](../examples/health_status_impact_v/table_annotations.sql)
- [column_annotations.sql](../examples/health_status_impact_v/column_annotations.sql)
