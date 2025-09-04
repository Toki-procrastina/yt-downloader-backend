from pydantic import BaseModel
from typing import Optional

class LoginRequest(BaseModel):
    """Modelo para request de login"""
    username: str
    password: str

class DownloadRequest(BaseModel):
    """Modelo para request de descarga"""
    url: str
    quality: str = "best"

class VideoInfo(BaseModel):
    """Información del video"""
    title: str
    duration: int
    uploader: str
    view_count: int
    upload_date: str
    description: str

class DownloadResponse(BaseModel):
    """Respuesta de descarga"""
    success: bool
    title: str
    duration: int
    uploader: str
    filename: str
    message: str

class Token(BaseModel):
    """Token de autenticación"""
    access_token: str
    token_type: str

class TokenData(BaseModel):
    """Datos del token"""
    username: Optional[str] = None

class User(BaseModel):
    """Usuario básico"""
    username: str

class UserInDB(User):
    """Usuario en base de datos"""
    hashed_password: str

class HealthResponse(BaseModel):
    """Respuesta de health check"""
    status: str
    timestamp: str
    download_dir_exists: bool

class ErrorResponse(BaseModel):
    """Respuesta de error"""
    detail: str
    error_code: Optional[str] = None
