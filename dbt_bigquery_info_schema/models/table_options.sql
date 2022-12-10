select
  TABLE_CATALOG,
  TABLE_SCHEMA,
  TABLE_NAME,
  OPTION_NAME,
  OPTION_TYPE,
  OPTION_VALUE
from {{ info_schema('TABLE_OPTIONS') }}