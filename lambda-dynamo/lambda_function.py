
import boto3
import json
from dynamo import music


def lambda_handler(event, context):
    # TODO implement
    print("Hello from Lambda!")

    # EVENT Vars
    print(f"event: {event}")
    key1 = event["key1"]
    print("Key1:", key1)

    # CONTEXT Vars
    print(f"context: {context}")
    print("Log stream name:", context.log_stream_name)
    print("Log group name:",  context.log_group_name)
    print("Request ID:",context.aws_request_id)
    print("Mem. limits(MB):", context.memory_limit_in_mb)

    music.insert()
    music.read()
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda for Dynamo Management!')
    }

