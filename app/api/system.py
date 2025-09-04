from fastapi import APIRouter, Depends, HTTPException, status, Request
from datetime import datetime
from slowapi import Limiter
from slowapi.util import get_remote_address
import os
import logging

from app.models.schemas import HealthResponse
from app.services.downloader import downloader
from app.core.auth import get_current_user
from app.core.config import settings

router = APIRouter(tags=["system"])

limiter = Limiter(key_func=get_remote_address)
logger = logging.getLogger(__name__)

@router.get("/", include_in_schema=False)
async def root():
    """Endpoint raíz"""
    return {"message": "YouTube Downloader API", "version": "1.0.0"}

@router.get("/health", response_model=HealthResponse)
@limiter.limit(f"{settings.rate_limit_requests}/minute")
async def health_check(request: Request):
    """Verificar estado del servidor"""
    return HealthResponse(
        status="healthy",
        timestamp=datetime.now().isoformat(),
        download_dir_exists=os.path.exists(settings.download_dir)
    )

@router.delete("/cleanup")
@limiter.limit(f"{settings.rate_limit_requests}/minute")
async def cleanup_files(request: Request, current_user: str = Depends(get_current_user)):
    """Limpiar archivos antiguos (solo para administradores)"""
    try:
        downloader.cleanup_old_files()
        logger.info(f"Usuario {current_user} ejecutó limpieza de archivos")
        return {"message": "Limpieza completada"}
    except Exception as e:
        logger.error(f"Error en limpieza: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Error en limpieza"
        )
