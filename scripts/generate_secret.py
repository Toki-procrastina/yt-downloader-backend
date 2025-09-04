#!/usr/bin/env python3
"""
Script para generar una clave secreta segura
"""
import secrets
import string

def generate_secret_key(length=64):
    """Generar clave secreta segura"""
    alphabet = string.ascii_letters + string.digits + "!@#$%^&*"
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def main():
    """Función principal"""
    print("🔐 Generador de Clave Secreta")
    print("=" * 40)
    
    key = generate_secret_key()
    print(f"Clave generada: {key}")
    print("\n📝 Copia esta clave a tu archivo .env:")
    print(f"SECRET_KEY={key}")
    print("\n⚠️  IMPORTANTE: Guarda esta clave de forma segura!")

if __name__ == "__main__":
    main()
