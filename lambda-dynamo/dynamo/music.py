import boto3


ddb = boto3.resource('dynamodb')
table = ddb.Table('MusicCollection')

def create():
    pass



def insert():
    table.put_item(
        Item={
            'Artist': "Bob Builder",
            'SongTitle': "Dig dig",
        }
    )
    print("Insert Item succeeded:")

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


def delete():
    pass





