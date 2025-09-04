# 🎥 YouTube Downloader Backend

Un servidor API REST en Python para descargar videos de YouTube.

<details>
  <summary> 📁 Estructura del Proyecto </summary>


```
yt-downloader-backend/
├── 📱 app/                          # Aplicación principal
│   ├── __init__.py
│   ├── main.py                      # Punto de entrada FastAPI
│   ├── 🔧 core/                     # Componentes centrales
│   │   ├── __init__.py
│   │   ├── config.py                # Configuración y settings
│   │   └── auth.py                  # Autenticación JWT
│   ├── 🌐 api/                      # Endpoints y rutas
│   │   ├── __init__.py
│   │   ├── auth.py                  # Rutas de autenticación
│   │   ├── video.py                 # Rutas de video
│   │   └── system.py                # Rutas del sistema
│   ├── 🏗️ models/                   # Modelos y schemas
│   │   ├── __init__.py
│   │   └── schemas.py               # Esquemas Pydantic
│   └── 🔨 services/                 # Lógica de negocio
│       ├── __init__.py
│       └── downloader.py            # Servicio de descarga
├── 🗂️ data/                         # Datos y archivos
│   └── downloads/                   # Videos descargados
├── 📋 scripts/                      # Scripts de utilidad
│   ├── setup-venv.bat              # Setup Windows
│   ├── setup-venv.ps1              # Setup PowerShell
│   ├── setup-venv.sh               # Setup Linux/Mac
│   ├── activate-env.bat            # Activar entorno Windows
│   ├── activate-env.sh             # Activar entorno Linux/Mac
│   ├── install-menu.bat            # Menú de instalación
│   └── generate_secret.py          # Generador de claves
├── 🧪 tests/                        # Tests y pruebas
│   └── test_api.py                 # Tests de la API
├── 🚀 deployment/                   # Archivos de deployment
│   ├── Dockerfile                  # Imagen Docker
│   └── docker-compose.yml          # Orquestación
├── 📚 docs/                         # Documentación
│   ├── README.md                   # Documentación principal
│   ├── API_DOCS.md                 # Documentación de la API
│   ├── INICIO_RAPIDO.md            # Guía de inicio rápido
│   ├── ENTORNOS_VIRTUALES.md       # Guía de entornos virtuales
│   └── ENTORNOS_GUIA_RAPIDA.md     # Referencia rápida de entornos
├── start.py                        # Script de inicio
├── requirements.txt                # Dependencias principales
├── requirements-min.txt            # Dependencias mínimas
├── requirements-exact.txt          # Dependencias exactas
├── .env                           # Variables de entorno (local)
├── .env.example                   # Ejemplo de configuración
└── .gitignore                     # Archivos ignorados por Git
```

  
</details>

## 🚀 Inicio Rápido

### 1. Configuración Automática (Recomendado)

```bash
# Windows
scripts\setup-venv.bat

# Linux/Mac
chmod +x scripts/setup-venv.sh
scripts/setup-venv.sh
```

### 2. Inicio Manual

```bash
# Crear entorno virtual
python -m venv yt-downloader-env

# Activar entorno
# Windows:
yt-downloader-env\Scripts\activate
# Linux/Mac:
source yt-downloader-env/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
cp .env.example .env

# Iniciar servidor
python start.py
```

## 🔥 Características

### 🛡️ Seguridad
- **Autenticación JWT** obligatoria
- **Rate limiting** configurable
- **Validación estricta** de URLs
- **CORS** configurado
- **Logging** completo de operaciones

### ⚡ Funcionalidades
- **Descarga de videos** en múltiples calidades
- **Información de videos** sin descarga
- **Limpieza automática** de archivos
- **API REST** completamente documentada
- **Documentación interactiva** con Swagger

### 🔧 Arquitectura
- **Estructura modular** y escalable
- **Separación de responsabilidades**
- **Código limpio** y mantenible
- **Tests** incluidos
- **Docker** ready

## 📡 API Endpoints

| Método | Endpoint | Descripción | Auth |
|--------|----------|-------------|------|
| `GET` | `/` | Información básica | ❌ |
| `GET` | `/health` | Estado del servidor | ❌ |
| `POST` | `/auth/login` | Autenticación | ❌ |
| `POST` | `/video/info` | Info del video | ✅ |
| `POST` | `/video/download` | Descargar video | ✅ |
| `GET` | `/video/download/{filename}` | Descargar archivo | ✅ |
| `DELETE` | `/cleanup` | Limpiar archivos | ✅ |

## 🎯 Uso

### 1. Autenticación
```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "password123"}'
```

### 2. Obtener información del video
```bash
curl -X POST "http://localhost:8000/video/info" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.youtube.com/watch?v=VIDEO_ID"}'
```

### 3. Descargar video
```bash
curl -X POST "http://localhost:8000/video/download" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.youtube.com/watch?v=VIDEO_ID", "quality": "720p"}'
```

## 🐳 Docker

```bash
# Desarrollo
cd deployment
docker-compose up -d

# Producción
docker build -t yt-downloader .
docker run -p 8000:8000 yt-downloader
```

## ⚙️ Configuración

### Variables de Entorno (.env)
```bash
# Seguridad
SECRET_KEY=tu_clave_secreta_muy_segura
API_USERNAME=admin
API_PASSWORD=password123

# Servidor
HOST=0.0.0.0
PORT=8000
DEBUG=False

# Rate Limiting
RATE_LIMIT_REQUESTS=10
RATE_LIMIT_WINDOW=60

# CORS
ALLOWED_ORIGINS=https://tudominio.com

# Directorio de datos
DOWNLOAD_DIR=./data/downloads
```

### Calidades Disponibles
- `worst` - Calidad más baja
- `best` - Mejor calidad disponible
- `720p` - HD 720p o menor
- `480p` - SD 480p o menor
- `360p` - 360p o menor
- `audio` - Solo audio

## 📚 Documentación

- **API Interactiva**: http://localhost:8000/docs
- **Documentación completa**: [docs/](docs/)
- **Guía de inicio**: [docs/INICIO_RAPIDO.md](docs/INICIO_RAPIDO.md)
- **Entornos virtuales**: [docs/ENTORNOS_VIRTUALES.md](docs/ENTORNOS_VIRTUALES.md)

## 🛠️ Desarrollo

### Estructura de Módulos

- **`app/core/`**: Configuración y autenticación
- **`app/api/`**: Definición de endpoints
- **`app/models/`**: Esquemas y validación de datos
- **`app/services/`**: Lógica de negocio
- **`scripts/`**: Herramientas de desarrollo
- **`tests/`**: Tests automatizados

### Agregar Nuevas Funcionalidades

1. **Modelo**: Crear schema en `app/models/schemas.py`
2. **Servicio**: Implementar lógica en `app/services/`
3. **API**: Crear endpoint en `app/api/`
4. **Test**: Agregar pruebas en `tests/`

## 🚨 Producción

### Checklist de Seguridad
- [ ] Cambiar `SECRET_KEY`
- [ ] Cambiar credenciales por defecto
- [ ] Configurar HTTPS
- [ ] Configurar firewall
- [ ] Configurar CORS específico
- [ ] Configurar rate limits apropiados
- [ ] Monitorear logs
- [ ] Backup de configuración

### Performance
- Usar proxy reverso (nginx)
- Configurar rate limiting apropiado
- Monitorear uso de disco
- Configurar limpieza automática

## 📄 Licencia

Proyecto desarrollado para uso educativo y personal.

---

Accede a http://localhost:8000/docs para la documentación interactiva.

