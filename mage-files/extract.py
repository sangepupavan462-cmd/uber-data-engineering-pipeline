import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Loads Uber trip data from Google Cloud Storage.
    Fetches the NYC TLC Yellow Taxi trip records CSV file
    and returns it as a Pandas DataFrame.
    """
    url = 'https://storage.googleapis.com/uber-data-engineering-project-darshil/uber_data.csv'
    response = requests.get(url)
    return pd.read_csv(io.StringIO(response.text), sep=',')


@test
def test_output(output, *args) -> None:
    """
    Validates that the data loader returned a non-empty DataFrame.
    """
    assert output is not None, 'The output is undefined'
    assert len(output) > 0, 'The output DataFrame is empty'
