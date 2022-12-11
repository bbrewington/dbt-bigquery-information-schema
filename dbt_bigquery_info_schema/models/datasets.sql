select
  CATALOG_NAME as PROJECT_ID,
  SCHEMA_NAME as DATASET_ID,
  SCHEMA_OWNER, /* TODO: this is always NULL - need to comment out? */
  CREATION_TIME,
  LAST_MODIFIED_TIME,
  LOCATION,
  DDL,
  DEFAULT_COLLATION_NAME
from {{ info_schema('SCHEMATA') }}
