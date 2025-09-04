@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   🐍 Setup Entorno Virtual - Windows
echo   YouTube Downloader Backend
echo ========================================
echo.

:: Verificar si Python está instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python no está instalado o no está en el PATH
    echo.
    echo Descarga Python desde: https://python.org
    echo Asegúrate de marcar "Add Python to PATH" durante la instalación
    pause
    exit /b 1
)

echo ✅ Python encontrado
python --version

:: Verificar si ya existe un entorno virtual
if exist "yt-downloader-env" (
    echo.
    echo ⚠️  Ya existe un entorno virtual
    set /p recreate="¿Quieres recrearlo? (y/N): "
    if /i "!recreate!"=="y" (
        echo Eliminando entorno existente...
        rmdir /s /q yt-downloader-env
    ) else (
        echo Usando entorno existente...
        goto :activate_env
    )
)

echo.
echo 📦 Creando entorno virtual...
python -m venv yt-downloader-env
if errorlevel 1 (
    echo ❌ Error creando entorno virtual
    echo.
    echo Posibles soluciones:
    echo 1. Instalar/actualizar Python
    echo 2. Ejecutar como administrador
    echo 3. Verificar permisos de escritura
    pause
    exit /b 1
)
echo ✅ Entorno virtual creado

:activate_env
echo.
echo 🔌 Activando entorno virtual...

:: Verificar si PowerShell permite la ejecución de scripts
powershell -Command "Get-ExecutionPolicy" | findstr "Restricted" >nul
if not errorlevel 1 (
    echo.
    echo ⚠️  PowerShell tiene restricciones de ejecución
    echo Configurando permisos para el usuario actual...
    powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
)

:: Activar entorno y continuar en el mismo proceso
call yt-downloader-env\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ Error activando entorno virtual
    pause
    exit /b 1
)

echo ✅ Entorno virtual activado

echo.
echo 📈 Actualizando pip...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo ⚠️  Error actualizando pip, continuando...
)

echo.
echo 📦 Instalando dependencias...
echo Esto puede tomar unos minutos...
pip install -r requirements.txt
if errorlevel 1 (
    echo ❌ Error instalando dependencias
    echo.
    echo Posibles soluciones:
    echo 1. Verificar conexión a internet
    echo 2. Usar: pip install --trusted-host pypi.org --trusted-host pypi.python.org -r requirements.txt
    echo 3. Revisar el archivo requirements.txt
    pause
    exit /b 1
)

echo.
echo ✅ Dependencias instaladas correctamente

echo.
echo 🧪 Verificando instalación...
python -c "import fastapi; print('✅ FastAPI:', fastapi.__version__)" 2>nul
if errorlevel 1 (
    echo ❌ Error verificando FastAPI
) else (
    echo ✅ FastAPI verificado
)

python -c "import yt_dlp; print('✅ yt-dlp verificado')" 2>nul
if errorlevel 1 (
    echo ❌ Error verificando yt-dlp
) else (
    echo ✅ yt-dlp verificado
)

python -c "from app.main import app; print('✅ Aplicación principal verificada')" 2>nul
if errorlevel 1 (
    echo ❌ Error verificando aplicación principal
) else (
    echo ✅ Aplicación principal verificada
)

echo.
echo 📁 Creando directorio de descargas...
if not exist "data\downloads" mkdir data\downloads
echo ✅ Directorio data\downloads creado

echo.
echo 📋 Configurando archivo .env...
if not exist ".env" (
    copy .env.example .env >nul
    echo ✅ Archivo .env creado desde .env.example
    echo.
    echo ⚠️  IMPORTANTE: Edita el archivo .env antes de usar en producción
    echo    - Cambia SECRET_KEY
    echo    - Cambia las credenciales por defecto
    echo    - Configura ALLOWED_ORIGINS
) else (
    echo ✅ Archivo .env ya existe
)

echo.
echo ========================================
echo   🎉 ¡Instalación completada!
echo ========================================
echo.
echo Para usar el proyecto:
echo.
echo 1. Activar entorno (cada vez que trabajes):
echo    yt-downloader-env\Scripts\activate.bat
echo.
echo 2. Ejecutar servidor:
echo    python start.py
echo.
echo 3. Acceder a la documentación:
echo    http://localhost:8000/docs
echo.
echo 4. Desactivar entorno (al terminar):
echo    deactivate
echo.
echo ========================================
echo.

set /p start_now="¿Quieres iniciar el servidor ahora? (y/N): "
if /i "!start_now!"=="y" (
    echo.
    echo 🚀 Iniciando servidor...
    python start.py
) else (
    echo.
    echo Para iniciar más tarde, ejecuta:
    echo yt-downloader-env\Scripts\activate.bat
    echo python start.py
)

echo.
pause
