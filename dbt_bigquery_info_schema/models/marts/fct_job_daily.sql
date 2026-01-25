-- Grain: One row per cal_dt
{{ config(materialized='table') }}

select
  cal_dt,
  count(*) as job_count,
  sum(total_bytes_processed) as total_bytes_processed,
  sum(total_bytes_billed) as total_bytes_billed,
  sum(total_slot_ms) as total_slot_ms,
  countif(is_error) as error_count,
  countif(is_cache_hit) as cache_hit_count,
  countif(has_labels) as labeled_job_count
from {{ ref('fct_job') }}
group by 1
