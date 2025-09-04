# YouTube Downloader Backend

Un servidor API REST en Python para descargar videos de YouTube de forma segura.

## Características

- API REST con FastAPI
- Autenticación con JWT
- Rate limiting para prevenir abuso
- Descarga de videos con yt-dlp
- Validación de URLs
- Logs de seguridad
- Configuración con variables de entorno

## Instalación

1. Instalar dependencias:
```bash
pip install -r requirements.txt
```

2. Crear archivo `.env`:
```bash
cp .env.example .env
```

3. Configurar variables de entorno en `.env`

4. Ejecutar el servidor:
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

## Endpoints

- `POST /auth/login` - Autenticación
- `POST /download` - Descargar video (requiere autenticación)
- `GET /health` - Estado del servidor

## Seguridad

- Autenticación JWT obligatoria
- Rate limiting por IP
- Validación estricta de URLs
- Logs de todas las operaciones
- CORS configurado para dominios específicos
