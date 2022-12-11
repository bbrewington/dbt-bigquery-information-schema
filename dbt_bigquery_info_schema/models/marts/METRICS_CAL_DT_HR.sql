with date_spine as (
  select CAL_DT
  from UNNEST(GENERATE_DATE_ARRAY(
    ( select MIN(CAL_DT) from {{ ref('METRICS_JOB') }} ),
    ( select MAX(CAL_DT) from {{ ref('METRICS_JOB') }} )
  )) as CAL_DT
),

hour_spine as (
  select HOUR
  from UNNEST(GENERATE_ARRAY(0, 23)) as HOUR
),

jobs_hr as (
  select
    CAL_DT,
    HOUR,
    SUM(IFNULL(TOTAL_BYTES_PROCESSED, 0)) as TOTAL_BYTES_PROCESSED,
    SUM(IFNULL(TOTAL_SLOT_MS, 0)) as TOTAL_SLOT_MS,
    SUM(IFNULL(NUM_JOBS_ERROR, 0)) as NUM_JOBS_ERROR,
    SUM(IFNULL(NUM_JOBS_CACHE_HIT, 0)) as NUM_JOBS_CACHE_HIT,
    SUM(IFNULL(NUM_REFERENCED_TABLES, 0)) as NUM_REFERENCED_TABLES,
    SUM(IFNULL(NUM_JOBS_WITH_LABELS, 0)) as NUM_JOBS_WITH_LABELS,
    SUM(IFNULL(TOTAL_BYTES_BILLED, 0)) as TOTAL_BYTES_BILLED
  from {{ ref('METRICS_JOB') }}
  group by 1,2
)

select
  date_spine.CAL_DT,
  hour_spine.HOUR,
  IFNULL(TOTAL_BYTES_PROCESSED, 0) as TOTAL_BYTES_PROCESSED,
  IFNULL(TOTAL_SLOT_MS, 0) as TOTAL_SLOT_MS,
  IFNULL(NUM_JOBS_ERROR, 0) as NUM_JOBS_ERROR,
  IFNULL(NUM_JOBS_CACHE_HIT, 0) as NUM_JOBS_CACHE_HIT,
  IFNULL(NUM_REFERENCED_TABLES, 0) as NUM_REFERENCED_TABLES,
  IFNULL(NUM_JOBS_WITH_LABELS, 0) as NUM_JOBS_WITH_LABELS,
  IFNULL(TOTAL_BYTES_BILLED, 0) as TOTAL_BYTES_BILLED
from date_spine
cross join hour_spine
left join jobs_hr
  on jobs_hr.CAL_DT = date_spine.CAL_DT
  and jobs_hr.HOUR = hour_spine.HOUR
where
  -- this will keep the current hour which may be incomplete, and it will
  -- filter out future hours same-day (e.g. if it's 5:15 PM, will keep the 5 hour and filter out 6-23)
  DATETIME_ADD(CAST(date_spine.CAL_DT as DATETIME), INTERVAL hour_spine.hour HOUR)
  <=
  DATETIME_TRUNC(CURRENT_DATETIME( "{{ var('user_timezone_name') }}" ), HOUR)
