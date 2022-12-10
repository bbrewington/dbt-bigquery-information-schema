select
  table_catalog,
  table_schema,
  table_name,
  table_type,
  is_insertable_into,
  is_typed,
  creation_time,
  ddl,
  /* TODO: Leaving TABLE CLONE fields out for now - might want to create macro ping
     info schema first and check if there are any, then if so use these
  clone_time,
  base_table_catalog,
  base_table_schema,
  base_table_name,
  */
  default_collation_name
from {{ info_schema('TABLES') }}
