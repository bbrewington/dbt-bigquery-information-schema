from bs4 import BeautifulSoup
import pandas as pd

def get_local_html_element(local_html_file, selector='.devsite-table-wrapper > table'):
    """Note: local_html_file needs to be manually downloaded from Google's docs site:
       https://cloud.google.com/bigquery/docs/information-schema-intro
    """

    print('reading local_html_file')
    with open(local_html_file) as f:
        html = f.read()
    
    soup = BeautifulSoup(html, 'html.parser')

    html_element = soup.select_one(selector)

    return(html_element)


def output_to_csv(local_html_file, output_csv_file):
    table_element = get_local_html_element(local_html_file)
    
    df = pd.read_html(str(table_element))[0]
    
    df.rename(columns={"Column name": "column_name", "Data type": "data_type", "Value": "value"},
              inplace=True)
    
    if df.shape[0] > 0:
        print('outputting to csv')
        df.to_csv(output_csv_file, index=False)


output_to_csv(local_html_file='/Users/brentbrewington/Downloads/GCP Info Schema - TABLES.html',
              output_csv_file='dbt_bigquery_info_schema/seeds/info_schema__table.csv')

output_to_csv(local_html_file='/Users/brentbrewington/Downloads/COLUMNS.html',
              output_csv_file='seeds/info_schema__columns.csv')

output_to_csv(local_html_file='/Users/brentbrewington/Downloads/column_field_paths.html',
              output_csv_file='seeds/info_schema__column_field_paths.csv')
