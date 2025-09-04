from fastapi import APIRouter, Depends, HTTPException, status, Request
from fastapi.responses import FileResponse
from slowapi import Limiter
from slowapi.util import get_remote_address
from pathlib import Path
import logging

from app.models.schemas import DownloadRequest, VideoInfo, DownloadResponse
from app.services.downloader import downloader
from app.core.auth import get_current_user
from app.core.config import settings

router = APIRouter(
    prefix="/video",
    tags=["video"]
)

limiter = Limiter(key_func=get_remote_address)
logger = logging.getLogger(__name__)

@router.post("/info", response_model=VideoInfo)
@limiter.limit(f"{settings.rate_limit_requests}/minute")
async def get_video_info(
    request: Request,
    video_request: DownloadRequest,
    current_user: str = Depends(get_current_user)
):
    """Obtener información del video sin descargarlo"""
    try:
        logger.info(f"Usuario {current_user} solicitando info de: {video_request.url}")
        
        info = downloader.get_video_info(video_request.url)
        if not info:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="No se pudo obtener información del video"
            )
        
        return VideoInfo(**info)
        
    except ValueError as e:
        logger.error(f"Error de validación: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        logger.error(f"Error obteniendo info del video: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Error interno del servidor"
        )

@router.post("/download", response_model=DownloadResponse)
@limiter.limit(f"{settings.rate_limit_requests}/minute")
async def download_video(
    request: Request,
    download_request: DownloadRequest,
    current_user: str = Depends(get_current_user)
):
    """Descargar video de YouTube"""
    try:
        logger.info(f"Usuario {current_user} descargando: {download_request.url}")
        
        # Validar calidad
        valid_qualities = ['worst', 'best', '720p', '480p', '360p', 'audio']
        if download_request.quality not in valid_qualities:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Calidad no válida. Opciones: {', '.join(valid_qualities)}"
            )
        
        result = await downloader.download_video(
            download_request.url,
            download_request.quality
        )
        
        logger.info(f"Descarga exitosa: {result['title']}")
        return DownloadResponse(**result)
        
    except ValueError as e:
        logger.error(f"Error de validación: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except Exception as e:
        logger.error(f"Error en descarga: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Error interno del servidor"
        )

@router.get("/download/{filename}")
@limiter.limit(f"{settings.rate_limit_requests}/minute")
async def get_downloaded_file(
    request: Request,
    filename: str,
    current_user: str = Depends(get_current_user)
):
    """Descargar archivo ya procesado"""
    try:
        file_path = Path(settings.download_dir) / filename
        
        if not file_path.exists():
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Archivo no encontrado"
            )
        
        logger.info(f"Usuario {current_user} descargando archivo: {filename}")
        return FileResponse(
            path=file_path,
            filename=filename,
            media_type='application/octet-stream'
        )
        
    except Exception as e:
        logger.error(f"Error sirviendo archivo: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Error sirviendo archivo"
        )
