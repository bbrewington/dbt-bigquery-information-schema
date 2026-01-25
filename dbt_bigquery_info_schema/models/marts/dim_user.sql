-- Grain: One row per user_email
{{ config(materialized='table') }}

with job_stats as (
  select
    user_email,
    count(*) as total_jobs,
    min(creation_ts) as first_job_at,
    max(creation_ts) as last_job_at,
    sum(total_bytes_processed) as lifetime_bytes_processed,
    sum(total_bytes_billed) as lifetime_bytes_billed
  from {{ ref('stg__info_schema__jobs') }}
  group by 1
)

select
  user_email,
  split(user_email, '@')[safe_offset(1)] as email_domain,
  ends_with(user_email, '.iam.gserviceaccount.com') as is_service_account,
  total_jobs,
  first_job_at,
  last_job_at,
  lifetime_bytes_processed,
  lifetime_bytes_billed
from job_stats
