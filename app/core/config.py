from pydantic_settings import BaseSettings
from typing import List
import os

class Settings(BaseSettings):
    # Seguridad
    secret_key: str = "tu_clave_secreta_muy_segura_aqui_cambiar_en_produccion"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # Credenciales de la API
    api_username: str = "admin"
    api_password: str = "password123"
    
    # Servidor
    host: str = "0.0.0.0"
    port: int = 8000
    debug: bool = False
    
    # Directorios
    download_dir: str = "./data/downloads"
    
    # Rate limiting
    rate_limit_requests: int = 10
    rate_limit_window: int = 60
    
    # CORS
    allowed_origins: str = "http://localhost:3000"
    
    @property
    def allowed_origins_list(self) -> List[str]:
        return [origin.strip() for origin in self.allowed_origins.split(",")]
    
    model_config = {"env_file": ".env"}

settings = Settings()
