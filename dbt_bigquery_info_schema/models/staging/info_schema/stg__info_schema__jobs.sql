with query_header as (
  with j as (
  select parse_json('{"app": "dbt", "dbt_version": "1.3.0", "profile_name": "citibike_dbt", "target_name": "prod", "connection_name": "cse-6242-sp22-nyatl.information_schema"}') as dbt_header
)

select
  string(dbt_header.app) as app,
  string(dbt_header.dbt_version) as dbt_version,
  string(dbt_header.profile_name) as profile_name,
  string(dbt_header.target_name) as target_name,
  string(dbt_header.connection_name) as connection_name
from j
)

select
  CREATION_TIME as CREATION_TS,
  DATETIME(CREATION_TIME, "{{ var('user_timezone_name') }}" ) as CREATION_DTTM_TZ,
  PROJECT_ID,
  PROJECT_NUMBER,
  USER_EMAIL,
  JOB_ID,
  JOB_TYPE,
  STATEMENT_TYPE,
  PRIORITY,
  START_TIME as START_TS,
  DATETIME(START_TIME, "{{ var('user_timezone_name') }}" ) as START_DTTM_TZ,
  END_TIME as END_TS,
  DATETIME(END_TIME, "{{ var('user_timezone_name') }}" ) as END_DTTM_TZ,
  QUERY,
  STATE,
  RESERVATION_ID,
  TOTAL_BYTES_PROCESSED,
  TOTAL_SLOT_MS,
  ERROR_RESULT,
  CACHE_HIT,
  DESTINATION_TABLE,
  REFERENCED_TABLES,
  LABELS,
  TIMELINE,
  JOB_STAGES,
  TOTAL_BYTES_BILLED,
  PARENT_JOB_ID,
  TRANSACTION_ID,
  SESSION_INFO,
  DML_STATISTICS,
  BI_ENGINE_STATISTICS,
  TOTAL_MODIFIED_PARTITIONS
from {{ info_schema('JOBS') }} -- Note: same as JOBS_BY_PROJECT
