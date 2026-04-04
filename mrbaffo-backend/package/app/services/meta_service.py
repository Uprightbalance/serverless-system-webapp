from app.repositories.business import BusinessRepository


class MetaService:
    """Application service for business metadata."""

    def __init__(self, repository: BusinessRepository):
        self.repository = repository

    @property
    def services(self) -> list[dict]:
        return self.repository.get_services()

    @property
    def areas(self) -> list[dict]:
        return self.repository.get_areas()

    def get_company_info(self) -> dict | None:
        return self.repository.get_company_info()
