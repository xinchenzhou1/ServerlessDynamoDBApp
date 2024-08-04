import json
from pprint import pprint
import boto3
from boto3.dynamodb.conditions import Key, Attr
import time
from decimal import *
import os
from botocore.exceptions import ClientError

def lambda_handler(event,context):
    region=boto3.session.Session().region_name
    dynamodb = boto3.resource('dynamodb', region_name=region) #low-level Client
    table = dynamodb.Table(os.environ['tablename']) #define which dynamodb table to access

    try:
        response = table.put_item(     # since the Item is already in a json format as part of the incoming event object, we can pass it
        Item=event["Item"]             # directly to the put_item function 
        )
        return response
    # handle error responses
    except ClientError as error:
        return error.response['Error']['Message']
    except Exception as error:
        print(error)
