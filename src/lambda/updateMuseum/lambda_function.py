import json
import boto3
from decimal import Decimal
from botocore.exceptions import ClientError
import os

def lambda_handler(event, context):
    region=boto3.session.Session().region_name
    dynamodb = boto3.resource('dynamodb', region_name=region) #low-level Client
    table = dynamodb.Table(os.environ['tablename']) #define which dynamodb table to access

    try:
        response = table.update_item(                     # we want to use the update_item function here
            Key={
                'MuseumName': event["Item"]["MuseumName"],
                'CollectionHighlight': event["Item"]["CollectionHighlight"]
            },
            UpdateExpression="set MuseumType=:t, #R=:r, #CO=:co, #CI=:ci",     # We have to use placeholders for not only values, but attribute names since "Year" and "Rank" are reserved words
            ExpressionAttributeNames = { '#R' : "Rating", '#CO' : "Country", "#CI" : "City" },  # specifying the actual attribute names
            ExpressionAttributeValues={                                   # linking the values for the attributes we want changed to the incoming event data
               ':r': Decimal(event["Item"]["Rating"]),
               ':t': event["Item"]["MuseumType"],
               ':co': event["Item"]["Country"],
               ':ci': event["Item"]["City"]
            },
            ReturnValues="UPDATED_NEW"
        )
        return response['Attributes']
    # handle error responses
    except ClientError as error:
        return ClientError
    except Exception as error:
        print(error)
