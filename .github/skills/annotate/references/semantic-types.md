# Semantic Types Catalog

Use these values for the `semantic_type` annotation. Pick the most specific match for each column. If no type fits, omit the annotation rather than inventing a new one.

## Person & Identity

| Type | When to Use | Column Name Patterns |
|---|---|---|
| `identifier` | Surrogate/primary key columns (numeric or UUID) | `*_ID`, `ID`, `*_PK` |
| `natural_key` | Business-meaningful unique identifiers | `*_CODE`, `*_NUMBER`, `SKU`, `SSN` |
| `person_name` | First, last, middle, or full person names | `*_NAME`, `FIRST_*`, `LAST_*`, `MIDDLE_*` |
| `username` | Login/account usernames | `USERNAME`, `USER_NAME`, `LOGIN` |

## Contact Information

| Type | When to Use | Column Name Patterns |
|---|---|---|
| `email` | Email addresses | `*EMAIL*` |
| `phone_number` | Phone/fax numbers (any format) | `*PHONE*`, `*FAX*`, `*MOBILE*`, `*CELL*` |
| `url` | Web URLs or URIs | `*URL*`, `*LINK*`, `*WEBSITE*` |

## Geographic & Location

| Type | When to Use | Column Name Patterns |
|---|---|---|
| `address` | Street address lines | `*ADDRESS*`, `*STREET*`, `*LINE_1*` |
| `city` | City/town names | `CITY`, `*_CITY` |
| `state` | State/province names or codes | `STATE`, `*_STATE`, `PROVINCE` |
| `county` | County/district names | `COUNTY`, `*_COUNTY`, `DISTRICT` |
| `country` | Country names or codes | `COUNTRY*`, `*_COUNTRY` |
| `postal_code` | ZIP/postal codes | `*ZIP*`, `*POSTAL*` |
| `latitude` | Geographic latitude coordinate | `LAT*` |
| `longitude` | Geographic longitude coordinate | `LON*`, `LNG*` |

## Date & Time

| Type | When to Use | Column Name Patterns |
|---|---|---|
| `date` | General dates (not fitting a more specific type) | `*_DATE`, `*_ON` |
| `date_of_birth` | Person birth dates | `DOB`, `*BIRTH*`, `*BORN*` |
| `timestamp` | Date-time with precision | `*_AT`, `*_TIMESTAMP`, `*_TS` |
| `year` | Year-only values | `*YEAR*` |

## Financial

| Type | When to Use | Column Name Patterns |
|---|---|---|
| `currency_amount` | Monetary values | `*AMOUNT*`, `*PRICE*`, `*COST*`, `*TOTAL*`, `*SALARY*` |
| `currency_code` | ISO currency codes (USD, EUR) | `*CURRENCY*` |
| `percentage` | Percentage values (0-100 or 0-1) | `*PERCENT*`, `*RATE*`, `*PCT*` |

## Classification & Status

| Type | When to Use | Column Name Patterns |
|---|---|---|
| `status` | Workflow/lifecycle status values | `*STATUS*` |
| `type` | Category/type classifiers | `*TYPE*`, `*CATEGORY*`, `*CLASS*` |
| `priority` | Priority/severity levels | `*PRIORITY*`, `*SEVERITY*` |
| `gender` | Gender/sex values | `SEX`, `GENDER` |
| `boolean_flag` | Yes/No, Y/N, 1/0, true/false flags | `IS_*`, `HAS_*`, `*_FLAG`, `*_YN` |
| `health_status` | Health/medical status indicators | `*FEELING*`, `*HEALTH*`, `*CONDITION*` |

## Measures & Quantities

| Type | When to Use | Column Name Patterns |
|---|---|---|
| `quantity` | Count or quantity of items | `*QTY*`, `*QUANTITY*`, `*COUNT*` |
| `weight` | Weight measurements | `*WEIGHT*` |
| `duration` | Time duration values | `*DURATION*`, `*ELAPSED*` |
| `score` | Numeric scores or ratings | `*SCORE*`, `*RATING*` |

## Content & Text

| Type | When to Use | Column Name Patterns |
|---|---|---|
| `description` | Free-text descriptions | `*DESC*`, `*DESCRIPTION*` |
| `comment` | User comments or notes | `*COMMENT*`, `*NOTE*`, `*REMARK*` |
| `file_path` | File system paths | `*PATH*`, `*FILE*`, `*FILENAME*` |
| `mime_type` | MIME/content types | `*MIME*`, `*CONTENT_TYPE*` |

## Audit & Metadata

| Type | When to Use | Column Name Patterns |
|---|---|---|
| `audit_user` | Created-by / updated-by user references | `CREATED_BY`, `UPDATED_BY`, `*_BY` |
| `audit_timestamp` | Created-on / updated-on timestamps | `CREATED`, `CREATED_ON`, `UPDATED_ON`, `*_DATE` (audit context) |
| `version` | Row version/optimistic lock counters | `*VERSION*`, `*REVISION*`, `ORA_ROWSCN` |

## Matching Guidelines

1. **Check column name first** — match against the patterns above
2. **Check data type** — e.g., DATE columns are likely `date`, `timestamp`, `date_of_birth`, or `audit_timestamp`
3. **Check sample data** — confirms the type (e.g., values like `(555) 123-4567` confirm `phone_number`)
4. **Check constraints** — FK to a lookup table suggests `type` or `status`
5. **Pick the most specific** — prefer `date_of_birth` over `date`, prefer `email` over `description`
6. **Omit if unsure** — no semantic_type is better than a wrong one
