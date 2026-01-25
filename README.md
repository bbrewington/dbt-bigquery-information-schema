# dbt-bigquery-information-schema

dbt project to make it easier to work with [BigQuery INFORMATION_SCHEMA views](https://cloud.google.com/bigquery/docs/information-schema-intro).  Treats these views as data sources, and builds them into a Distributed Acyclic Graph (a.k.a. DAG) via dbt, that can be easily browsed using the `dbt docs` command, to see which views logically connect, and to give some examples of how to use them in your BigQuery project

## Prerequisites

- [uv](https://docs.astral.sh/uv/getting-started/installation/) - Python package manager
- BigQuery project with appropriate IAM permissions (see below)

## How To Use (assuming running locally)

1. Create gitignored `.env` file: `cp -n .env.template .env`
2. Edit `.env` with your BigQuery project, dataset, and location:
   ```bash
   DBT_BQ_PROJECT=your-gcp-project-id
   DBT_BQ_DATASET=your_output_dataset
   DBT_BQ_LOCATION=US  # or us-central1, europe-west1, etc.
   ```
3. Load environment variables: `source .env` (or `export $(grep -v '^#' .env | xargs)`)
4. Install dependencies: `uv sync`
5. Test the setup: `uv run dbt debug`
6. Go do dbt stuff! (use `uv run dbt <command>`)

## IAM Permissions

This project queries BigQuery INFORMATION_SCHEMA views which require specific IAM permissions.

### Minimum Required Permissions

| Permission | Purpose | Required For |
|------------|---------|--------------|
| `bigquery.jobs.list` | Query JOBS views at regional level | `stg__info_schema__jobs`, `fct_job*` |
| `bigquery.datasets.get` | Query SCHEMATA at regional level | `stg__info_schema__datasets` |
| `bigquery.tables.list` | Query TABLES/COLUMNS/VIEWS at dataset level | `stg__info_schema__tables`, `stg__info_schema__columns` |

### Recommended Roles

**Option A: Pre-defined roles (simplest)**
- `roles/bigquery.metadataViewer` - Read metadata for all datasets in project
- `roles/bigquery.jobUser` - Required to run dbt jobs

**Option B: Custom role (least privilege)**
```
bigquery.datasets.get
bigquery.datasets.getIamPolicy
bigquery.jobs.list
bigquery.tables.get
bigquery.tables.list
```

### Regional vs Dataset-Level Queries

Some INFORMATION_SCHEMA views can be queried at regional level (all datasets at once) or dataset level (one dataset at a time):

| View | Regional | Dataset | Default in this project |
|------|----------|---------|------------------------|
| JOBS, JOBS_BY_USER | Yes | No | Regional |
| SCHEMATA | Yes | No | Regional |
| TABLES, COLUMNS, VIEWS | Yes* | Yes | Dataset (iterates) |

*Regional TABLES/COLUMNS/VIEWS requires `bigquery.tables.list` at project level.

**To enable regional queries** (if you have project-level permissions):
```bash
uv run dbt run --vars '{info_schema_tables_regional: true}'
```

### Troubleshooting Permissions

If you see `Access Denied` errors:

1. **For JOBS views**: Ensure you have `bigquery.jobs.list` on the project
2. **For TABLES/COLUMNS/VIEWS**: The default dataset-level iteration should work with standard permissions. If not, check you have `bigquery.tables.list` on each dataset.
3. **For SCHEMATA**: Ensure you have `bigquery.datasets.get` on the project

Grant permissions via:
```bash
# Grant metadata viewer role
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="user:your-email@domain.com" \
  --role="roles/bigquery.metadataViewer"
```

## Contributing

For master list of GBQ stuff and PM approach, see [Issue #1](https://github.com/bbrewington/dbt-bigquery-information-schema/issues/1) - and otherwise, see [Issues](https://github.com/bbrewington/dbt-bigquery-information-schema/issues)

For now, please fork this repo, make your changes there, and submit a PR.  If you want less hassle and plan on working on this a bunch, contact `@Brent Brewington` in [dbt Slack](https://getdbt.slack.com)

Try to follow [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) - basically, small set of changes on fork/branch that shouldn't live too long before getting merged (Merge conflicts, while manageable, add chaos)

Note on the goofy clickbait commit messages from 2022...it was a different time in AI.  Now in 2026 the hype has died down and we're back to regular ole' commit messages.  Here's original inspiration: [Tweet by @shaundai](https://twitter.com/shaundai/status/1598299932313931777)
