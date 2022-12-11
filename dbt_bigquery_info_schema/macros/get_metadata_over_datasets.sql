{%- macro get_metadata_over_datasets(exclude_list) -%}
{%- call statement('datasets_list', fetch_result=True) -%}
    select DATASET_NAME from {{ ref('stg__info_schema__datasets') }}
{%- endcall -%}
{%- set datasets_list = load_result('datasets_list') -%}
{%- for d in datasets_list['data'] -%}
{% if d[0] not in exclude_list %}
SELECT
  UPPER('{{d[0]}}') as DATASET_NAME,
  TABLE_ID as TABLE_NAME,
  TIMESTAMP_MILLIS(creation_time) AS CREATION_TIME,
  TIMESTAMP_MILLIS(last_modified_time) AS LAST_MODIFIED_TIME,
  ROW_COUNT,
  ROUND(size_bytes / (1024*1024), 2) as SIZE_MB,
  CASE type
    WHEN 1 THEN 'table'
    WHEN 2 THEN 'view'
    ELSE NULL
  END AS TYPE
FROM `{{ target.database }}.{{ d[0] }}`.__TABLES__
{% if not loop.last %}union all{% endif %}
{%- endif -%}
{%- endfor -%}
{%- endmacro -%}
