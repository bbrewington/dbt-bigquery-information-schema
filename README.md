# dbt-bigquery-information-schema

dbt project to make it easier to work with [BigQuery INFORMATION_SCHEMA views](https://cloud.google.com/bigquery/docs/information-schema-intro).  Treats these views as data sources, and builds them into a Distributed Acyclic Graph (a.k.a. DAG) via dbt, that can be easily browsed using the `dbt docs` command, to see which views logically connect, and to give some examples of how to use them in your BigQuery project

## Contributing

For master list of GBQ stuff and PM approach, see [Issue #1](https://github.com/bbrewington/dbt-bigquery-information-schema/issues/1) - and otherwise, see [Issues](https://github.com/bbrewington/dbt-bigquery-information-schema/issues)

For now, please fork this repo, make your changes there, and submit a PR.  If you want less hassle and plan on working on this a bunch, contact `@Brent Brewington` in [dbt Slack](https://getdbt.slack.com)

Try to follow [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) - basically, small set of changes on fork/branch that shouldn't live too long before getting merged (Merge conflicts, while manageable, add chaos)

I'm going to use ChatGPT to create clickbait commit messages.  You can too: [Tweet by @shaundai](https://twitter.com/shaundai/status/1598299932313931777)