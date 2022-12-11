SELECT
  PROJECT_ID,
  DATASET_NAME,
  TABLE_NAME,
  -- For these columns, considering "DAY" to be "24 Hours"
  MAX(JOB_CREATION_DTTM_TZ) >= DATETIME_SUB(
    CURRENT_DATETIME( "{{ var('user_timezone_name') }}" ), 
    INTERVAL 24 * 7 HOUR
  ) as ACCESSED_LAST_ROLLING_7_DAYS,
  MAX(JOB_CREATION_DTTM_TZ) >= DATETIME_SUB(
    CURRENT_DATETIME( "{{ var('user_timezone_name') }}" ), 
    INTERVAL 24 * 30 HOUR
  ) as ACCESSED_LAST_ROLLING_30_DAYS,
  MAX(JOB_CREATION_DTTM_TZ) >= DATETIME_SUB(
    CURRENT_DATETIME( "{{ var('user_timezone_name') }}" ), 
    INTERVAL 24 * 90 HOUR
  ) as ACCESSED_LAST_ROLLING_90_DAYS,
  MAX(JOB_CREATION_DTTM_TZ) >= DATETIME_SUB(
    CURRENT_DATETIME( "{{ var('user_timezone_name') }}" ), 
    INTERVAL 24 * 364 HOUR
  ) as ACCESSED_LAST_ROLLING_364_DAYS, -- note, 7 days/wk * 52 wks/yr = 364 days/yr
FROM {{ ref('int__job__query__referenced_tables') }}
GROUP BY 1,2,3
