When Mike Hichwa writes...read it, act upon it. After not being very active on social media, Mike recently gave some guidance on how to prepare for APEX 26.1

https://www.linkedin.com/posts/michael-hichwa-2a64466_apex-community-ive-put-together-a-short-activity-7448090479226875904-r5at

I jumped in and created an agent to help with point #3: Annotate your tables. Check out the README in the annotations folder for more detail.


# Oracle 26ai Annotation Generator

A GitHub Copilot skill for generating Oracle 26ai table and column annotation scripts. It inspects your data model, optionally enriches context from APEX UI Defaults or an APEX Application, and produces ready-to-run SQL scripts.

## Prerequisites

- Visual Studio Code with GitHub Copilot
- [SQLcl MCP server](https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/) configured in VS Code and connected to an Oracle 23ai+ / 26ai database

## Usage

In VS Code Copilot Chat, type `/` and select **annotate**, then provide one or more table names or SQL `LIKE` patterns:

```
/annotate EMPLOYEES
/annotate EMP, DEPT
/annotate HEALTH%
/annotate HR%, FINANCE%
```

The skill will:
1. List available SQLcl MCP connections and ask which to use
2. Resolve wildcard patterns to actual table names and confirm the list
3. Ask which context source to use: **None**, **APEX UI Defaults**, or **APEX Application** (prompts for App ID)
4. Inspect the data model — columns, constraints, sample data, distinct values, existing annotations
5. Optionally query APEX metadata to enrich labels, format masks, LOV values, and help text
6. Warn before overwriting any existing annotations (skip / overwrite / merge)
7. Generate SQL scripts in `annotations/<table_name>/`
8. Show a summary table and offer to execute the scripts

## Output

Two files are created per table under `annotations/`:

```
annotations/
├── emp/
│   ├── table_annotations.sql      # Table-level display_label and ai_context
│   └── column_annotations.sql    # Per-column annotations
└── dept/
    ├── table_annotations.sql
    └── column_annotations.sql
```

### Annotation Types

| Annotation | Purpose |
|---|---|
| `display_label` | Human-readable label for UI rendering |
| `format_mask` | Display format pattern (dates, phone, currency) |
| `primary_display_column` | Marks columns that identify a row to a human |
| `search_facet` | Marks low-cardinality columns suitable for filtering |
| `semantic_type` | Machine-readable semantic classification |
| `ai_context` | Rich natural-language description for AI assistants |

### SQL Syntax

```sql
-- Table-level
alter table employees annotations (display_label 'Employees');
alter table employees annotations (ai_context 'Employee records...');

-- Column-level
alter table employees modify hire_date annotations (display_label 'Hire Date');
alter table employees modify hire_date annotations (format_mask 'DD-MON-YYYY');
alter table employees modify hire_date annotations (semantic_type 'date');
alter table employees modify hire_date annotations (ai_context 'Date the employee was hired.');
```

## Repository Structure

```
.github/
├── copilot-instructions.md          # Workspace-level Copilot context
└── skills/
    └── annotate/
        ├── SKILL.md                 # Skill definition (invoked as /annotate)
        ├── examples/
        │   └── health_patients/     # Canonical output examples
        │       ├── table_annotations.sql
        │       └── column_annotations.sql
        └── references/
            ├── annotation-types.md  # Guidance for each annotation type
            ├── semantic-types.md    # semantic_type value catalog
            ├── apex-views.md        # APEX view queries for context enrichment
            └── output-format.md     # File format and SQL syntax reference
annotations/                         # Generated annotation scripts (gitkeep)
```

## Sharing This Skill

This skill is workspace-scoped — anyone who clones this repository gets the `/annotate` slash command automatically (requires Copilot + SQLcl MCP). To make it available across all your projects, copy `.github/skills/annotate/` to `~/.copilot/skills/annotate/`.
