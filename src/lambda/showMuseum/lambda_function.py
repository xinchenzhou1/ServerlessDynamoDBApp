import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
import os
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    region=boto3.session.Session().region_name
    dynamodb = boto3.resource('dynamodb', region_name=region) #low-level Client
    table = dynamodb.Table(os.environ['tablename']) #define which dynamodb table to access

    if len(event['MuseumType']) > 0:
        try:
            totallist = table.query(                   # we want to use a query here for the most efficient data access
            IndexName="type-index",                   # specify the name of the GSI created on the Type attribute
            KeyConditionExpression = "MuseumType = :sortkeyval",     # Use a conditional expression with a placeholder to specify what key we want
            ExpressionAttributeValues = { ':sortkeyval' : event['MuseumType'] }  # give the actual value for the placeholder, which should equal the incoming event data
            )
        except ClientError as error:
            return error.response['Error']['Message']
        except BaseException as error:
            raise error
        return totallist['Items']
    else :
        try:
            scanreturn = table.scan()
            totallist = scanreturn['Items']

            while 'LastEvaluatedKey' in scanreturn.keys(): # if lastevaluatedkey is present, we need to keep scanning
                scanreturn = table.scan(
                    ExclusiveStartKey = scanreturn['LastEvaluatedKey']
                )
                totallist += scanreturn['Items']
            return totallist
        except ClientError as error:
            return error.response['Error']['Message']
        except Exception as error:
            print(error)
