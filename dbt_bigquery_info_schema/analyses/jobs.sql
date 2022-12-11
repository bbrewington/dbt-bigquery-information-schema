/*
The following example calculates average slot utilization for all queries over the past 7 days
for a given project. Note that this calculation is most accurate for projects that have
consistent slot usage throughout the week. If your project does not have consistent slot usage,
this number might be lower than expected.
*/

SELECT
  SUM(total_slot_ms) / (1000 * 60 * 60 * 24 * 7) AS avg_slots
FROM {{ ref('stg__info_schema__jobs') }}
WHERE 1=1
  AND job_type = 'QUERY'
  AND creation_time BETWEEN
    TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
    AND
    CURRENT_TIMESTAMP()
