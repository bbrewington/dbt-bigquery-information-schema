{#-
  info_schema: Generate INFORMATION_SCHEMA path for a given view type.

  Args:
    info_schema_type: The INFORMATION_SCHEMA view name (e.g., 'JOBS', 'TABLES', 'COLUMNS')
    dataset: Optional dataset name for dataset-level queries
    region: Optional region override (defaults to 'region-{target.location}')

  Usage:
    {{ info_schema('JOBS') }}                    -- Regional: `project.region-us`.INFORMATION_SCHEMA.JOBS
    {{ info_schema('TABLES', 'my_dataset') }}    -- Dataset:  `project.my_dataset`.INFORMATION_SCHEMA.TABLES
    {{ info_schema('JOBS', region='region-us') }} -- Explicit region override

  See README.md for IAM requirements.
-#}
{%- macro info_schema(info_schema_type, dataset=none, region=none) -%}
{%- set project_id = var('info_schema_project', target.database) -%}
{%- set default_region = 'region-' ~ target.location -%}
{%- set effective_region = region if region else default_region -%}
{%- if dataset -%}
`{{ project_id }}.{{ dataset }}`.INFORMATION_SCHEMA.{{ info_schema_type }}
{%- else -%}
`{{ project_id }}.{{ effective_region }}`.INFORMATION_SCHEMA.{{ info_schema_type }}
{%- endif -%}
{%- endmacro -%}

{#-
  info_schema_union_over_datasets: Generate UNION ALL query across multiple datasets.

  For INFORMATION_SCHEMA views that require dataset-level access (TABLES, COLUMNS, VIEWS, etc.),
  this macro generates a UNION ALL across all datasets in the project.

  Args:
    info_schema_type: The INFORMATION_SCHEMA view name (e.g., 'TABLES', 'COLUMNS')
    columns: SQL column list to select
    exclude_datasets: Optional list of dataset names to exclude

  Usage:
    {{ info_schema_union_over_datasets('TABLES', 'TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME') }}

  Note: Requires stg__info_schema__datasets to exist first.
-#}
{%- macro info_schema_union_over_datasets(info_schema_type, columns, exclude_datasets=[]) -%}
{%- call statement('datasets_list', fetch_result=True) -%}
    select DATASET_NAME from {{ ref('stg__info_schema__datasets') }}
{%- endcall -%}
{%- set datasets_list = load_result('datasets_list') -%}
{%- for d in datasets_list['data'] -%}
{%- if d[0] not in exclude_datasets %}
select {{ columns }}
from {{ info_schema(info_schema_type, d[0]) }}
{% if not loop.last %}union all{% endif %}
{%- endif -%}
{%- endfor -%}
{%- endmacro -%}