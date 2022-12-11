-- depends_on: {{ ref('datasets') }}

{{ get_partitions_over_datasets(exclude_list=['gbq_info_schema']) }}