# Output Format Reference

## Directory Structure

Each table gets its own directory under `annotations/`:

```
annotations/
├── health_patients/
│   ├── table_comment.sql
│   └── column_comments.sql
├── employees/
│   ├── table_comment.sql
│   └── column_comments.sql
└── departments/
    ├── table_comment.sql
    └── column_comments.sql
```

- Directory name: **lowercase** version of the table name
- Two files per table: `table_comment.sql` and `column_comments.sql`

## SQL Syntax

Oracle 26ai annotation syntax (not the `ANNOTATIONS (ADD ...)` DDL form):

### Table-level annotations

```sql
-- Table annotation for <TABLE_NAME>
-- APEX UI Defaults: form_region_title = '<value>', report_region_title = '<value>'
alter table <table_name> annotation display_label '<value>';
alter table <table_name> annotation ai_context '<value>';
```

- Include APEX UI Default titles as a comment if available
- Table name in SQL is **lowercase**

### Column-level annotations

```sql
-- Column annotations for <TABLE_NAME>

-- <COLUMN_NAME>
alter table <table_name> modify <column_name> annotation display_label '<value>';
alter table <table_name> modify <column_name> annotation format_mask '<value>';
alter table <table_name> modify <column_name> annotation primary_display_column 'true';
alter table <table_name> modify <column_name> annotation search_facet 'true';
alter table <table_name> modify <column_name> annotation semantic_type '<value>';
alter table <table_name> modify <column_name> annotation ai_context '<value>';
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
- [table_comment.sql](../examples/health_patients/table_comment.sql)
- [column_comments.sql](../examples/health_patients/column_comments.sql)
