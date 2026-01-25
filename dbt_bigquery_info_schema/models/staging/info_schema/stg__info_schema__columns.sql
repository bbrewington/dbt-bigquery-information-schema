-- Grain: One row per column in the project
-- Access: Uses dataset-level INFORMATION_SCHEMA (iterates over all datasets)
-- Set var 'info_schema_columns_regional' to true if you have regional IAM permissions

-- depends_on: {{ ref('stg__info_schema__datasets') }}

{% set columns %}
  TABLE_CATALOG as PROJECT_ID,
  TABLE_SCHEMA as DATASET_NAME,
  TABLE_NAME,
  COLUMN_NAME,
  ORDINAL_POSITION,
  IS_NULLABLE,
  DATA_TYPE,
  IS_GENERATED,
  GENERATION_EXPRESSION,
  IS_STORED,
  IS_HIDDEN,
  IS_UPDATABLE,
  IS_SYSTEM_DEFINED,
  IS_PARTITIONING_COLUMN,
  CLUSTERING_ORDINAL_POSITION,
  COLLATION_NAME,
  COLUMN_DEFAULT,
  ROUNDING_MODE
{% endset %}

{% if var('info_schema_columns_regional', false) %}
-- Regional query (requires bigquery.tables.list at project level)
select {{ columns }}
from {{ info_schema('COLUMNS') }}
{% else %}
-- Dataset-level iteration (works with standard dataset permissions)
{{ info_schema_union_over_datasets('COLUMNS', columns) }}
{% endif %}
