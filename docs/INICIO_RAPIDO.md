# 🚀 YouTube Downloader Backend - Inicio Rápido

## ✅ Instalación Completada

Tu servidor YouTube Downloader está listo para usar. Aquí tienes todo lo que necesitas:

## 🎯 Inicio Rápido

### 1. Instalar Dependencias (si no se hizo)
```bash
pip install -r requirements.txt
```

### 2. Configurar Variables de Entorno
```bash
# Editar .env con tus configuraciones
SECRET_KEY=tu_clave_super_secreta_aqui
API_USERNAME=tu_usuario
API_PASSWORD=tu_contraseña_segura
ALLOWED_ORIGINS=https://tudominio.com
```

### 3. Iniciar Servidor
```bash
# Opción 1: Script automático
python start.py

# Opción 2: Directamente con uvicorn
uvicorn main:app --host 0.0.0.0 --port 8000

# Opción 3: Con Docker
docker-compose up -d
```

### 4. Acceder a la API
- **Documentación**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health
- **API Base**: http://localhost:8000

## 🔐 Credenciales por Defecto
⚠️ **CAMBIAR EN PRODUCCIÓN**
- Usuario: `admin`
- Contraseña: `password123`

## 📡 Endpoints Principales

### Login
```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "password123"}'
```

### Obtener Info del Video
```bash
curl -X POST "http://localhost:8000/video/info" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"}'
```

### Descargar Video
```bash
curl -X POST "http://localhost:8000/download" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ", "quality": "720p"}'
```

## 🛡️ Características de Seguridad

✅ **Autenticación JWT obligatoria**  
✅ **Rate limiting (10 req/min por IP)**  
✅ **Validación estricta de URLs de YouTube**  
✅ **Límites de tamaño y duración**  
✅ **CORS configurado**  
✅ **Logging completo**  
✅ **Limpieza automática de archivos**  

## 🔧 Calidades de Video Disponibles
- `worst` - Calidad más baja
- `best` - Mejor calidad disponible  
- `720p` - HD 720p o menor
- `480p` - SD 480p o menor
- `360p` - 360p o menor
- `audio` - Solo audio

## ⚡ Scripts Útiles

```bash
# Generar clave secreta segura
python generate_secret.py

# Probar la API
python test_api.py

# Configuración automática (Windows)
setup.bat
```

## 🐳 Deploy con Docker

```bash
# Construir imagen
docker build -t youtube-downloader .

# Ejecutar con docker-compose
docker-compose up -d

# Ver logs
docker-compose logs -f
```

## 📁 Estructura del Proyecto

```
yt-downloader-backend/
├── main.py              # Aplicación principal FastAPI
├── auth.py              # Sistema de autenticación JWT
├── config.py            # Configuración y variables de entorno
├── downloader.py        # Lógica de descarga con yt-dlp
├── requirements.txt     # Dependencias Python
├── .env                 # Variables de entorno (configurar)
├── .env.example         # Ejemplo de configuración
├── start.py             # Script de inicio automático
├── test_api.py          # Tests de la API
├── generate_secret.py   # Generador de claves secretas
├── setup.bat            # Instalador automático (Windows)
├── Dockerfile           # Configuración Docker
├── docker-compose.yml   # Orquestación Docker
├── downloads/           # Directorio de archivos descargados
├── README.md            # Documentación principal
└── API_DOCS.md          # Documentación completa de la API
```

## 🚨 Importante para Producción

1. **Cambiar SECRET_KEY** - Usar `python generate_secret.py`
2. **Cambiar credenciales por defecto**
3. **Configurar HTTPS**
4. **Configurar firewall**
5. **Monitorear logs**
6. **Configurar backup**
7. **Actualizar ALLOWED_ORIGINS**

## 🆘 Solución de Problemas

### Error de dependencias
```bash
pip install --upgrade --force-reinstall -r requirements.txt
```

### Puerto ocupado
```bash
# Cambiar puerto en .env
PORT=8001
```

### Error de permisos (Linux/Mac)
```bash
chmod +x start.py
sudo chmod 755 downloads/
```

## 📞 Soporte

Si encuentras problemas:
1. Revisa los logs del servidor
2. Verifica la configuración en `.env`
3. Consulta `API_DOCS.md` para documentación completa
4. Ejecuta `python test_api.py` para diagnosticar

---

**¡Tu servidor YouTube Downloader está listo! 🎉**

Accede a http://localhost:8000/docs para la documentación interactiva.
