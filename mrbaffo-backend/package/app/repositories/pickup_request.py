from datetime import datetime, timezone
from uuid import uuid4

from app.schemas.pickup_request import PickupRequestCreate


class PickupRequestRepository:
    def __init__(self, table):
        self.table = table

    def create(self, payload: PickupRequestCreate) -> dict:
        item = {
            "id": str(uuid4()),
            "entity_type": "pickup",
            "customer_name": payload.customer_name,
            "phone": payload.phone,
            "email": payload.email,
            "address": payload.address,
            "service_type": payload.service_type,
            "preferred_date": payload.preferred_date,
            "notes": payload.notes,
            "created_at": datetime.now(timezone.utc).isoformat(),
        }

        self.table.put_item(Item=item)
        return item
