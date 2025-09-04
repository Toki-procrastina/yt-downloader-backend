@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   🐍 Instalador de Entorno Virtual
echo   YouTube Downloader Backend
echo ========================================
echo.

echo Selecciona el método de instalación:
echo.
echo 1. venv (Recomendado - incluido en Python)
echo 2. conda (Si tienes Anaconda/Miniconda)
echo 3. virtualenv (Instalación separada)
echo 4. Docker (Sin Python local)
echo 5. Instalación global (No recomendado)
echo.

set /p choice="Elige una opción (1-5): "

if "%choice%"=="1" goto venv_install
if "%choice%"=="2" goto conda_install
if "%choice%"=="3" goto virtualenv_install
if "%choice%"=="4" goto docker_install
if "%choice%"=="5" goto global_install

echo Opción no válida
pause
exit /b 1

:venv_install
echo.
echo 📦 Instalación con venv...
call setup-venv.bat
goto end

:conda_install
echo.
echo 📦 Instalación con conda...
echo.

:: Verificar si conda está disponible
conda --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Conda no está instalado
    echo.
    echo Instala Anaconda o Miniconda desde:
    echo https://www.anaconda.com/products/distribution
    echo https://docs.conda.io/en/latest/miniconda.html
    pause
    exit /b 1
)

echo ✅ Conda encontrado
conda --version

:: Crear entorno conda
echo.
echo Creando entorno conda...
conda create -n yt-downloader python=3.11 -y
if errorlevel 1 (
    echo ❌ Error creando entorno conda
    pause
    exit /b 1
)

echo ✅ Entorno conda creado

:: Activar entorno
echo.
echo Activando entorno conda...
call conda activate yt-downloader
if errorlevel 1 (
    echo ❌ Error activando entorno conda
    pause
    exit /b 1
)

:: Instalar pip en el entorno conda
conda install pip -y

:: Instalar dependencias
echo.
echo Instalando dependencias...
pip install -r requirements.txt
if errorlevel 1 (
    echo ❌ Error instalando dependencias
    pause
    exit /b 1
)

echo ✅ Instalación completada con conda
echo.
echo Para usar:
echo conda activate yt-downloader
echo python start.py
goto end

:virtualenv_install
echo.
echo 📦 Instalación con virtualenv...
echo.

:: Verificar si virtualenv está instalado
virtualenv --version >nul 2>&1
if errorlevel 1 (
    echo Instalando virtualenv...
    pip install virtualenv
    if errorlevel 1 (
        echo ❌ Error instalando virtualenv
        pause
        exit /b 1
    )
)

echo ✅ virtualenv disponible

:: Crear entorno
echo.
echo Creando entorno virtual...
virtualenv yt-downloader-env
if errorlevel 1 (
    echo ❌ Error creando entorno virtual
    pause
    exit /b 1
)

:: Activar y continuar
call yt-downloader-env\Scripts\activate.bat
pip install --upgrade pip
pip install -r requirements.txt

echo ✅ Instalación completada con virtualenv
goto end

:docker_install
echo.
echo 🐳 Instalación con Docker...
echo.

:: Verificar si Docker está disponible
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker no está instalado
    echo.
    echo Instala Docker desde:
    echo https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo ✅ Docker encontrado
docker --version

echo.
echo Construyendo imagen Docker...
docker build -t yt-downloader .
if errorlevel 1 (
    echo ❌ Error construyendo imagen
    pause
    exit /b 1
)

echo ✅ Imagen Docker creada

echo.
echo Para ejecutar el servidor:
echo docker run -p 8000:8000 yt-downloader
echo.
echo O usar docker-compose:
echo docker-compose up -d

goto end

:global_install
echo.
echo ⚠️  Instalación global (NO RECOMENDADO)
echo.
echo Esto instalará las librerías en el Python del sistema
echo y puede causar conflictos con otras aplicaciones.
echo.
set /p confirm="¿Estás seguro? (y/N): "
if not "!confirm!"=="y" (
    echo Instalación cancelada
    goto end
)

echo.
echo Instalando dependencias globalmente...
pip install -r requirements.txt
if errorlevel 1 (
    echo ❌ Error en instalación global
    pause
    exit /b 1
)

echo ✅ Instalación global completada
echo ⚠️  Recuerda los riesgos de la instalación global

:end
echo.
echo ========================================
echo   🎉 ¡Proceso completado!
echo ========================================
pause
