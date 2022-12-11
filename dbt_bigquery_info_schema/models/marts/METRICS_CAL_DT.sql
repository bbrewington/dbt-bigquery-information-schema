with date_spine as (
  select CAL_DT
  from UNNEST(GENERATE_DATE_ARRAY(
    (select MIN(DATE(CREATION_TS)) from {{ ref('stg__info_schema__jobs') }} ),
    (select MAX(DATE(CREATION_TS)) from {{ ref('stg__info_schema__jobs') }} )
  )) as CAL_DT
),

jobs_dt as (
  select
    CAL_DT,
    SUM(IFNULL(TOTAL_BYTES_PROCESSED, 0)) as TOTAL_BYTES_PROCESSED,
    SUM(IFNULL(TOTAL_SLOT_MS, 0)) as TOTAL_SLOT_MS,
    SUM(IFNULL(NUM_JOBS_ERROR, 0)) as NUM_JOBS_ERROR,
    SUM(IFNULL(NUM_JOBS_CACHE_HIT, 0)) as NUM_JOBS_CACHE_HIT,
    SUM(IFNULL(NUM_REFERENCED_TABLES, 0)) as NUM_REFERENCED_TABLES,
    SUM(IFNULL(NUM_JOBS_WITH_LABELS, 0)) as NUM_JOBS_WITH_LABELS,
    SUM(IFNULL(TOTAL_BYTES_BILLED, 0)) as TOTAL_BYTES_BILLED
  from {{ ref('METRICS_JOB') }}
  group by 1
)

select
  date_spine.CAL_DT,
  IFNULL(TOTAL_BYTES_PROCESSED, 0) as TOTAL_BYTES_PROCESSED,
  IFNULL(TOTAL_SLOT_MS, 0) as TOTAL_SLOT_MS,
  IFNULL(NUM_JOBS_ERROR, 0) as NUM_JOBS_ERROR,
  IFNULL(NUM_JOBS_CACHE_HIT, 0) as NUM_JOBS_CACHE_HIT,
  IFNULL(NUM_REFERENCED_TABLES, 0) as NUM_REFERENCED_TABLES,
  IFNULL(NUM_JOBS_WITH_LABELS, 0) as NUM_JOBS_WITH_LABELS,
  IFNULL(TOTAL_BYTES_BILLED, 0) as TOTAL_BYTES_BILLED
from date_spine
left join jobs_dt
  using(CAL_DT)
