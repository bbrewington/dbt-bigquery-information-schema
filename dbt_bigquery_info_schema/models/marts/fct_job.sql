-- Grain: One row per job_id
{{ config(
    materialized='table',
    partition_by={"field": "cal_dt", "data_type": "date"},
    cluster_by=['user_email', 'project_id']
) }}

select
  job_id,
  date(creation_ts, "{{ var('user_timezone_name') }}") as cal_dt,
  extract(hour from datetime(creation_ts, "{{ var('user_timezone_name') }}")) as hour,
  project_id,
  user_email,
  job_type,
  statement_type,
  priority,
  state,
  creation_ts,
  start_ts,
  end_ts,
  timestamp_diff(end_ts, start_ts, second) as duration_seconds,
  total_bytes_processed,
  total_bytes_billed,
  total_slot_ms,
  cache_hit as is_cache_hit,
  error_result is not null as is_error,
  labels is not null as has_labels,
  reservation_id,
  parent_job_id
from {{ ref('stg__info_schema__jobs') }}
