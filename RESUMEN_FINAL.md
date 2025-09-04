# 🎥 YouTube Downloader Backend

## 📁 Estructura Final del Proyecto
```
yt-downloader-backend/
├── 🚀 app/                          # Aplicación principal (modular)
│   ├── api/                         # Endpoints de la API
│   │   ├── auth.py                  # Autenticación JWT
│   │   ├── video.py                 # Descarga de videos
│   │   └── system.py                # Sistema y salud
│   ├── core/                        # Configuración y utilidades
│   │   ├── config.py                # Configuración centralizada
│   │   └── auth.py                  # Lógica de autenticación
│   ├── models/                      # Modelos de datos
│   │   └── schemas.py               # Esquemas Pydantic
│   ├── services/                    # Lógica de negocio
│   │   └── downloader.py            # Servicio de descarga
│   └── main.py                      # Aplicación FastAPI
├── 📦 scripts/                      # Scripts de configuración
│   ├── setup-venv.bat/sh/ps1        # Configuración entornos virtuales
│   ├── activate-env.bat/sh          # Activación rápida
│   └── install-menu.bat             # Menú interactivo
├── 🧪 tests/                        # Tests del proyecto
├── 📚 docs/                         # Documentación
├── 🐳 deployment/                   # Docker y despliegue
├── 💾 data/                         # Datos y archivos
│   └── downloads/                   # Videos descargados
├── 🔧 start.py                      # Iniciador inteligente
├── 📋 requirements.txt              # Dependencias
└── 📖 README.md                     # Documentación principal
```

## 🔥 Características Implementadas

### 🛡️ Seguridad Completa
- **JWT Authentication** con tokens seguros
- **Rate Limiting** (10 requests/minuto por IP)
- **Validación de URLs** de YouTube
- **CORS configurado** para desarrollo/producción
- **Variables de entorno** para configuración segura

### 🎥 Funcionalidad de Descarga
- **yt-dlp integrado** para descargas robustas
- **Múltiples calidades** disponibles (best, worst, specific)
- **Límites de tamaño** configurable (500MB por defecto)
- **Limpieza automática** de archivos temporales
- **Validación completa** de URLs y parámetros

### 🏗️ Arquitectura Profesional
- **Estructura modular** separando responsabilidades
- **Separación de capas**: API, Core, Models, Services
- **Configuración centralizada** con variables de entorno
- **Logging estructurado** para debugging
- **Documentación automática** con FastAPI/Swagger

### 🔧 Gestión de Entornos
- **Scripts automatizados** para venv, conda, virtualenv
- **Detección automática** del entorno disponible
- **Activación simplificada** con scripts dedicados
- **Compatibilidad multiplataforma** (Windows, Linux, macOS)

## 🚀 Comandos de Inicio Rápido

### 1. Configuración Inicial
```bash
# Opción A: Script automático (recomendado)
./scripts/setup-venv.bat    # Windows
./scripts/setup-venv.sh     # Linux/macOS

# Opción B: Manual
python -m venv yt-downloader-env
source yt-downloader-env/bin/activate  # Linux/macOS
yt-downloader-env\Scripts\activate     # Windows
pip install -r requirements.txt
```

### 2. Activar Entorno
```bash
./scripts/activate-env.bat    # Windows
./scripts/activate-env.sh     # Linux/macOS
```

### 3. Iniciar Servidor
```bash
python start.py
```

### 4. Acceder a la API
- **Documentación**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health
- **API Base**: http://localhost:8000/api/v1

## 🔐 Credenciales por Defecto
```
Usuario: admin
Contraseña: password123
```
**⚠️ IMPORTANTE: Cambiar en producción editando `.env`**

## 📡 Endpoints Principales

### Autenticación
- `POST /api/v1/auth/login` - Obtener token JWT
- `GET /api/v1/auth/me` - Información del usuario

### Descarga de Videos
- `POST /api/v1/video/download` - Descargar video
- `GET /api/v1/video/info` - Obtener información del video

### Sistema
- `GET /health` - Estado del servidor
- `GET /api/v1/system/info` - Información del sistema

## 🛠️ Configuración Avanzada

### Variables de Entorno (.env)
```env
# Seguridad
SECRET_KEY=tu-clave-secreta-aqui
ACCESS_TOKEN_EXPIRE_MINUTES=30

# API
API_V1_STR=/api/v1
PROJECT_NAME=YouTube Downloader Backend

# Descargas
DOWNLOAD_DIR=./data/downloads
MAX_FILE_SIZE_MB=500

# Rate Limiting
RATE_LIMIT_REQUESTS=10
RATE_LIMIT_WINDOW=60
```

## 🐳 Despliegue con Docker
```bash
# Desarrollo
docker-compose up -d

# Producción
docker build -t yt-downloader .
docker run -p 8000:8000 -v $(pwd)/data:/app/data yt-downloader
```

## 📊 Estado del Proyecto

### ✅ Completado
- [x] API REST completa con FastAPI
- [x] Autenticación JWT segura
- [x] Rate limiting por IP
- [x] Integración con yt-dlp
- [x] Estructura modular profesional
- [x] Scripts de gestión de entornos
- [x] Documentación completa
- [x] Docker y docker-compose
- [x] Tests básicos
- [x] Configuración por variables de entorno

### 🚀 Listo para Producción
- Servidor HTTP asíncrono con Uvicorn
- HTTPS ready (configurar reverse proxy)
- Logging estructurado
- Gestión de errores robusta
- Validación completa de datos

## 📞 Soporte y Mantenimiento

### 🔧 Troubleshooting Común
1. **Error de permisos**: Ejecutar como administrador
2. **Puerto ocupado**: Cambiar puerto en `.env`
3. **Dependencias faltantes**: Ejecutar `pip install -r requirements.txt`
4. **Error yt-dlp**: Actualizar con `pip install -U yt-dlp`

### 📈 Próximas Mejoras Sugeridas
- Sistema de colas para descargas masivas
- Base de datos para historial
- Sistema de usuarios múltiples
- Interfaz web frontend
- API de administración

---

