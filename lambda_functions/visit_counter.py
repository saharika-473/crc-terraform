import boto3
import json

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visit-counter')

def lambda_handler(event, context):
    response = table.get_item(Key= {'id' : 'count'} )
    count = response["Item"]["visitor_count"]

    new_count = str(int(count)+1)
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