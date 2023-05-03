import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('viewCount')

def update_count():
    response = table.update_item(Key={'id':1},
        UpdateExpression = 'ADD viewCounter :inc',
        ExpressionAttributeValues = {':inc': 1}
    )
    
def get_count():
    response = table.get_item(Key={'id':1})
    viewCounter = response['Item']['viewCounter']
    return viewCounter
    
def lambda_handler(event, context):
    update_count()
    return {
        'statusCode': 200,
        'headers': {'Access-Control-Allow-Origin': '*','X-Requested-With': '*','Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Requested-With','Access-Control-Allow-Methods': 'GET, OPTIONS','Access-Control-Allow-Credentials': 'true'},
        'body': get_count()
    }



    