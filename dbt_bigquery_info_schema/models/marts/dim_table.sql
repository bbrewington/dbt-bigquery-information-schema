-- Grain: One row per project.dataset.table
{{ config(materialized='table') }}

with tables as (
  select * from {{ ref('stg__info_schema__tables') }}
),

table_access as (
  select
    project_id,
    dataset_name,
    table_name,
    max(job_creation_dttm_tz) as last_accessed_at,
    count(*) as query_count_all_time
  from {{ ref('int__job__query__referenced_tables') }}
  group by 1, 2, 3
)

select
  t.project_id,
  t.dataset_name,
  t.table_name,
  t.table_full_id,
  t.table_type,
  t.creation_time as created_at,
  t.ddl,
  coalesce(ta.last_accessed_at, datetime(t.creation_time, "{{ var('user_timezone_name') }}")) as last_accessed_at,
  coalesce(ta.query_count_all_time, 0) as query_count_all_time,
  coalesce(ta.last_accessed_at >= datetime_sub(
    current_datetime("{{ var('user_timezone_name') }}"),
    interval 7 day
  ), false) as accessed_last_7_days,
  coalesce(ta.last_accessed_at >= datetime_sub(
    current_datetime("{{ var('user_timezone_name') }}"),
    interval 30 day
  ), false) as accessed_last_30_days,
  coalesce(ta.last_accessed_at >= datetime_sub(
    current_datetime("{{ var('user_timezone_name') }}"),
    interval 90 day
  ), false) as accessed_last_90_days
from tables t
left join table_access ta
  on t.project_id = ta.project_id
  and t.dataset_name = ta.dataset_name
  and t.table_name = ta.table_name
