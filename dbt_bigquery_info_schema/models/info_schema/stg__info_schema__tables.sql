select
  TABLE_CATALOG as PROJECT_ID,
  TABLE_SCHEMA as DATASET_NAME,
  TABLE_NAME,
  TABLE_TYPE,
  IS_INSERTABLE_INTO,
  IS_TYPED,
  CREATION_TIME,
  DDL,
  /* TODO: Leaving TABLE CLONE fields out for now - might want to create macro ping
     info schema first and check if there are any, then if so use these
  clone_time,
  base_table_catalog,
  base_table_schema,
  base_table_name,
  */
  DEFAULT_COLLATION_NAME
from {{ info_schema('TABLES') }}
