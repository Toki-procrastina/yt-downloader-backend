#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================"
echo -e "  🐍 Setup Entorno Virtual - Linux/Mac"
echo -e "  YouTube Downloader Backend"
echo -e "========================================${NC}"
echo

# Función para mostrar mensajes
show_message() {
    echo -e "${GREEN}✅ $1${NC}"
}

show_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

show_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Detectar el comando Python correcto
PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    show_error "Python no está instalado o no está en el PATH"
    echo
    echo "Instala Python desde:"
    echo "- Ubuntu/Debian: sudo apt update && sudo apt install python3 python3-pip python3-venv"
    echo "- CentOS/RHEL: sudo yum install python3 python3-pip"
    echo "- macOS: brew install python3"
    echo "- O descarga desde: https://python.org"
    exit 1
fi

show_message "Python encontrado: $PYTHON_CMD"
$PYTHON_CMD --version

# Verificar si ya existe un entorno virtual
if [ -d "yt-downloader-env" ]; then
    echo
    show_warning "Ya existe un entorno virtual"
    read -p "¿Quieres recrearlo? (y/N): " recreate
    if [[ $recreate == "y" || $recreate == "Y" ]]; then
        echo "Eliminando entorno existente..."
        rm -rf yt-downloader-env
    else
        echo "Usando entorno existente..."
        source yt-downloader-env/bin/activate
        show_message "Entorno virtual activado"
        # Saltar creación pero continuar con verificaciones
        goto_install=true
    fi
fi

if [ "$goto_install" != true ]; then
    echo
    echo "📦 Creando entorno virtual..."
    $PYTHON_CMD -m venv yt-downloader-env
    if [ $? -ne 0 ]; then
        show_error "Error creando entorno virtual"
        echo
        echo "Posibles soluciones:"
        echo "1. Instalar python3-venv: sudo apt install python3-venv"
        echo "2. Verificar permisos de escritura"
        echo "3. Usar virtualenv: pip install virtualenv && virtualenv yt-downloader-env"
        exit 1
    fi
    show_message "Entorno virtual creado"

    echo
    echo "🔌 Activando entorno virtual..."
    source yt-downloader-env/bin/activate
    if [ $? -ne 0 ]; then
        show_error "Error activando entorno virtual"
        exit 1
    fi
    show_message "Entorno virtual activado"
fi

echo
echo "📈 Actualizando pip..."
pip install --upgrade pip
if [ $? -ne 0 ]; then
    show_warning "Error actualizando pip, continuando..."
fi

echo
echo "📦 Instalando dependencias..."
echo "Esto puede tomar unos minutos..."
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    show_error "Error instalando dependencias"
    echo
    echo "Posibles soluciones:"
    echo "1. Verificar conexión a internet"
    echo "2. Instalar dependencias del sistema:"
    echo "   Ubuntu/Debian: sudo apt install build-essential libssl-dev libffi-dev"
    echo "   CentOS/RHEL: sudo yum groupinstall 'Development Tools' && sudo yum install openssl-devel libffi-devel"
    echo "   macOS: xcode-select --install"
    echo "3. Usar trusted hosts: pip install --trusted-host pypi.org --trusted-host pypi.python.org -r requirements.txt"
    exit 1
fi

echo
show_message "Dependencias instaladas correctamente"

echo
echo "🧪 Verificando instalación..."

# Verificar FastAPI
if python -c "import fastapi; print('✅ FastAPI:', fastapi.__version__)" 2>/dev/null; then
    show_message "FastAPI verificado"
else
    show_error "Error verificando FastAPI"
fi

# Verificar yt-dlp
if python -c "import yt_dlp; print('✅ yt-dlp verificado')" 2>/dev/null; then
    show_message "yt-dlp verificado"
else
    show_error "Error verificando yt-dlp"
fi

# Verificar aplicación principal
if python -c "from app.main import app; print('✅ Aplicación principal verificada')" 2>/dev/null; then
    show_message "Aplicación principal verificada"
else
    show_error "Error verificando aplicación principal"
fi

echo
echo "📁 Creando directorio de descargas..."
mkdir -p data/downloads
show_message "Directorio data/downloads creado"

echo
echo "📋 Configurando archivo .env..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    show_message "Archivo .env creado desde .env.example"
    echo
    show_warning "IMPORTANTE: Edita el archivo .env antes de usar en producción"
    echo "   - Cambia SECRET_KEY"
    echo "   - Cambia las credenciales por defecto"
    echo "   - Configura ALLOWED_ORIGINS"
else
    show_message "Archivo .env ya existe"
fi

echo
echo -e "${BLUE}========================================"
echo -e "  🎉 ¡Instalación completada!"
echo -e "========================================${NC}"
echo
echo "Para usar el proyecto:"
echo
echo "1. Activar entorno (cada vez que trabajes):"
echo "   source yt-downloader-env/bin/activate"
echo
echo "2. Ejecutar servidor:"
echo "   python start.py"
echo
echo "3. Acceder a la documentación:"
echo "   http://localhost:8000/docs"
echo
echo "4. Desactivar entorno (al terminar):"
echo "   deactivate"
echo
echo -e "${BLUE}========================================${NC}"
echo

read -p "¿Quieres iniciar el servidor ahora? (y/N): " start_now
if [[ $start_now == "y" || $start_now == "Y" ]]; then
    echo
    echo "🚀 Iniciando servidor..."
    python start.py
else
    echo
    echo "Para iniciar más tarde, ejecuta:"
    echo "source yt-downloader-env/bin/activate"
    echo "python start.py"
    echo
    echo "¡Entorno virtual listo para usar!"
fi
