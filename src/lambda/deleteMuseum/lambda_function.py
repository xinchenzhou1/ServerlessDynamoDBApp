import json
from pprint import pprint
import boto3
from boto3.dynamodb.conditions import Key, Attr
import time
from decimal import *
from botocore.exceptions import ClientError
import os

def lambda_handler(event,context):
    region=boto3.session.Session().region_name
    dynamodb = boto3.resource('dynamodb', region_name=region) #low-level Client
    table = dynamodb.Table(os.environ['tablename']) #define which dynamodb table to access

    try:
        delstatus = table.delete_item(                    # perform delete
            Key={
                'CollectionHighlight': event["CollectionHighlight"],
                'MuseumName': event["MuseumName"]
            },
            ConditionExpression = "attribute_not_exists(#R) OR (#R > :min)",   # specifying the condition for deleting the item, with placeholders for actual names and values
            ExpressionAttributeNames = { '#R' : "Rating" },                      # providing the actual attribute name here, since rank is a reserved word in DynamoDB
            ExpressionAttributeValues={ ':min': 10 }                          # providing the numerical value here, since entering the number in the ConditionExpression would be read as a string
        )
        return delstatus
    except ClientError as error:
        return error.response['Error']['Message']
    except Exception as error:
        print(error)
