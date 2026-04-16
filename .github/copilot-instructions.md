# Copilot Instructions

## Project Overview

This is an Oracle 26ai annotation project. The goal is to generate and manage table and view annotation scripts that enrich the database schema with metadata for AI assistants, APEX applications, and data catalogs.

## Database

- Oracle Database 26ai (or 23ai+)
- Use **SQLcl MCP** for all database interactions (connect, query, execute)
- Annotation syntax differs for tables vs views:
  - **Table-level:** `alter table <t> annotations (<type> '<value>');`
  - **Table column:** `alter table <t> modify <col> annotations (<type> '<value>');`
  - **View-level:** `alter view <v> annotations (<type> '<value>');`
  - **View column:** `alter view <v> modify (<col> annotations (<type> '<value>'));`
- Use `all_*` dictionary views (not `user_*`) with `owner = '<OWNER>'` to support cross-schema queries

## Output Convention

- Annotation scripts go in `./annotations/<object_name_lowercase>/`
- Two files per table/view: `table_annotations.sql` and `column_annotations.sql`
- See `.github/skills/annotate/examples/health_patients/` for canonical examples

## Annotation Types

Six annotation types are used: `display_label`, `format_mask`, `primary_display_column`, `search_facet`, `semantic_type`, `ai_context`.

## Workflow

Use the `/annotate` skill to generate annotations. It supports:
- Both **tables and views**
- User-specified **schema owner** for cross-schema annotation
- Batch processing with comma-separated table/view patterns and SQL LIKE wildcards
- Context enrichment from APEX UI Defaults or APEX Application inspection
- Warn-and-ask before overwriting existing annotations
