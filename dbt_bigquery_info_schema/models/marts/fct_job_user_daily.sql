-- Grain: One row per user_email + cal_dt
{{ config(
    materialized='table',
    partition_by={"field": "cal_dt", "data_type": "date"},
    cluster_by=['user_email']
) }}

select
  user_email,
  cal_dt,
  count(*) as job_count,
  sum(total_bytes_processed) as total_bytes_processed,
  sum(total_bytes_billed) as total_bytes_billed,
  sum(total_slot_ms) as total_slot_ms,
  countif(is_error) as error_count,
  countif(is_cache_hit) as cache_hit_count,
  countif(job_type = 'QUERY') as query_count,
  countif(job_type = 'LOAD') as load_count,
  countif(job_type = 'EXTRACT') as extract_count,
  countif(job_type = 'COPY') as copy_count
from {{ ref('fct_job') }}
group by 1, 2
