#!/bin/bash

# set working directory to top level of repo
cd $(git rev-parse --show-toplevel)

# set up virtual environment and activate it
python -m venv venv
source venv/bin/activate

# Install Python libraries (user)
pip install -r requirements.txt

# default dbt to look in current directory whenever the dbt command is used
# note, it will be relative to whatever the working directory is (we're going to change it in next step)
export DBT_PROFILES_DIR=.

# Add venv* to .gitignore file - if 'venv*' not in .gitignore, appends it
# (-q: be quiet, -x: match the whole line, -F: pattern is a plain string)
# taken from: https://stackoverflow.com/questions/3557037/appending-a-line-to-a-file-only-if-it-does-not-already-exist
grep -qxF 'venv*' .gitignore || echo 'venv*' >> .gitignore

# change working directory to dbt project
cd dbt_bigquery_info_schema

# test 
dbt debug
