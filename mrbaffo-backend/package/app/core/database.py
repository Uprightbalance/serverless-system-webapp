import boto3

from app.core.config import get_settings

settings = get_settings()

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(settings.dynamodb_table_name)


def get_table():
    """Return DynamoDB table resource."""
    return table


def init_db() -> None:
    """No-op for DynamoDB; table is managed by Terraform."""
    return
