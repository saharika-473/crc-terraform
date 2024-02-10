import boto3
import json
import os

env = os.environ.get('environment_acronym')
dynamodb = boto3.resource('dynamodb')
visit_counter = dynamodb.Table(f'rahul-crc-use1-{env}-visit-counter-table')
ip_table = dynamodb.Table(f'rahul-crc-use1-{env}-unique-ipaddress-table')

def initialize_count():
    response = visit_counter.get_item(Key={'id': 'count'})
    if 'Item' not in response:
        # 'count' item doesn't exist, initialize it with the initial count value
        visit_counter.put_item(Item={'id': 'count', 'visitor_count': '1'})


# Initialize the 'count' item if it doesn't exist
initialize_count()

def lambda_handler(event, context):
    ip_address = event['requestContext']['identity']['sourceIp']

    # Check if the IP address already exists in the DynamoDB table
    response = ip_table.get_item(Key={'ip_address': ip_address})

    if 'Item' not in response:
        # IP address doesn't exist, it's a unique visitor
        # Add the IP address to the table
        ip_table.put_item(Item={'ip_address': ip_address})

        # Increment the visitor count
        response = visit_counter.update_item(
            Key={'id': 'count'},
            UpdateExpression='SET visitor_count = if_not_exists(visitor_count, :init) + :val',
            ExpressionAttributeValues={':init': 1, ':val': 1},
            ReturnValues='UPDATED_NEW'
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Unique Visitor Count Updated'}),
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
        }
    else:
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Visitor already counted as unique.'}),
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
        }
