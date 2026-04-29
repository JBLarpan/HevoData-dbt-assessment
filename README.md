# Hevo CSE Assessment — dbt Project

dbt transformation project that builds a `customers` materialized table in Snowflake from raw data loaded by a Hevo pipeline.

## Pipeline Overview

PostgreSQL → Hevo Pipeline → Snowflake (raw) → dbt → customers table

## Project Structure
```text
.
├── dbt_project.yml
├── macros/
│ └── generate_schema_name.sql # Clean schema names (STAGING, MARTS)
├── models/
│ ├── staging/
│ │ ├── sources.yml
│ │ ├── stg_customers.sql
│ │ ├── stg_orders.sql
│ │ └── stg_payments.sql
│ └── marts/
│ ├── schema.yml
│ └── customers.sql
└── tests/
├── assert_positive_lifetime_value.sql
└── assert_first_order_before_recent.sql
```

## Output

Builds a materialized table MARTS.customers in Snowflake:

| Column | Source | Description |
|--------|--------|-------------|
| customer_id | customers | Primary key |
| first_name | customers | |
| last_name | customers | |
| first_order | orders | Date of first order |
| most_recent_order | orders | Date of latest order |
| number_of_orders | orders | Total order count |
| customer_lifetime_value | payments | Sum of all payments |

```markdown
## Schema Layout
```
```text

Snowflake: PC_HEVODATA_DB
├── PUBLIC ← raw tables loaded by Hevo
├── STAGING ← dbt staging views
└── MARTS ← dbt final tables

```
## Setup

1. Install dbt
pip install dbt-snowflake

2. Create ~/.dbt/profiles.yml
hevo_assessment:
target: dev
outputs:
dev:
type: snowflake
account: your_account
user: your_user
password: your_password
role: SYSADMIN
database: PC_HEVODATA_DB
warehouse: PC_HEVO_WH
schema: PUBLIC
threads: 4

3. Run
dbt debug
dbt run
dbt test

## Tests Included

| Test | Description |
|------|-------------|
| unique on customer_id | No duplicate customers |
| not_null on key columns | Required fields populated |
| accepted_values on status | Known order statuses only |
| accepted_values on payment_method | Known payment methods only |
| assert_positive_lifetime_value | No negative CLV |
| assert_first_order_before_recent | Date ordering is logical |

## Notes

- Credentials are never stored in this repository
- profiles.yml must be created locally at ~/.dbt/profiles.yml
- Raw table names are prefixed with POSTGRES_ by Hevo
- Hevo metadata columns are filtered out in staging models
