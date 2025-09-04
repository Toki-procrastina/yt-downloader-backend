import requests
import json
import time

# Configuración
BASE_URL = "http://localhost:8000"
USERNAME = "admin"
PASSWORD = "password123"

def test_health():
    """Probar endpoint de salud"""
    print("🔍 Probando health check...")
    response = requests.get(f"{BASE_URL}/health")
    print(f"Status: {response.status_code}")
    print(f"Response: {response.json()}")
    return response.status_code == 200

def test_login():
    """Probar login y obtener token"""
    print("\n🔐 Probando login...")
    data = {
        "username": USERNAME,
        "password": PASSWORD
    }
    response = requests.post(f"{BASE_URL}/auth/login", json=data)
    print(f"Status: {response.status_code}")
    
    if response.status_code == 200:
        token_data = response.json()
        print("✓ Login exitoso")
        return token_data["access_token"]
    else:
        print(f"✗ Error en login: {response.text}")
        return None

def test_video_info(token, url):
    """Probar obtener información del video"""
    print(f"\n📺 Probando obtener info de: {url}")
    headers = {"Authorization": f"Bearer {token}"}
    data = {"url": url}
    
    response = requests.post(f"{BASE_URL}/video/info", json=data, headers=headers)
    print(f"Status: {response.status_code}")
    
    if response.status_code == 200:
        info = response.json()
        print(f"✓ Título: {info['title']}")
        print(f"✓ Duración: {info['duration']} segundos")
        print(f"✓ Uploader: {info['uploader']}")
        return True
    else:
        print(f"✗ Error: {response.text}")
        return False

def test_download(token, url, quality="360p"):
    """Probar descarga de video"""
    print(f"\n⬇️ Probando descarga en calidad {quality}...")
    headers = {"Authorization": f"Bearer {token}"}
    data = {
        "url": url,
        "quality": quality
    }
    
    response = requests.post(f"{BASE_URL}/download", json=data, headers=headers)
    print(f"Status: {response.status_code}")
    
    if response.status_code == 200:
        result = response.json()
        print(f"✓ Descarga exitosa: {result['title']}")
        print(f"✓ Archivo: {result['filename']}")
        return result['filename']
    else:
        print(f"✗ Error en descarga: {response.text}")
        return None

def main():
    """Función principal de testing"""
    print("🧪 Iniciando tests de la API")
    print("=" * 50)
    
    # Test 1: Health check
    if not test_health():
        print("❌ Health check falló - ¿Está el servidor corriendo?")
        return
    
    # Test 2: Login
    token = test_login()
    if not token:
        print("❌ Login falló")
        return
    
    # Test 3: Video info (video corto de prueba)
    test_url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"  # Rick Roll (corto)
    if not test_video_info(token, test_url):
        print("❌ Info del video falló")
        return
    
    # Test 4: Download (opcional - descomenta para probar)
    # filename = test_download(token, test_url, "360p")
    # if filename:
    #     print(f"✓ Archivo descargado: {filename}")
    
    print("\n🎉 Todos los tests pasaron exitosamente!")
    print("=" * 50)

if __name__ == "__main__":
    main()
