import re
import os
import asyncio
import logging
from typing import Optional, Dict, Any
from pathlib import Path
import yt_dlp
from app.core.config import settings

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class YouTubeDownloader:
    def __init__(self):
        self.download_dir = Path(settings.download_dir)
        self.download_dir.mkdir(exist_ok=True)
        
    def validate_youtube_url(self, url: str) -> bool:
        """Validar que la URL sea de YouTube"""
        youtube_regex = re.compile(
            r'(https?://)?(www\.)?(youtube|youtu|youtube-nocookie)\.(com|be)/'
            r'(watch\?v=|embed/|v/|.+\?v=)?([^&=%\?]{11})'
        )
        return bool(youtube_regex.match(url))
    
    def get_video_info(self, url: str) -> Optional[Dict[str, Any]]:
        """Obtener información del video sin descargarlo"""
        try:
            ydl_opts = {
                'quiet': True,
                'no_warnings': True,
            }
            
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                info = ydl.extract_info(url, download=False)
                return {
                    'title': info.get('title', 'Unknown'),
                    'duration': info.get('duration', 0),
                    'uploader': info.get('uploader', 'Unknown'),
                    'view_count': info.get('view_count', 0),
                    'upload_date': info.get('upload_date', 'Unknown'),
                    'description': info.get('description', '')[:500] + '...' if info.get('description', '') else ''
                }
        except Exception as e:
            logger.error(f"Error obteniendo información del video: {str(e)}")
            return None
    
    async def download_video(self, url: str, quality: str = 'best') -> Dict[str, Any]:
        """Descargar video de YouTube"""
        try:
            # Validar URL
            if not self.validate_youtube_url(url):
                raise ValueError("URL de YouTube no válida")
            
            # Configurar opciones de descarga
            ydl_opts = {
                'format': self._get_format_selector(quality),
                'outtmpl': str(self.download_dir / '%(title)s.%(ext)s'),
                'restrictfilenames': True,
                'noplaylist': True,
                'max_filesize': 500 * 1024 * 1024,  # 500MB máximo
            }
            
            # Ejecutar descarga en un hilo separado para no bloquear
            loop = asyncio.get_event_loop()
            result = await loop.run_in_executor(
                None, self._download_with_ydl, url, ydl_opts
            )
            
            return result
            
        except Exception as e:
            logger.error(f"Error descargando video: {str(e)}")
            raise Exception(f"Error en la descarga: {str(e)}")
    
    def _get_format_selector(self, quality: str) -> str:
        """Obtener selector de formato según calidad"""
        quality_map = {
            'worst': 'worst',
            'best': 'best',
            '720p': 'best[height<=720]',
            '480p': 'best[height<=480]',
            '360p': 'best[height<=360]',
            'audio': 'bestaudio'
        }
        return quality_map.get(quality, 'best')
    
    def _download_with_ydl(self, url: str, ydl_opts: dict) -> Dict[str, Any]:
        """Ejecutar descarga con yt-dlp"""
        try:
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                # Obtener información primero
                info = ydl.extract_info(url, download=False)
                
                # Verificar duración (máximo 1 hora)
                duration = info.get('duration', 0)
                if duration > 3600:  # 1 hora en segundos
                    raise ValueError("Video demasiado largo (máximo 1 hora)")
                
                # Descargar
                ydl.download([url])
                
                # Buscar el archivo descargado
                title = info.get('title', 'unknown')
                safe_title = re.sub(r'[^\w\s-]', '', title).strip()
                
                return {
                    'success': True,
                    'title': title,
                    'duration': duration,
                    'uploader': info.get('uploader', 'Unknown'),
                    'filename': f"{safe_title}.{info.get('ext', 'mp4')}",
                    'message': 'Video descargado exitosamente'
                }
                
        except Exception as e:
            raise Exception(f"Error en yt-dlp: {str(e)}")
    
    def cleanup_old_files(self, max_age_hours: int = 24):
        """Limpiar archivos antiguos"""
        try:
            now = asyncio.get_event_loop().time()
            for file_path in self.download_dir.iterdir():
                if file_path.is_file():
                    file_age = now - file_path.stat().st_mtime
                    if file_age > max_age_hours * 3600:
                        file_path.unlink()
                        logger.info(f"Archivo eliminado: {file_path.name}")
        except Exception as e:
            logger.error(f"Error limpiando archivos: {str(e)}")

# Instancia global
downloader = YouTubeDownloader()
