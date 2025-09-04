#!/bin/bash

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================"
echo -e "  🔌 Activando Entorno Virtual"
echo -e "========================================${NC}"

if [ ! -d "yt-downloader-env" ]; then
    echo -e "${RED}❌ Entorno virtual no encontrado${NC}"
    echo
    echo "Ejecuta primero: ./setup-venv.sh"
    exit 1
fi

echo -e "${GREEN}✅ Activando entorno virtual...${NC}"
source yt-downloader-env/bin/activate

echo
echo -e "${GREEN}🎯 Entorno virtual activado${NC}"
echo
echo "Comandos disponibles:"
echo "  python start.py           - Iniciar servidor"
echo "  python test_api.py        - Probar API"
echo "  python generate_secret.py - Generar clave secreta"
echo "  deactivate                - Desactivar entorno"
echo
echo "Documentación: http://localhost:8000/docs"
echo

# Mantener el shell activo con el entorno activado
exec "$SHELL"
