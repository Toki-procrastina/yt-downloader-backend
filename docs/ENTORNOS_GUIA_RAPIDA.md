# 🚀 GUÍA RÁPIDA: Entornos Virtuales

## ⚡ Instalación Automática (Recomendado)

### Windows
```bash
# Opción 1: Script automático completo
.\setup-venv.bat

# Opción 2: PowerShell (con colores)
.\setup-venv.ps1

# Opción 3: Menú de opciones
.\install-menu.bat
```

### Linux/Mac
```bash
# Dar permisos y ejecutar
chmod +x setup-venv.sh
./setup-venv.sh
```

## 🎯 Uso Diario

### Activar Entorno
```bash
# Windows
.\activate-env.bat
# o manualmente:
yt-downloader-env\Scripts\activate

# Linux/Mac
./activate-env.sh
# o manualmente:
source yt-downloader-env/bin/activate
```

### Trabajar con el Proyecto
```bash
# Con entorno activado:
python start.py              # Iniciar servidor
python test_api.py           # Probar API
python generate_secret.py    # Generar clave
deactivate                   # Desactivar al terminar
```

## 📋 Métodos Disponibles

1. **venv** (Recomendado) - Incluido en Python
2. **conda** - Si tienes Anaconda/Miniconda
3. **virtualenv** - Instalación separada
4. **Docker** - Sin Python local
5. **Global** - No recomendado

## ✅ Ventajas de los Entornos Virtuales

- ✅ **Aislamiento completo** de dependencias
- ✅ **Sin conflictos** con otras aplicaciones
- ✅ **Reproducibilidad** en diferentes sistemas
- ✅ **Fácil limpieza** (solo eliminar carpeta)
- ✅ **Múltiples versiones** de Python
- ✅ **Gestión profesional** de proyectos

## 🛠️ Archivos de Requisitos

- `requirements.txt` - Versiones específicas (principal)
- `requirements-min.txt` - Versiones mínimas compatibles
- `requirements-exact.txt` - Snapshot exacto (auto-generado)

## 🐳 Alternativa Docker

Si prefieres no gestionar Python localmente:

```bash
# Construcción
docker build -t yt-downloader .

# Ejecución
docker run -p 8000:8000 yt-downloader

# Con docker-compose
docker-compose up -d
```

## 🚨 Resolución de Problemas

### Error de Permisos (Windows)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Python no encontrado
```bash
# Verificar instalación
python --version
python3 --version

# Instalar Python desde python.org
```

### Recrear entorno corrupto
```bash
# Eliminar entorno
rm -rf yt-downloader-env  # Linux/Mac
rmdir /s yt-downloader-env  # Windows

# Ejecutar setup nuevamente
./setup-venv.sh  # Linux/Mac
.\setup-venv.bat  # Windows
```

---

**💡 Recomendación**: Usa `setup-venv.bat` (Windows) o `setup-venv.sh` (Linux/Mac) para configuración automática completa.
