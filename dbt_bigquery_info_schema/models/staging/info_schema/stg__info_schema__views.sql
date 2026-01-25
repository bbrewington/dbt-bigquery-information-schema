-- Grain: One row per view in the project
-- Access: Uses dataset-level INFORMATION_SCHEMA (iterates over all datasets)
-- Set var 'info_schema_views_regional' to true if you have regional IAM permissions

-- depends_on: {{ ref('stg__info_schema__datasets') }}

{% set columns %}
  TABLE_CATALOG as PROJECT_ID,
  TABLE_SCHEMA as DATASET_NAME,
  TABLE_NAME,
  VIEW_DEFINITION,
  CHECK_OPTION,
  USE_STANDARD_SQL
{% endset %}

{% if var('info_schema_views_regional', false) %}
-- Regional query (requires bigquery.tables.list at project level)
select {{ columns }}
from {{ info_schema('VIEWS') }}
{% else %}
-- Dataset-level iteration (works with standard dataset permissions)
{{ info_schema_union_over_datasets('VIEWS', columns) }}
{% endif %}
