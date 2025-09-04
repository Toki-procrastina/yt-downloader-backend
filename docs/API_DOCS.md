# API Documentation

## Descripción General
API REST segura para descargar videos de YouTube usando yt-dlp con autenticación JWT y rate limiting.

## Seguridad Implementada

### 1. Autenticación JWT
- Todos los endpoints (excepto `/`, `/health` y `/auth/login`) requieren token JWT
- Tokens expiran en 30 minutos por defecto
- Headers requeridos: `Authorization: Bearer <token>`

### 2. Rate Limiting
- 10 requests por minuto por IP por defecto
- Configurable via `RATE_LIMIT_REQUESTS` y `RATE_LIMIT_WINDOW`
- Aplicado a todos los endpoints

### 3. Validación de URLs
- Solo acepta URLs válidas de YouTube
- Expresión regular estricta para validación

### 4. Límites de Descarga
- Videos máximo 1 hora de duración
- Archivos máximo 500MB
- Solo videos individuales (no playlists)

### 5. CORS
- Configurado para dominios específicos
- No permite `*` en producción

### 6. Logging
- Todas las operaciones se registran
- Incluye IP, usuario, timestamps
- Intentos de login fallidos se registran

## Endpoints

### 1. Health Check
```http
GET /health
```
**Descripción:** Verificar estado del servidor  
**Autenticación:** No requerida  
**Rate Limit:** Sí  

**Respuesta:**
```json
{
  "status": "healthy",
  "timestamp": "2025-09-03T10:30:00",
  "download_dir_exists": true
}
```

### 2. Login
```http
POST /auth/login
```
**Descripción:** Autenticar usuario y obtener token JWT  
**Autenticación:** No requerida  
**Rate Limit:** Sí  

**Request Body:**
```json
{
  "username": "admin",
  "password": "password123"
}
```

**Respuesta:**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "token_type": "bearer"
}
```

### 3. Información del Video
```http
POST /video/info
```
**Descripción:** Obtener información del video sin descargarlo  
**Autenticación:** JWT requerido  
**Rate Limit:** Sí  

**Headers:**
```http
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
}
```

**Respuesta:**
```json
{
  "title": "Rick Astley - Never Gonna Give You Up",
  "duration": 213,
  "uploader": "RickAstleyVEVO",
  "view_count": 1234567890,
  "upload_date": "20091025",
  "description": "Rick Astley's official music video..."
}
```

### 4. Descargar Video
```http
POST /download
```
**Descripción:** Descargar video de YouTube  
**Autenticación:** JWT requerido  
**Rate Limit:** Sí  

**Headers:**
```http
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  "quality": "720p"
}
```

**Calidades disponibles:**
- `worst` - Calidad más baja
- `best` - Mejor calidad disponible
- `720p` - 720p o menor
- `480p` - 480p o menor
- `360p` - 360p o menor
- `audio` - Solo audio

**Respuesta:**
```json
{
  "success": true,
  "title": "Rick Astley - Never Gonna Give You Up",
  "duration": 213,
  "uploader": "RickAstleyVEVO",
  "filename": "Rick_Astley_Never_Gonna_Give_You_Up.mp4",
  "message": "Video descargado exitosamente"
}
```

### 5. Descargar Archivo
```http
GET /download/{filename}
```
**Descripción:** Descargar archivo ya procesado  
**Autenticación:** JWT requerido  
**Rate Limit:** Sí  

**Headers:**
```http
Authorization: Bearer <token>
```

**Respuesta:** Archivo binario

### 6. Limpiar Archivos
```http
DELETE /cleanup
```
**Descripción:** Eliminar archivos antiguos (>24h)  
**Autenticación:** JWT requerido  
**Rate Limit:** Sí  

**Headers:**
```http
Authorization: Bearer <token>
```

**Respuesta:**
```json
{
  "message": "Limpieza completada"
}
```

## Códigos de Error

- `400` - Bad Request (URL inválida, parámetros incorrectos)
- `401` - Unauthorized (token inválido/faltante)
- `404` - Not Found (archivo no encontrado)
- `429` - Too Many Requests (rate limit excedido)
- `500` - Internal Server Error (error interno)

## Configuración de Seguridad

### Variables de Entorno Críticas

```bash
# Cambiar en producción
SECRET_KEY=clave_super_segura_de_64_caracteres_minimo
API_USERNAME=admin_usuario
API_PASSWORD=contraseña_super_segura

# Rate limiting
RATE_LIMIT_REQUESTS=10
RATE_LIMIT_WINDOW=60

# CORS (solo dominios confiables)
ALLOWED_ORIGINS=https://tudominio.com,https://app.tudominio.com
```

### Recomendaciones de Deployment

1. **Usar HTTPS en producción**
2. **Cambiar credenciales por defecto**
3. **Configurar firewall**
4. **Monitorear logs**
5. **Configurar backup de configuración**
6. **Usar base de datos para usuarios en producción**
7. **Implementar rotación de tokens**
8. **Configurar alertas de seguridad**

## Ejemplo de Uso

### 1. Login
```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "password123"}'
```

### 2. Obtener info del video
```bash
curl -X POST "http://localhost:8000/video/info" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"}'
```

### 3. Descargar video
```bash
curl -X POST "http://localhost:8000/download" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ", "quality": "720p"}'
```
