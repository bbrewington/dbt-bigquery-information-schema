{%- macro get_partitions_over_datasets(exclude_list) -%}
{%- call statement('datasets_list', fetch_result=True) -%}
    select DATASET_NAME from {{ ref('stg__info_schema__datasets') }}
{%- endcall -%}
{%- set datasets_list = load_result('datasets_list') -%}
{%- for d in datasets_list['data'] -%}
{% if d[0] not in exclude_list %}
select
    TABLE_CATALOG as PROJECT_ID,
    TABLE_SCHEMA as DATASET_NAME,
    TABLE_NAME,
    PARTITION_ID,
    TOTAL_ROWS,
    TOTAL_LOGICAL_BYTES,
    TOTAL_BILLABLE_BYTES,
    LAST_MODIFIED_TIME,
    STORAGE_TIER
from {{ info_schema(info_schema_type='PARTITIONS', dataset=d[0]) }}
{% if not loop.last %}union all{% endif %}
{%- endif -%}
{%- endfor -%}
{%- endmacro -%}
