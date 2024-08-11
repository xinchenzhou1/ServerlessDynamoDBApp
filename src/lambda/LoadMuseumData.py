import json
import argparse
import boto3
from pprint import pprint, pformat
import time
from decimal import Decimal

def load_dataset(dataset, targettable):

    region=boto3.session.Session().region_name

    dynamodb = boto3.resource('dynamodb', region_name=region) # low-level client
    table = dynamodb.Table(targettable)

    for dataitem in dataset:           # loop over each item in the dataset
        try:
            response = table.put_item(Item=dataitem)     # Use the put_item function to add each item to the table
        # handle error responses
        except ClientError as error:
            return error.response['Error']['Message']
        except Exception as error:
            print(error)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("tablename", help="name of the dynamodb table to target")   # Grab the name of the table and json file with data as command line arguments
    parser.add_argument("datafile", help="location of text data file, ex: museumlists.json")
    args = parser.parse_args()

    with open(args.datafile,"r") as json_file:
            data_list = json.load(json_file, parse_float=Decimal)     # take advantage of json.load class to ingest the data into a Python object
            load_dataset(data_list, args.tablename)  
            json_file.close()
