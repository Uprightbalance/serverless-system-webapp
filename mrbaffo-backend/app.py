import os
import boto3
from mangum import Mangum

# Import your FastAPI app
from app.main import app

# DynamoDB setup (optional for now)
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ.get('TABLE_NAME', 'default-table'))

# Lambda handler
handler = Mangum(app)
