@echo off
echo ========================================
echo   🔌 Activando Entorno Virtual
echo ========================================

if not exist "yt-downloader-env" (
    echo ❌ Entorno virtual no encontrado
    echo.
    echo Ejecuta primero: setup-venv.bat
    pause
    exit /b 1
)

echo ✅ Activando entorno virtual...
call yt-downloader-env\Scripts\activate.bat

echo.
echo 🎯 Entorno virtual activado
echo.
echo Comandos disponibles:
echo   python start.py          - Iniciar servidor
echo   python test_api.py       - Probar API
echo   python generate_secret.py - Generar clave secreta
echo   deactivate               - Desactivar entorno
echo.
echo Documentación: http://localhost:8000/docs
echo.

cmd /k
