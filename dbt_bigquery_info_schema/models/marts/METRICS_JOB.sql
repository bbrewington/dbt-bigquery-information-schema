with jobs_ref_tbl_count as (
  select JOB_ID, COUNT(*) as NUM_REFERENCED_TABLES
  from {{ ref('int__job__query__referenced_tables') }}
  group by 1
)

select
  j.JOB_ID,
  DATE(j.CREATION_TS, "{{ var('user_timezone_name') }}") as CAL_DT, /* TODO: Use JOBS_BY_TIMESLICE? */
  EXTRACT(HOUR FROM DATETIME(j.CREATION_TS, "{{ var('user_timezone_name') }}" )) as HOUR, /* TODO: Use JOBS_BY_TIMESLICE? */
  MIN(j.CREATION_TS) as MIN_CREATION_TS,
  SUM(IFNULL(j.TOTAL_BYTES_PROCESSED, 0)) as TOTAL_BYTES_PROCESSED,
  SUM(IFNULL(j.TOTAL_SLOT_MS, 0)) as TOTAL_SLOT_MS,
  SUM(IF(j.ERROR_RESULT IS NOT NULL, 1, 0)) as NUM_JOBS_ERROR,
  SUM(IF(j.CACHE_HIT, 1, 0)) as NUM_JOBS_CACHE_HIT,
  SUM(IFNULL(j_ref_tbl.NUM_REFERENCED_TABLES, 0)) as NUM_REFERENCED_TABLES,
  SUM(IF(j.LABELS IS NOT NULL, 1, 0)) as NUM_JOBS_WITH_LABELS,
  SUM(IFNULL(j.TOTAL_BYTES_BILLED, 0)) as TOTAL_BYTES_BILLED
  -- PARENT_JOB_ID, /* TODO: Figure out how to work with the parent job...aggregate up to that level? traverse the graph? */
  -- TRANSACTION_ID,
  -- SESSION_INFO,
  -- DML_STATISTICS,
  -- BI_ENGINE_STATISTICS,
  -- TOTAL_MODIFIED_PARTITIONS
from {{ ref('stg__info_schema__jobs') }} as j
left join jobs_ref_tbl_count as j_ref_tbl
  on j_ref_tbl.JOB_ID = j.JOB_ID
group by 1,2,3
