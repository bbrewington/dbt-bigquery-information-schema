select
  TABLE_CATALOG as PROJECT_ID,
  TABLE_SCHEMA as DATASET_NAME,
  TABLE_NAME,
  OPTION_NAME,
  OPTION_TYPE,
  OPTION_VALUE
from {{ info_schema('TABLE_OPTIONS') }}