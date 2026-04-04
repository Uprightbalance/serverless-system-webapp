import boto3

TABLE_NAME = "serverless-app-table-staging-3454"
REGION = "us-east-1"

dynamodb = boto3.resource("dynamodb", region_name=REGION)
table = dynamodb.Table(TABLE_NAME)

items = [
    {
        "PK": "COMPANY",
        "SK": "INFO",
        "name": "Mr Baffo",
        "email": "info@mrbaffo.com",
        "phone": "08012345678",
        "tagline": "Reliable waste pickup and recycling services",
    },
    {
        "PK": "SERVICE",
        "SK": "SERVICE#1",
        "title": "Waste Pickup",
        "description": "Scheduled residential and commercial waste collection",
    },
    {
        "PK": "SERVICE",
        "SK": "SERVICE#2",
        "title": "Recycling",
        "description": "Environmentally responsible recycling services",
    },
    {
        "PK": "AREA",
        "SK": "AREA#1",
        "name": "Wuse",
    },
    {
        "PK": "AREA",
        "SK": "AREA#2",
        "name": "Gwarinpa",
    },
]

for item in items:
    table.put_item(Item=item)

print("Seed data inserted successfully.")
