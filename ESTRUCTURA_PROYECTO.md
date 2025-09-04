# 📁 Estructura del Proyecto YouTube Downloader

## 🎯 Arquitectura Modular

El proyecto sigue una arquitectura hexagonal/clean architecture adaptada para FastAPI:

```
yt-downloader-backend/
├── 🎯 start.py                     # Punto de entrada principal
├── 📋 requirements*.txt            # Gestión de dependencias
├── 🔧 .env / .env.example         # Configuración de entorno
├── 📝 README.md                   # Documentación principal
│
├── 📱 app/                         # 🏗️ APLICACIÓN PRINCIPAL
│   ├── 🚀 main.py                 # FastAPI app y configuración
│   │
│   ├── 🔧 core/                   # 🎛️ COMPONENTES CENTRALES
│   │   ├── config.py              # ⚙️ Configuración global
│   │   └── auth.py                # 🔐 Autenticación JWT
│   │
│   ├── 🌐 api/                    # 🛣️ ENDPOINTS Y RUTAS
│   │   ├── auth.py                # 🔑 Rutas de autenticación
│   │   ├── video.py               # 🎥 Rutas de video
│   │   └── system.py              # 🖥️ Rutas del sistema
│   │
│   ├── 🏗️ models/                 # 📊 MODELOS Y ESQUEMAS
│   │   └── schemas.py             # 📝 Esquemas Pydantic
│   │
│   └── 🔨 services/               # 💼 LÓGICA DE NEGOCIO
│       └── downloader.py          # ⬇️ Servicio de descarga
│
├── 🗂️ data/                       # 💾 DATOS Y ARCHIVOS
│   └── downloads/                 # 📁 Videos descargados
│
├── 📋 scripts/                    # 🛠️ HERRAMIENTAS Y UTILIDADES
│   ├── setup-venv.*              # 🐍 Configuración de entornos
│   ├── activate-env.*             # ▶️ Activación de entornos
│   ├── install-menu.bat           # 📋 Menú de instalación
│   └── generate_secret.py         # 🔑 Generador de claves
│
├── 🧪 tests/                      # ✅ PRUEBAS Y TESTING
│   └── test_api.py                # 🔬 Tests de la API
│
├── 🚀 deployment/                 # 🌐 DEPLOYMENT Y DOCKER
│   ├── Dockerfile                 # 🐳 Imagen Docker
│   └── docker-compose.yml         # 🎼 Orquestación
│
└── 📚 docs/                       # 📖 DOCUMENTACIÓN
    ├── README.md                  # 📋 Documentación principal
    ├── API_DOCS.md                # 🌐 Documentación de API
    ├── INICIO_RAPIDO.md            # ⚡ Guía de inicio rápido
    ├── ENTORNOS_VIRTUALES.md      # 🐍 Guía de entornos virtuales
    └── ENTORNOS_GUIA_RAPIDA.md    # 📌 Referencia rápida
```

## 🎨 Principios de Diseño

### 🏗️ Separación de Responsabilidades

#### 📱 **app/core/** - Núcleo de la Aplicación
- **`config.py`**: Configuración centralizada, variables de entorno
- **`auth.py`**: Autenticación, autorización, JWT

#### 🌐 **app/api/** - Capa de Presentación  
- **`auth.py`**: Endpoints de autenticación (`/auth/*`)
- **`video.py`**: Endpoints de video (`/video/*`)
- **`system.py`**: Endpoints del sistema (`/health`, `/cleanup`)

#### 🏗️ **app/models/** - Capa de Datos
- **`schemas.py`**: Modelos Pydantic para validación y serialización

#### 🔨 **app/services/** - Capa de Negocio
- **`downloader.py`**: Lógica de descarga, validación de URLs, yt-dlp

### 🔄 Flujo de Datos

```
📱 Client Request 
    ↓
🌐 API Layer (app/api/)
    ↓
🏗️ Models (app/models/) ← Validación
    ↓
🔨 Services (app/services/) ← Lógica de negocio
    ↓
🔧 Core (app/core/) ← Configuración/Auth
    ↓
📁 Data Layer (data/)
    ↓
📱 Response
```

## 🎯 Ventajas de esta Estructura

### ✅ **Mantenibilidad**
- Código organizado por responsabilidades
- Fácil localizar y modificar funcionalidades
- Cambios aislados no afectan otros módulos

### ✅ **Escalabilidad**
- Fácil agregar nuevos endpoints
- Servicios independientes
- Estructura preparada para crecimiento

### ✅ **Testabilidad**
- Cada módulo se puede testear independientemente
- Mocking sencillo de dependencias
- Tests organizados por funcionalidad

### ✅ **Reutilización**
- Servicios reutilizables entre endpoints
- Modelos compartidos
- Configuración centralizada

### ✅ **Desarrollo en Equipo**
- Diferentes desarrolladores pueden trabajar en paralelo
- Responsabilidades claras
- Merge conflicts minimizados

## 🚀 Cómo Agregar Nuevas Funcionalidades

### 1. 📝 **Nuevo Endpoint**
```python
# 1. Crear modelo en app/models/schemas.py
class NewFeatureRequest(BaseModel):
    param1: str
    param2: int

# 2. Agregar lógica en app/services/ (si es necesario)
class NewFeatureService:
    def process(self, data):
        # Lógica de negocio
        pass

# 3. Crear endpoint en app/api/
@router.post("/new-feature")
async def new_feature(request: NewFeatureRequest):
    # Usar servicio
    return result
```

### 2. 🔧 **Nueva Configuración**
```python
# Agregar en app/core/config.py
class Settings(BaseSettings):
    new_setting: str = "default_value"
```

### 3. 🧪 **Nuevo Test**
```python
# Crear en tests/test_new_feature.py
def test_new_feature():
    # Test de la nueva funcionalidad
    pass
```

## 📋 Patrones Utilizados

### 🏗️ **Repository Pattern**
- Servicios manejan acceso a datos
- Abstracción de la lógica de persistencia

### 🎯 **Dependency Injection**
- FastAPI Depends() para inyección
- Configuración centralizada

### 📊 **Data Transfer Objects (DTO)**
- Modelos Pydantic como DTOs
- Validación automática

### 🔐 **Middleware Pattern**
- Rate limiting
- Logging
- CORS

## 🎨 Convenciones de Código

### 📁 **Nombres de Archivos**
- `snake_case` para archivos Python
- Nombres descriptivos y concisos

### 🏷️ **Nombres de Clases**
- `PascalCase` para clases
- Sufijos descriptivos (`Service`, `Request`, `Response`)

### 🔧 **Nombres de Funciones**
- `snake_case` para funciones
- Verbos descriptivos (`get_`, `create_`, `update_`)

### 📝 **Documentación**
- Docstrings en todas las funciones públicas
- Comentarios para lógica compleja
- README en cada directorio importante

---

**Esta estructura está diseñada para ser profesional, mantenible y escalable! 🚀**
