from mage_ai.data_preparation.repo_manager import get_repo_path
from mage_ai.io.bigquery import BigQuery
from mage_ai.io.config import ConfigFileLoader
from pandas import DataFrame
from os import path

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_big_query(data, **kwargs) -> None:
    """
    Exports all dimension and fact tables to Google BigQuery.

    Iterates over the dictionary of DataFrames produced by the
    transformer block and loads each one into BigQuery using
    the credentials configured in io_config.yaml.

    Table naming convention:
        <project_id>.<dataset>.<table_name>

    Update YOUR_PROJECT_ID with your actual GCP project ID.
    Update the dataset name if you used a different one.
    """
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    for key, value in data.items():
        table_id = 'YOUR_PROJECT_ID.uber_data_engineering_yt.{}'.format(key)
        BigQuery.with_config(ConfigFileLoader(config_path, config_profile)).export(
            DataFrame(value),
            table_id,
            if_exists='replace',  # Overwrites table on each run (idempotent)
        )
        print(f'Exported table: {key} -> {table_id}')
