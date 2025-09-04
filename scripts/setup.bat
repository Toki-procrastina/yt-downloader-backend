@echo off
echo ========================================
echo   YouTube Downloader Backend Setup
echo ========================================
echo.

:: Verificar si Python está instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python no está instalado o no está en el PATH
    echo    Descarga Python desde: https://python.org
    pause
    exit /b 1
)
echo ✓ Python encontrado

:: Verificar si pip está disponible
pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ pip no está disponible
    pause
    exit /b 1
)
echo ✓ pip encontrado

:: Crear entorno virtual (opcional)
echo.
set /p create_venv="¿Crear entorno virtual? (y/N): "
if /i "%create_venv%"=="y" (
    echo Creando entorno virtual...
    python -m venv venv
    call venv\Scripts\activate.bat
    echo ✓ Entorno virtual creado y activado
)

:: Instalar dependencias
echo.
echo Instalando dependencias...
pip install -r requirements.txt
if errorlevel 1 (
    echo ❌ Error instalando dependencias
    pause
    exit /b 1
)
echo ✓ Dependencias instaladas

:: Configurar archivo .env
echo.
if not exist .env (
    echo Creando archivo de configuración...
    copy .env.example .env >nul
    echo ✓ Archivo .env creado desde .env.example
    echo.
    echo ⚠️ IMPORTANTE: Edita el archivo .env con tus configuraciones
    echo    - Cambia SECRET_KEY por una clave segura
    echo    - Cambia las credenciales por defecto
    echo    - Configura ALLOWED_ORIGINS para tu dominio
) else (
    echo ✓ Archivo .env ya existe
)

:: Crear directorio de descargas
if not exist downloads mkdir downloads
echo ✓ Directorio downloads creado

:: Generar clave secreta
echo.
set /p gen_secret="¿Generar nueva clave secreta? (y/N): "
if /i "%gen_secret%"=="y" (
    echo Generando clave secreta...
    python generate_secret.py
)

echo.
echo ========================================
echo   ✅ Instalación completada
echo ========================================
echo.
echo Para iniciar el servidor:
echo   python start.py
echo.
echo Para probar la API:
echo   python test_api.py
echo.
echo Documentación de la API:
echo   http://localhost:8000/docs
echo.
echo ⚠️ Recuerda configurar el archivo .env antes de usar en producción
echo.
pause
