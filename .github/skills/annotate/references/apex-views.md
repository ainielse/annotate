# APEX Views Reference

This reference documents which APEX views to query when gathering context for annotations. There are two modes: **UI Defaults** and **APEX Application Inspection**.

## Mode 1: UI Defaults

Query these views when the user selects "UI Defaults" as the context source.

### apex_ui_defaults_tables

Table-level UI metadata.

```sql
SELECT table_name, form_region_title, report_region_title
  FROM apex_ui_defaults_tables
 WHERE table_name = :table_name;
```

**Mapping to annotations:**
| View Column | Annotation | Usage |
|---|---|---|
| `report_region_title` | `display_label` (table) | Use as table-level display_label |
| `form_region_title` | `ai_context` (table) | Mention in table ai_context |

### apex_ui_defaults_columns

Column-level UI metadata.

```sql
SELECT column_name, label, help_text, mask_form, mask_report,
       display_in_form, display_in_report, required, alignment,
       group_name, lov_query
  FROM apex_ui_defaults_columns
 WHERE table_name = :table_name
 ORDER BY display_seq_form;
```

**Mapping to annotations:**
| View Column | Annotation | Usage |
|---|---|---|
| `label` | `display_label` | Use directly as column display_label |
| `help_text` | `ai_context` | Include in ai_context description |
| `mask_form` / `mask_report` | `format_mask` | Use as format_mask (prefer mask_form) |
| `lov_query` | `search_facet`, `ai_context` | If LOV exists → likely search_facet; document allowed values in ai_context |
| `required` | `ai_context` | Note if Y in ai_context |
| `group_name` | `ai_context` | Mention grouping context if present |

---

## Mode 2: APEX Application Inspection

Query these views when the user selects "APEX Application" and provides an Application ID. All queries filter by `application_id = :app_id`.

### Step 1: Find pages/regions using the table


```sql
SELECT r.application_id, r.page_id, r.region_name, r.source_type, r.source_type_code
  FROM apex_application_page_regions r
 WHERE r.application_id = :app_id
   --AND UPPER(r.source_type) LIKE '%TABLE%'
   AND (
         UPPER(r.table_name) = :table_name
      OR UPPER(r.region_source) LIKE '%' || :table_name || '%'
   )
 ORDER BY r.page_id;
```

**Mapping to annotations:**
| View Column | Annotation | Usage |
|---|---|---|
| `region_name` | `ai_context` (table) | Enrich table ai_context with how the table is used in the app |
| `region_type` | `ai_context` (table) | Note whether it's a form, report, IG, etc. |

### Step 2: Get page items for the table

```sql
SELECT i.item_name, i.label, i.display_as, i.format_mask,
       i.lov_named_lov, i.lov_definition, i.item_help_text,
       i.item_default, i.pre_element_text, i.post_element_text,
       i.placeholder, i.is_required,
       i.item_source_type, i.item_source
  FROM apex_application_page_items i
  JOIN apex_application_page_regions r
    ON i.application_id = r.application_id
   AND i.page_id = r.page_id
   AND i.region_id = r.region_id
 WHERE i.application_id = :app_id
   AND (
         UPPER(r.table_name) = :table_name
      and UPPER(i.item_source) = :column_name
   )
 ORDER BY i.page_id, i.display_sequence;
```

**Mapping to annotations:**
| View Column | Annotation | Usage |
|---|---|---|
| `label` | `display_label` | Use as column display_label (highest priority) |
| `format_mask` | `format_mask` | Use as column format_mask |
| `item_help_text` | `ai_context` | Include in ai_context |
| `lov_named_lov` / `lov_definition` | `search_facet`, `ai_context` | LOV-backed → search_facet 'true'; resolve LOV values for ai_context |
| `is_required` | `ai_context` | Note if Yes in ai_context |
| `placeholder` | `ai_context` | Include example/hint in ai_context |
| `item_default` | `ai_context` | Note default value in ai_context |
| `display_as` | `ai_context` | Item type gives context (Select List, Text Field, Date Picker, etc.) |

### Step 3: Get Interactive Grid columns

```sql
SELECT c.name AS column_alias, c.heading, c.format_mask,
       c.lov_type, c.lov_id, c.lov_source
  FROM apex_appl_page_ig_columns c
  JOIN apex_application_page_regions r
    ON c.application_id = r.application_id
   AND c.page_id = r.page_id
   AND c.region_id = r.region_id
 WHERE c.application_id = :app_id
   AND UPPER(r.table_name) = :table_name
 ORDER BY c.display_sequence;
```

**Mapping to annotations:**
| View Column | Annotation | Usage |
|---|---|---|
| `heading` | `display_label` | Alternative to page item label for IG-based pages |
| `format_mask` | `format_mask` | IG-specific format mask |
| `lov_named_lov` / `lov_definition` | `search_facet`, `ai_context` | Same as page items |

### Step 4: Resolve LOV values

For named LOVs referenced by page items or IG columns:

```sql
-- Named LOV with static entries
SELECT e.display_value, e.return_value
  FROM apex_application_lov_entries e
 WHERE e.application_id = :app_id
   AND e.list_of_values_name = :lov_name
 ORDER BY e.display_sequence;

-- Named LOV with dynamic query
SELECT l.list_of_values_query
  FROM apex_application_lovs l
 WHERE l.application_id = :app_id
   AND l.list_of_values_name = :lov_name;
```

**Usage:** Include resolved LOV values in `ai_context` (e.g., "Values: Active, Inactive, Suspended").

### Step 5: Get validations

```sql
SELECT v.validation_name, v.validation_type, v.validation_expression1,
       v.validation_expression2, v.validation_failure_text
  FROM apex_application_page_val v
 WHERE v.application_id = :app_id
   AND (
         UPPER(v.associated_item) LIKE '%' || :column_name
      OR UPPER(v.validation_expression1) LIKE '%' || :column_name || '%'
   )
 ORDER BY v.page_id;
```

**Mapping to annotations:**
| View Column | Annotation | Usage |
|---|---|---|
| `validation_type` + `validation_expression*` | `ai_context` | Document validation rules and constraints |
| `error_message` | `ai_context` | Include the business rule context |

---

## Error Handling

- If `apex_ui_defaults_tables` / `apex_ui_defaults_columns` return no rows → the table has no UI Defaults defined. Log a note and proceed with data inference only.
- If APEX views are not accessible (ORA-00942) → APEX is not installed in this database. Warn the user and fall back to data inference only.
- If the table is not found in any APEX page region → the table is not used in the specified app. Warn the user and fall back to UI Defaults or data inference.
- If a LOV query is dynamic SQL → note in ai_context that values are dynamic; do not attempt to execute the LOV query.
