-- Grain: One row per table in the project
-- Access: Uses dataset-level INFORMATION_SCHEMA (iterates over all datasets)
-- Set var 'info_schema_tables_regional' to true if you have regional IAM permissions

-- depends_on: {{ ref('stg__info_schema__datasets') }}

{% set columns %}
  TABLE_CATALOG as PROJECT_ID,
  TABLE_SCHEMA as DATASET_NAME,
  TABLE_NAME,
  CONCAT('`', TABLE_CATALOG, '.', TABLE_SCHEMA, '.', TABLE_NAME, '`') as TABLE_FULL_ID,
  TABLE_TYPE,
  IS_INSERTABLE_INTO,
  IS_TYPED,
  CREATION_TIME,
  DDL,
  DEFAULT_COLLATION_NAME
{% endset %}

{% if var('info_schema_tables_regional', false) %}
-- Regional query (requires bigquery.tables.list at project level)
select {{ columns }}
from {{ info_schema('TABLES') }}
{% else %}
-- Dataset-level iteration (works with standard dataset permissions)
{{ info_schema_union_over_datasets('TABLES', columns) }}
{% endif %}
