from dataclasses import dataclass


@dataclass
class PickupRequest:
    id: str
    entity_type: str
    customer_name: str
    phone: str
    email: str | None
    address: str
    service_type: str
    preferred_date: str
    notes: str | None
    created_at: str
