import boto3
import json
import os

env = os.environ.get('environment_acronym')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(f'rahul-crc-use1-{env}-visit-counter-table')

def initialize_count():
    response = table.get_item(Key={'id': 'count'})
    if 'Item' not in response:
        # 'count' item doesn't exist, initialize it with the initial count value
        table.put_item(Item={'id': 'count', 'visitor_count': '1'})


# Initialize the 'count' item if it doesn't exist
initialize_count()

def lambda_handler(event, context):
    print(event,context)
    print(event['requestContext']['identity']['sourceIp'])
    response = table.get_item(Key={'id': 'count'})
    
    if 'Item' not in response:
        # 'count' item doesn't exist, initialize it
        initialize_count()
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Item initialized with initial count'}),
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
        }

    count = response["Item"]["visitor_count"]
    new_count = str(int(count) + 1)
    
    response = table.update_item(
        Key={'id': 'count'},
        UpdateExpression='set visitor_count = :c',
        ExpressionAttributeValues={':c': new_count},
        ReturnValues='UPDATED_NEW'
    )

    return {
        'statusCode': 200,
        'body': json.dumps(response),
        'headers': {
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': '*'
        },
    }
