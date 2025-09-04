#!/usr/bin/env python3
"""
Script de inicio para el servidor YouTube Downloader
Versión actualizada para la nueva estructura de carpetas
"""
import os
import sys
from pathlib import Path

def check_requirements():
    """Verificar que los requisitos estén instalados"""
    try:
        import fastapi
        import uvicorn
        import yt_dlp
        import jose
        import passlib
        print("✓ Todas las dependencias están instaladas")
        return True
    except ImportError as e:
        print(f"✗ Falta instalar dependencias: {e}")
        print("Ejecuta: pip install -r requirements.txt")
        return False

def setup_environment():
    """Configurar el entorno"""
    # Crear directorio de descargas
    download_dir = Path("data/downloads")
    download_dir.mkdir(parents=True, exist_ok=True)
    print(f"✓ Directorio de descargas creado: {download_dir.absolute()}")
    
    # Verificar archivo .env
    env_file = Path(".env")
    if not env_file.exists():
        example_file = Path(".env.example")
        if example_file.exists():
            import shutil
            shutil.copy(example_file, env_file)
            print("✓ Archivo .env creado desde .env.example")
            print("⚠️  IMPORTANTE: Edita el archivo .env con tus configuraciones")
        else:
            print("✗ No se encontró .env.example")
            return False
    else:
        print("✓ Archivo .env encontrado")
    
    return True

def main():
    """Función principal"""
    print("🚀 Iniciando YouTube Downloader Backend")
    print("=" * 50)
    
    # Verificar requisitos
    if not check_requirements():
        sys.exit(1)
    
    # Configurar entorno
    if not setup_environment():
        sys.exit(1)
    
    print("\n📋 Configuración:")
    print("- Puerto: 8000")
    print("- Host: 0.0.0.0")
    print("- Documentación: http://localhost:8000/docs")
    print("- Health check: http://localhost:8000/health")
    
    print("\n🔐 Credenciales por defecto:")
    print("- Usuario: admin")
    print("- Contraseña: password123")
    print("⚠️  CAMBIAR en producción!")
    
    print("\n🌐 Iniciando servidor...")
    print("=" * 50)
    
    # Agregar el directorio actual al path
    current_dir = Path(__file__).parent
    sys.path.insert(0, str(current_dir))
    
    # Importar y ejecutar
    try:
        import uvicorn
        from app.main import app
        from app.core.config import settings
        
        uvicorn.run(
            "app.main:app",
            host=settings.host,
            port=settings.port,
            reload=settings.debug
        )
    except KeyboardInterrupt:
        print("\n\n👋 Servidor detenido por el usuario")
    except Exception as e:
        print(f"\n\n❌ Error iniciando servidor: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
