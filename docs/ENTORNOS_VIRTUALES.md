# 🐍 Gestión de Entornos Virtuales - YouTube Downloader

## ¿Por qué usar entornos virtuales?

Los entornos virtuales (virtual environments) son esenciales para:
- **Aislamiento**: Evitar conflictos con otras aplicaciones Python
- **Reproducibilidad**: Garantizar las mismas versiones en todos los sistemas
- **Limpieza**: Mantener el sistema Python base limpio
- **Flexibilidad**: Poder usar diferentes versiones de librerías por proyecto

## 🚀 Métodos de Instalación

### Método 1: venv (Recomendado - Incluido en Python)

#### Windows (PowerShell)
```powershell
# 1. Crear entorno virtual
python -m venv yt-downloader-env

# 2. Activar entorno
.\yt-downloader-env\Scripts\Activate.ps1

# 3. Actualizar pip
python -m pip install --upgrade pip

# 4. Instalar dependencias
pip install -r requirements.txt

# 5. Verificar instalación
python -c "import fastapi; print('✅ FastAPI instalado correctamente')"

# Para desactivar el entorno
deactivate
```

#### Windows (CMD)
```cmd
# 1. Crear entorno virtual
python -m venv yt-downloader-env

# 2. Activar entorno
yt-downloader-env\Scripts\activate.bat

# 3. Actualizar pip
python -m pip install --upgrade pip

# 4. Instalar dependencias
pip install -r requirements.txt

# Para desactivar
deactivate
```

#### Linux/Mac
```bash
# 1. Crear entorno virtual
python3 -m venv yt-downloader-env

# 2. Activar entorno
source yt-downloader-env/bin/activate

# 3. Actualizar pip
pip install --upgrade pip

# 4. Instalar dependencias
pip install -r requirements.txt

# Para desactivar
deactivate
```

### Método 2: conda (Si tienes Anaconda/Miniconda)

```bash
# 1. Crear entorno con Python específico
conda create -n yt-downloader python=3.11

# 2. Activar entorno
conda activate yt-downloader

# 3. Instalar pip en el entorno
conda install pip

# 4. Instalar dependencias
pip install -r requirements.txt

# Para desactivar
conda deactivate
```

### Método 3: virtualenv (Instalación separada)

```bash
# 1. Instalar virtualenv (si no está instalado)
pip install virtualenv

# 2. Crear entorno
virtualenv yt-downloader-env

# 3. Activar (Windows)
yt-downloader-env\Scripts\activate

# 3. Activar (Linux/Mac)
source yt-downloader-env/bin/activate

# 4. Instalar dependencias
pip install -r requirements.txt
```

## 🔧 Scripts Automatizados

### Para Windows: `setup-venv.bat`
### Para Linux/Mac: `setup-venv.sh`

## ✅ Verificación del Entorno

Una vez instalado, verifica que todo funciona:

```bash
# Verificar Python
python --version

# Verificar pip
pip --version

# Verificar instalación
python -c "import fastapi, uvicorn, yt_dlp; print('✅ Todas las dependencias OK')"

# Listar paquetes instalados
pip list

# Verificar el servidor
python -c "from main import app; print('✅ Aplicación creada correctamente')"
```

## 🎯 Flujo de Trabajo Recomendado

1. **Crear entorno** (una sola vez)
2. **Activar entorno** (cada vez que trabajes)
3. **Instalar/actualizar dependencias** (cuando sea necesario)
4. **Desarrollar/ejecutar** (con entorno activado)
5. **Desactivar** (al terminar)

## 🚨 Problemas Comunes y Soluciones

### Error de permisos en Windows
```powershell
# Permitir ejecución de scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Python no encontrado
```bash
# Verificar instalación Python
python --version
# o
python3 --version

# Verificar PATH
echo $PATH  # Linux/Mac
echo $env:PATH  # PowerShell
```

### Conflictos de versiones
```bash
# Crear entorno limpio
rm -rf yt-downloader-env  # Linux/Mac
rmdir /s yt-downloader-env  # Windows

# Recrear entorno
python -m venv yt-downloader-env
```

### Error SSL/TLS
```bash
# Actualizar pip con certificados
python -m pip install --upgrade pip --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org
```

## 📦 Gestión de Dependencias

### Congelar dependencias actuales
```bash
pip freeze > requirements-exact.txt
```

### Actualizar dependencias
```bash
pip install --upgrade -r requirements.txt
```

### Instalar dependencias de desarrollo
```bash
pip install -r requirements-dev.txt  # Si existe
```

## 🐳 Alternativa: Docker (Sin Python local)

Si prefieres no instalar Python localmente:

```bash
# Construir imagen
docker build -t yt-downloader .

# Ejecutar contenedor
docker run -p 8000:8000 yt-downloader

# Con docker-compose
docker-compose up -d
```

## 📝 Notas Importantes

- **Siempre activa el entorno** antes de trabajar con el proyecto
- **No commitas** la carpeta del entorno virtual al git
- **Mantén actualizado** el requirements.txt
- **Usa la misma versión de Python** en todos los entornos
- **Documenta** la versión de Python requerida

## 🔄 Comandos de Uso Diario

```bash
# Iniciar trabajo
source yt-downloader-env/bin/activate  # Linux/Mac
.\yt-downloader-env\Scripts\Activate.ps1  # Windows

# Ejecutar servidor
python start.py

# Terminar trabajo
deactivate
```

---

**💡 Tip**: Usa el script automático correspondiente a tu sistema operativo para configurar todo de una vez.
