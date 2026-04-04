from typing import Optional

from pydantic import BaseModel, EmailStr, Field


class ContactRequestCreate(BaseModel):
    """Payload for creating a contact request."""

    name: str = Field(..., max_length=255)
    email: EmailStr = Field(...)
    phone: Optional[str] = Field(default=None, max_length=50)
    message: str = Field(..., max_length=2000)


class ContactRequestRead(BaseModel):
    """Contact request as returned by the API."""

    id: str
    name: str
    email: EmailStr
    phone: Optional[str]
    message: str
    created_at: str
