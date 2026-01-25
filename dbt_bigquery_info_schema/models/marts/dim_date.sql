-- Grain: One row per calendar date
{{ config(materialized='table') }}

with date_spine as (
  select cal_dt
  from unnest(generate_date_array('2020-01-01', current_date() + 365)) as cal_dt
)

select
  format_date('%Y%m%d', cal_dt) as date_key,
  cal_dt,
  extract(dayofweek from cal_dt) as day_of_week,
  extract(day from cal_dt) as day_of_month,
  extract(week from cal_dt) as week_of_year,
  extract(month from cal_dt) as month,
  extract(quarter from cal_dt) as quarter,
  extract(year from cal_dt) as year,
  format_date('%A', cal_dt) as day_name,
  format_date('%B', cal_dt) as month_name,
  extract(dayofweek from cal_dt) in (1, 7) as is_weekend,
  extract(dayofweek from cal_dt) not in (1, 7) as is_weekday
from date_spine
