
import boto3
import json






def insert():
    ddb = boto3.resource('dynamodb')
    table = ddb.Table('MusicCollection')
    table.put_item(
        Item={
            'Artist': "Bob Builder",
            'SongTitle': "Dig dig",
        }
    ) 
    print("PutItem succeeded:")
    pass



def lambda_handler(event, context):
    # TODO implement
    print("Hello from Lambda!")
    print(f"event: {event}")
    print(f"context: {context}")
    insert()
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda for Dynamo Management!')
    }



