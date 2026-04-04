from app.schemas.contact_request import ContactRequestCreate


class ContactService:
    def __init__(self, repository):
        self.repository = repository

    def create_contact_request(self, payload: ContactRequestCreate):
        return self.repository.create(payload)
