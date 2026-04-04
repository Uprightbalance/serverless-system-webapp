from dataclasses import dataclass


@dataclass
class ContactRequest:
    id: str
    entity_type: str
    name: str
    email: str
    phone: str | None
    message: str
    created_at: str
