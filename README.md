# dbt-bigquery-information-schema

dbt project to make it easier to work with [BigQuery INFORMATION_SCHEMA views](https://cloud.google.com/bigquery/docs/information-schema-intro).  Treats these views as data sources, and builds them into a Distributed Acyclic Graph (a.k.a. DAG) via dbt, that can be easily browsed using the `dbt docs` command, to see which views logically connect, and to give some examples of how to use them in your BigQuery project

## How To Use (assuming running locally)

Planning on making this more user friendly at some point, but for now it works

1. In [dbt_bigquery_info_schema/profiles.yml](dbt_bigquery_info_schema/profiles.yml), Edit `project:` & `dataset:`
2. In [dbt_bigquery_info_schema/dbt_project.yml](dbt_bigquery_info_schema/dbt_project.yml), Edit `vars` to fit your use case
3. Run the setup script: `source $(git rev-parse --show-toplevel)/dbt_project_setup.sh`...here's what it does:
    1. set working directory to top level of repo
    2. set up virtual environment and activate it <-- note, the venv persists after that script runs b/c we're using 'source'
    3. change working directory to dbt project
    4. Add venv* to .gitignore file
    5. test via `dbt debug`
4. After running that script, you should have a working dbt project (w/ successful debug test), and the script cd'ed you into it
5. Go do dbt stuff!

## Contributing

For master list of GBQ stuff and PM approach, see [Issue #1](https://github.com/bbrewington/dbt-bigquery-information-schema/issues/1) - and otherwise, see [Issues](https://github.com/bbrewington/dbt-bigquery-information-schema/issues)

For now, please fork this repo, make your changes there, and submit a PR.  If you want less hassle and plan on working on this a bunch, contact `@Brent Brewington` in [dbt Slack](https://getdbt.slack.com)

Try to follow [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) - basically, small set of changes on fork/branch that shouldn't live too long before getting merged (Merge conflicts, while manageable, add chaos)

I'm going to use ChatGPT to create clickbait commit messages.  You can too: [Tweet by @shaundai](https://twitter.com/shaundai/status/1598299932313931777)
