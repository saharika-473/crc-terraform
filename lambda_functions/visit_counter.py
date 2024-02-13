import boto3
import json
import os
import hashlib
from datetime import datetime, timedelta, timezone

# Set the timezone to Indian Standard Time (IST)
IST = timezone(timedelta(hours=5, minutes=30))

env = os.environ.get('environment_acronym')
dynamodb = boto3.resource('dynamodb')
visit_counter = dynamodb.Table(f'rahul-crc-use1-{env}-visit-counter-table')
ip_table = dynamodb.Table(f'rahul-crc-use1-{env}-unique-ipaddress-table')

def initialize_count():
    try:
        response = visit_counter.get_item(Key={'id': 'count'})
        if 'Item' not in response:
            # 'count' item doesn't exist, initialize it with the initial count value
            visit_counter.put_item(Item={'id': 'count', 'visitor_count': 1})
    except Exception as e:
        print("Error initializing count:", e)

def hash_ip(ip_address):
    # Hash the IP address to protect privacy
    return hashlib.sha256(ip_address.encode()).hexdigest()

def is_unique_visitor(ip_address, timeframe):
    try:
        # Get the item from the IP table
        response = ip_table.get_item(Key={'ip_address': hash_ip(ip_address)})
        if 'Item' not in response:
            # IP address doesn't exist, it's a unique visitor
            return True
        else:
            # Check if the last visit time is within the specified timeframe
            last_visit_time = response['Item'].get('LastVisitTime')
            if last_visit_time:
                last_visit_time = datetime.fromisoformat(last_visit_time.replace('Z', '+00:00'))
                # Check if the last visit time is older than the current time minus the timeframe
                if datetime.now(IST) - last_visit_time > timedelta(hours=timeframe):
                    return True
            else:
                # If last visit time doesn't exist, it's a unique visitor
                return True
    except Exception as e:
        print("Error checking uniqueness:", e)
    return False


def update_visitor_count():
    try:
        # Increment the visitor count
        response = visit_counter.update_item(
            Key={'id': 'count'},
            UpdateExpression='SET visitor_count = if_not_exists(visitor_count, :val)',
            ExpressionAttributeValues={':val': 1},
            ReturnValues='UPDATED_NEW'
        )
    except Exception as e:
        print("Error updating visitor count:", e)


def update_last_visit_time(ip_address):
    try:
        # Update the last visit time for the hashed IP address
        ip_table.update_item(
            Key={'ip_address': hash_ip(ip_address)},
            UpdateExpression='SET LastVisitTime = :time',
            ExpressionAttributeValues={':time': str(datetime.now(IST))},
            ConditionExpression='attribute_not_exists(ip_address_hash)'  # Only update if IP address doesn't exist
        )
    except Exception as e:
        print("Error updating last visit time:", e)

def lambda_handler(event, context):
    ip_address = event['requestContext']['identity']['sourceIp']

    # Check if the visitor is unique within the past hour
    if is_unique_visitor(ip_address, timeframe=1):  # Set timeframe to 1 hour
        # Visitor is unique, update visitor count and last visit time
        update_visitor_count()
        update_last_visit_time(ip_address)

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
        # Visitor is a repeat visitor within the past hour
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Visitor already counted as unique within the past hour.'}),
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
        }
