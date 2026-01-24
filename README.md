# dbt-bigquery-information-schema

dbt project to make it easier to work with [BigQuery INFORMATION_SCHEMA views](https://cloud.google.com/bigquery/docs/information-schema-intro).  Treats these views as data sources, and builds them into a Distributed Acyclic Graph (a.k.a. DAG) via dbt, that can be easily browsed using the `dbt docs` command, to see which views logically connect, and to give some examples of how to use them in your BigQuery project

## Prerequisites

- [uv](https://docs.astral.sh/uv/getting-started/installation/) - Python package manager

## How To Use (assuming running locally)

1. In [dbt_bigquery_info_schema/profiles.yml](dbt_bigquery_info_schema/profiles.yml), Edit `project:` & `dataset:`
1. In [dbt_bigquery_info_schema/dbt_project.yml](dbt_bigquery_info_schema/dbt_project.yml), Edit `vars` to fit your use case
1. Create gitignored `.env` file: `cp -n .env.template .env`
1. Load environment variables: `source .env`
1. Install dependencies: `uv sync`
1. Test the setup: `uv run dbt debug`
1. Go do dbt stuff! (use `uv run dbt <command>`)

## Contributing

For master list of GBQ stuff and PM approach, see [Issue #1](https://github.com/bbrewington/dbt-bigquery-information-schema/issues/1) - and otherwise, see [Issues](https://github.com/bbrewington/dbt-bigquery-information-schema/issues)

For now, please fork this repo, make your changes there, and submit a PR.  If you want less hassle and plan on working on this a bunch, contact `@Brent Brewington` in [dbt Slack](https://getdbt.slack.com)

Try to follow [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) - basically, small set of changes on fork/branch that shouldn't live too long before getting merged (Merge conflicts, while manageable, add chaos)

Note on the goofy clickbait commit messages from 2022...it was a different time in AI.  Now in 2026 the hype has died down and we're back to regular ole' commit messages.  Here's original inspiration: [Tweet by @shaundai](https://twitter.com/shaundai/status/1598299932313931777)
