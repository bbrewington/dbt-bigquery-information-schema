--turning this model off b/c drain on GBQ metadata limits (you can change enabled to true if you want it)
{{ config(
  enabled=false
) }}

-- depends_on: {{ ref('stg__info_schema__datasets') }}

{{ get_partitions_over_datasets(exclude_list=['gbq_info_schema']) }}