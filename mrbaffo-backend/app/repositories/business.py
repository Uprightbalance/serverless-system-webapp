from boto3.dynamodb.conditions import Key

from app.core.database import table


class BusinessRepository:
    """Repository for static business/meta data stored in DynamoDB."""

    def get_services(self) -> list[dict]:
        response = table.query(
            KeyConditionExpression=Key("PK").eq("SERVICE")
        )
        return response.get("Items", [])

    def get_areas(self) -> list[dict]:
        response = table.query(
            KeyConditionExpression=Key("PK").eq("AREA")
        )
        return response.get("Items", [])

    def get_company_info(self) -> dict | None:
        response = table.get_item(
            Key={
                "PK": "COMPANY",
                "SK": "INFO",
            }
        )
        return response.get("Item")
