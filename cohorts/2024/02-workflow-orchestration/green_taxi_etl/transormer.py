from pandas import DataFrame, to_datetime
import math

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

def select_number_columns(df: DataFrame) -> DataFrame:
    return df[['Age', 'Fare', 'Parch', 'Pclass', 'SibSp', 'Survived']]


def rename_camel_case(column: str) -> str:
    """
        Rename column in Camel Case to Snake Case, e.g. VendorID to vendor_id.

    """
    lowered_column = column[0].lower()
    for i in range(1,len(column)):
        lowered_column += f"_{column[i].lower()}" if column[i].isupper() else column[i]
    return lowered_column

@transformer
def transform_df(df: DataFrame, *args, **kwargs) -> DataFrame:
    """
    Remove rows where the passenger count is equal to 0 or the trip distance is equal to zero.
    Create a new column lpep_pickup_date by converting lpep_pickup_datetime to a date.
    Rename columns in Camel Case to Snake Case, e.g. VendorID to vendor_id.


    Add more parameters to this function if this block has multiple parent blocks.
    There should be one parameter for each output variable from each parent block.

    Args:
        df (DataFrame): Data frame from parent block.

    Returns:
        DataFrame: Transformed data frame
    """
    filtered_rows_df = df[(df['passenger_count'] > 0)  & (df['trip_distance'].astype('float64') > 0.0) ]
    filtered_rows_df['lpep_pickup_date'] = to_datetime(filtered_rows_df['lpep_pickup_datetime']).dt.date
    filtered_rows_df.columns = filtered_rows_df.columns.str.replace('(?<=[a-z])(?=[A-Z])', '_', regex=True).str.lower()
    print(filtered_rows_df['vendor_id'].unique())
    print(df.columns)
    print(filtered_rows_df.columns)
    return filtered_rows_df


@test
def test_output(df) -> None:
    """
    vendor_id is one of the existing values in the column (currently)
    passenger_count is greater than 0
    trip_distance is greater than 0
    """ 
    assert df['vendor_id'].notnull().all(), 'passenger count should be greater than 0'
    assert (df['passenger_count']>0).all(), 'passenger count should be greater than 0'
    assert (df['trip_distance']>0.0).all(), 'trip distance should be greater than 0'

