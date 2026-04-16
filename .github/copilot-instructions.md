# Copilot Instructions

## Project Overview

This is an Oracle 26ai annotation project. The goal is to generate and manage table/column annotation scripts that enrich the database schema with metadata for AI assistants, APEX applications, and data catalogs.

## Database

- Oracle Database 26ai (or 23ai+)
- Use **SQLcl MCP** for all database interactions (connect, query, execute)
- Annotation syntax: `alter table <table> annotations (<type> '<value>');` (table-level) and `alter table <table> modify <column> annotations (<type> '<value>');` (column-level)

## Output Convention

- Annotation scripts go in `./annotations/<table_name_lowercase>/`
- Two files per table: `table_annotations.sql` and `column_annotations.sql`
- See `.github/skills/annotate/examples/health_patients/` for canonical examples

## Annotation Types

Six annotation types are used: `display_label`, `format_mask`, `primary_display_column`, `search_facet`, `semantic_type`, `ai_context`.

## Workflow

Use the `/annotate` skill to generate annotations. It supports:
- Batch processing with comma-separated table patterns and SQL LIKE wildcards
- Context enrichment from APEX UI Defaults or APEX Application inspection
- Warn-and-ask before overwriting existing annotations
