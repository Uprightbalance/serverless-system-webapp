from datetime import datetime, timezone
from uuid import uuid4

from app.schemas.contact_request import ContactRequestCreate


class ContactRequestRepository:
    def __init__(self, table):
        self.table = table

    def create(self, payload: ContactRequestCreate) -> dict:
        item = {
            "id": str(uuid4()),
            "entity_type": "contact",
            "name": payload.name,
            "email": payload.email,
            "phone": payload.phone,
            "message": payload.message,
            "created_at": datetime.now(timezone.utc).isoformat(),
        }

        self.table.put_item(Item=item)
        return item
