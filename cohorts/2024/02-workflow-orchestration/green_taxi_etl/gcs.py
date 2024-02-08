from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from pandas import DataFrame
from os import path
import os
import pyarrow as pa
import pyarrow.parquet as pq
if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_google_cloud_storage(df: DataFrame, **kwargs) -> None:
    """
    Template for exporting data to a Google Cloud Storage bucket.
    Specify your configuration settings in 'io_config.yaml'.

    Docs: https://docs.mage.ai/design/data-loading#googlecloudstorage
    """
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/home/src/personal-gcp.json"
    

    bucket_name = 'mage-zoomcamp-ibrahim'
    object_key = 'green_taxi_data.parquet'
    root_path =f"{bucket_name}/{object_key}" 
    partition_cols=["lpep_pickup_date"],
    print(root_path)
    table = pa.Table.from_pandas(df)
    gcs = pa.fs.GcsFileSystem()
    pq.write_to_dataset(
        table,
        root_path=root_path,
        partition_cols=partition_cols,
        filesystem=gcs,
        existing_data_behavior="delete_matching"
    )

