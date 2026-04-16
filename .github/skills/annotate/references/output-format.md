# Output Format Reference

## Directory Structure

Each table gets its own directory under `annotations/`:

```
annotations/
├── health_patients/
│   ├── table_annotations.sql
│   └── column_annotations.sql
├── employees/
│   ├── table_annotations.sql
│   └── column_annotations.sql
└── departments/
    ├── table_annotations.sql
    └── column_annotations.sql
```

- Directory name: **lowercase** version of the table name
- Two files per table: `table_annotations.sql` and `column_annotations.sql`

## SQL Syntax

Oracle 26ai annotation syntax (not the `ANNOTATIONS (ADD ...)` DDL form):

### Table-level annotations

```sql
-- Table annotations for <TABLE_NAME>
-- APEX UI Defaults: form_region_title = '<value>', report_region_title = '<value>'
alter table <table_name> annotations (display_label '<value>');
alter table <table_name> annotations (ai_context '<value>');
```

- Include APEX UI Default titles as a comment if available
- Table name in SQL is **lowercase**

### Column-level annotations

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

**Formatting rules:**
- Table and column names in SQL are **lowercase**
- Each column is preceded by a `-- COLUMN_NAME` comment (uppercase) with a blank line before it
- Annotations are ordered consistently: `display_label`, `format_mask`, `primary_display_column`, `search_facet`, `semantic_type`, `ai_context`
- Only include annotations that have a value — omit annotations that don't apply to the column
- Every column MUST have at least `display_label` and `ai_context`
- String values are enclosed in single quotes
- No trailing blank line after the last column

## Canonical Example

See existing files for the canonical output format:
- [table_annotations.sql](../examples/health_patients/table_annotations.sql)
- [column_annotations.sql](../examples/health_patients/column_annotations.sql)
