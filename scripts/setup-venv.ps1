# PowerShell Script para Entorno Virtual
# YouTube Downloader Backend

Write-Host "========================================" -ForegroundColor Blue
Write-Host "  🐍 Setup Entorno Virtual - PowerShell" -ForegroundColor Blue
Write-Host "  YouTube Downloader Backend" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

function Show-Success {
    param($Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Show-Warning {
    param($Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Show-Error {
    param($Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

# Verificar si Python está instalado
try {
    $pythonVersion = python --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Python no encontrado"
    }
    Show-Success "Python encontrado: $pythonVersion"
} catch {
    Show-Error "Python no está instalado o no está en el PATH"
    Write-Host ""
    Write-Host "Descarga Python desde: https://python.org" -ForegroundColor Cyan
    Write-Host "Asegúrate de marcar 'Add Python to PATH' durante la instalación" -ForegroundColor Cyan
    Read-Host "Presiona Enter para continuar"
    exit 1
}

# Verificar política de ejecución
$executionPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($executionPolicy -eq "Restricted") {
    Show-Warning "Configurando política de ejecución de scripts..."
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Show-Success "Política de ejecución configurada"
    } catch {
        Show-Error "No se pudo configurar la política de ejecución"
        Write-Host "Ejecuta manualmente: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Cyan
    }
}

# Verificar si ya existe un entorno virtual
if (Test-Path "yt-downloader-env") {
    Write-Host ""
    Show-Warning "Ya existe un entorno virtual"
    $recreate = Read-Host "¿Quieres recrearlo? (y/N)"
    if ($recreate -eq "y" -or $recreate -eq "Y") {
        Write-Host "Eliminando entorno existente..."
        Remove-Item -Recurse -Force yt-downloader-env
    } else {
        Write-Host "Usando entorno existente..."
        & .\yt-downloader-env\Scripts\Activate.ps1
        Show-Success "Entorno virtual activado"
        $skipCreation = $true
    }
}

if (-not $skipCreation) {
    Write-Host ""
    Write-Host "📦 Creando entorno virtual..." -ForegroundColor Cyan
    python -m venv yt-downloader-env
    if ($LASTEXITCODE -ne 0) {
        Show-Error "Error creando entorno virtual"
        Write-Host ""
        Write-Host "Posibles soluciones:" -ForegroundColor Cyan
        Write-Host "1. Instalar/actualizar Python" -ForegroundColor Cyan
        Write-Host "2. Ejecutar PowerShell como administrador" -ForegroundColor Cyan
        Write-Host "3. Verificar permisos de escritura en el directorio" -ForegroundColor Cyan
        Read-Host "Presiona Enter para continuar"
        exit 1
    }
    Show-Success "Entorno virtual creado"

    Write-Host ""
    Write-Host "🔌 Activando entorno virtual..." -ForegroundColor Cyan
    & .\yt-downloader-env\Scripts\Activate.ps1
    if ($LASTEXITCODE -ne 0) {
        Show-Error "Error activando entorno virtual"
        Read-Host "Presiona Enter para continuar"
        exit 1
    }
    Show-Success "Entorno virtual activado"
}

Write-Host ""
Write-Host "📈 Actualizando pip..." -ForegroundColor Cyan
python -m pip install --upgrade pip
if ($LASTEXITCODE -ne 0) {
    Show-Warning "Error actualizando pip, continuando..."
}

Write-Host ""
Write-Host "📦 Instalando dependencias..." -ForegroundColor Cyan
Write-Host "Esto puede tomar unos minutos..." -ForegroundColor Yellow
pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Show-Error "Error instalando dependencias"
    Write-Host ""
    Write-Host "Posibles soluciones:" -ForegroundColor Cyan
    Write-Host "1. Verificar conexión a internet" -ForegroundColor Cyan
    Write-Host "2. Usar trusted hosts:" -ForegroundColor Cyan
    Write-Host "   pip install --trusted-host pypi.org --trusted-host pypi.python.org -r requirements.txt" -ForegroundColor Gray
    Write-Host "3. Revisar el archivo requirements.txt" -ForegroundColor Cyan
    Read-Host "Presiona Enter para continuar"
    exit 1
}

Show-Success "Dependencias instaladas correctamente"

Write-Host ""
Write-Host "🧪 Verificando instalación..." -ForegroundColor Cyan

# Verificar FastAPI
try {
    $fastApiCheck = python -c "import fastapi; print('FastAPI:', fastapi.__version__)" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Show-Success $fastApiCheck
    } else {
        Show-Error "Error verificando FastAPI"
    }
} catch {
    Show-Error "Error verificando FastAPI"
}

# Verificar yt-dlp
try {
    python -c "import yt_dlp; print('yt-dlp verificado')" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Show-Success "yt-dlp verificado"
    } else {
        Show-Error "Error verificando yt-dlp"
    }
} catch {
    Show-Error "Error verificando yt-dlp"
}

# Verificar aplicación principal
try {
    python -c "from main import app; print('Aplicación principal verificada')" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Show-Success "Aplicación principal verificada"
    } else {
        Show-Error "Error verificando aplicación principal"
    }
} catch {
    Show-Error "Error verificando aplicación principal"
}

Write-Host ""
Write-Host "📁 Creando directorio de descargas..." -ForegroundColor Cyan
if (-not (Test-Path "downloads")) {
    New-Item -ItemType Directory -Name "downloads" | Out-Null
}
Show-Success "Directorio downloads creado"

Write-Host ""
Write-Host "📋 Configurando archivo .env..." -ForegroundColor Cyan
if (-not (Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Show-Success "Archivo .env creado desde .env.example"
    Write-Host ""
    Show-Warning "IMPORTANTE: Edita el archivo .env antes de usar en producción"
    Write-Host "   - Cambia SECRET_KEY" -ForegroundColor Yellow
    Write-Host "   - Cambia las credenciales por defecto" -ForegroundColor Yellow
    Write-Host "   - Configura ALLOWED_ORIGINS" -ForegroundColor Yellow
} else {
    Show-Success "Archivo .env ya existe"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "  🎉 ¡Instalación completada!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""
Write-Host "Para usar el proyecto:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Activar entorno (cada vez que trabajes):" -ForegroundColor White
Write-Host "   .\yt-downloader-env\Scripts\Activate.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Ejecutar servidor:" -ForegroundColor White
Write-Host "   python start.py" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Acceder a la documentación:" -ForegroundColor White
Write-Host "   http://localhost:8000/docs" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Desactivar entorno (al terminar):" -ForegroundColor White
Write-Host "   deactivate" -ForegroundColor Gray
Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

$startNow = Read-Host "¿Quieres iniciar el servidor ahora? (y/N)"
if ($startNow -eq "y" -or $startNow -eq "Y") {
    Write-Host ""
    Write-Host "🚀 Iniciando servidor..." -ForegroundColor Green
    python start.py
} else {
    Write-Host ""
    Write-Host "Para iniciar más tarde, ejecuta:" -ForegroundColor Cyan
    Write-Host ".\yt-downloader-env\Scripts\Activate.ps1" -ForegroundColor Gray
    Write-Host "python start.py" -ForegroundColor Gray
    Write-Host ""
    Write-Host "¡Entorno virtual listo para usar!" -ForegroundColor Green
}

Read-Host "Presiona Enter para continuar"
