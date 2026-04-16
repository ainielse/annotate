# Annotation Types Reference

This skill uses six Oracle 26ai column/table annotation types. Each annotation serves a distinct purpose for AI assistants, APEX applications, and data catalogs.

## 1. display_label

Human-readable label for the column or table. Used in UI rendering, reports, and AI-generated output.

**Decision priority:**
1. APEX Application: page item `label` or IG column `heading`
2. APEX UI Defaults: `label` from `apex_ui_defaults_columns`
3. Data inference: Convert column_name to Title Case, expand common abbreviations (ID → ID, DOB → Date of Birth, etc.)

**Examples:**
```sql
alter table employees modify employee_id annotations (display_label 'Employee ID');
alter table orders modify order_date annotations (display_label 'Order Date');
alter table health_patients modify email_address annotations (display_label 'Personal Email Address');
```

## 2. format_mask

Display format pattern for the column value. Guides UI rendering and data interpretation.

**Decision priority:**
1. APEX Application: page item `format_mask` or IG column `format_mask`
2. APEX UI Defaults: `mask_form` or `mask_report` from `apex_ui_defaults_columns`
3. Data inference: detect patterns in sample data

**Common patterns:**
| Data Pattern | Format Mask |
|---|---|
| Phone numbers `(###) ###-####` | `(###) ###-####` |
| Dates | `DD-MON-YY`, `DD-MON-YYYY`, `YYYY-MM-DD` |
| Year-only | `YYYY` |
| Currency | `$999,999.99` or `FML999G999G999G999G990D00` |
| Percentage | `990.00%` |

**Examples:**
```sql
alter table health_patients modify dob annotations (format_mask 'DD-MON-YY');
alter table orders modify total_amount annotations (format_mask 'FML999G999G999G990D00');
alter table health_patients modify cell_phone annotations (format_mask '(###) ###-####');
```

## 3. primary_display_column

Set to `'true'` for columns that identify a row to a human reader. These are the columns a user would naturally look at to recognize a specific record (e.g., names, titles, codes).

**Decision heuristics:**
- First name + last name columns → both `'true'`
- Description or title columns → `'true'`
- Business-meaningful unique codes (e.g., ORDER_NUMBER, SKU) → `'true'`
- Do NOT set on surrogate PKs (numeric IDs), audit columns, or technical columns
- Typically 1-3 columns per table

**Examples:**
```sql
alter table employees modify first_name annotations (primary_display_column 'true');
alter table employees modify last_name annotations (primary_display_column 'true');
alter table products modify product_name annotations (primary_display_column 'true');
```

## 4. search_facet

Set to `'true'` for columns suitable as filter/facet criteria in search interfaces. These are categorical or low-cardinality columns users would filter by.

**Decision heuristics:**
- Columns with fewer than ~50 distinct values relative to total row count
- Status, type, category columns → always `'true'`
- Geographic groupings (state, county, city, country) → `'true'`
- Boolean/flag columns → `'true'`
- LOV-backed items in APEX → strong signal for `'true'`
- Do NOT set on high-cardinality columns (names, emails, phone numbers, free text)
- Do NOT set on numeric measures, dates (unless year/month extracted), or surrogate keys

**Examples:**
```sql
alter table health_patients modify state annotations (search_facet 'true');
alter table health_patients modify sex annotations (search_facet 'true');
alter table orders modify order_status annotations (search_facet 'true');
```

## 5. semantic_type

A machine-readable tag classifying the column's semantic meaning. Used by AI assistants to understand data context without reading sample data. See [semantic-types.md](./semantic-types.md) for the full catalog.

**Decision heuristics:**
- Match column name patterns and data characteristics to the type catalog
- One semantic_type per column (pick the most specific match)
- Omit if no catalog type fits — do not invent new types without justification

**Examples:**
```sql
alter table health_patients modify email_address annotations (semantic_type 'email');
alter table health_patients modify latitude annotations (semantic_type 'latitude');
alter table employees modify hire_date annotations (semantic_type 'date');
```

## 6. ai_context

Rich natural-language description providing everything an AI assistant needs to understand and correctly use this column. This is the most important annotation for AI-powered features.

**Content should include (as applicable):**
- Column purpose and business meaning
- Data format and patterns (with examples from actual data)
- Allowed/observed values for categorical columns
- Constraints (NOT NULL, unique, FK relationships)
- Derivation logic (if column is computed/derived from others)
- Domain-specific context that isn't obvious from the column name
- Relationship to other columns in the same table

**Decision priority:**
1. APEX Application: combine `help_text` + LOV values + validation rules + observed data patterns
2. APEX UI Defaults: combine `help_text` + observed data patterns
3. Data inference: describe based on column type, sample data, constraints, and relationships

**Examples:**
```sql
alter table health_patients modify sex annotations (ai_context 'Patient biological sex. Values: Female, Male.');
alter table health_patients modify upper_first annotations (ai_context 'Patient first name stored in uppercase for case-insensitive lookups. Derived from FIRST_NAME.');
alter table orders modify status annotations (ai_context 'Current order fulfillment status. Values: Pending, Processing, Shipped, Delivered, Cancelled. Transitions are one-directional except Cancelled which can occur from any state.');
```
