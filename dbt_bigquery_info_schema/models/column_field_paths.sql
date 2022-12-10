select
  TABLE_CATALOG,
  TABLE_SCHEMA,
  TABLE_NAME,
  COLUMN_NAME,
  FIELD_PATH,
  DATA_TYPE,
  DESCRIPTION,
  COLLATION_NAME,
  ROUNDING_MODE
from {{ info_schema('COLUMN_FIELD_PATHS') }}