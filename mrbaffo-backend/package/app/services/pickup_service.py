from app.schemas.pickup_request import PickupRequestCreate


class PickupService:
    def __init__(self, repository):
        self.repository = repository

    def create_pickup_request(self, payload: PickupRequestCreate):
        return self.repository.create(payload)
