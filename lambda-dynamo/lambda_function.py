
import boto3
import json

ddb = boto3.resource('dynamodb')
table = ddb.Table('MusicCollection')


def insert():
    table.put_item(
        Item={
            'Artist': "Bob Builder",
            'SongTitle': "Dig dig",
        }
    ) 
    print("PutItem succeeded:")


def read():
    response = table.get_item(
        Key={
            'Artist': "Bob Builder",
            'SongTitle': "Dig dig",
        }
    )
    print(response['Item'])
    print("Read Item succeeded:")


def update():
    print("Update Item succeeded:")



def lambda_handler(event, context):
    # TODO implement
    print("Hello from Lambda!")
    print(f"event: {event}")
    print(f"context: {context}")
    print("Log stream name:", context.log_stream_name)
    print("Log group name:",  context.log_group_name)
    print("Request ID:",context.aws_request_id)
    print("Mem. limits(MB):", context.memory_limit_in_mb)

    insert()
    read()
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda for Dynamo Management!')
    }

