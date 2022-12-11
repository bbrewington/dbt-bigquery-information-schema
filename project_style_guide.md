# Project Style Guide

## Naming Conventions: Entities

term in GCP INFORMATION_SCHEMA | term in this project
---|---
SCHEMATA | DATASET

## Naming Conventions: Columns

term in this project | example(s) from GCP INFORMATION_SCHEMA
---|---
PROJECT_ID | TABLE_CATALOG, CATALOG_NAME
DATASET_ID | SCHEMA_NAME, TABLE_SCHEMA

## dbt

seed files named as `{category}__{entity_name}.csv` (e.g. info_schema_columns__datasets.csv)

models named as `{entity_name}.sql` (e.g. datasets.csv)
