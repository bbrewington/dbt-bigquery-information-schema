-- depends_on: {{ ref('stg__info_schema__datasets') }}

{{ get_partitions_over_datasets(exclude_list=['gbq_info_schema']) }}