#!/bin/bash

echo "🚀 Iniciando despliegue en Vercel para Flutter Web..."

# 1. Crear el archivo .env a partir de las variables de entorno de Vercel
echo "📝 Generando archivo .env..."
echo "SUPABASE_URL=$SUPABASE_URL" > .env
echo "SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY" >> .env
echo "API_BASE_URL=$API_BASE_URL" >> .env
echo "API_ADMIN_USER=$API_ADMIN_USER" >> .env
echo "API_ADMIN_PASS=$API_ADMIN_PASS" >> .env

# 2. Descargar Flutter SDK si no está en caché
if [ ! -d "flutter" ]; then
  echo "⬇️ Descargando Flutter SDK (canal stable)..."
  git clone https://github.com/flutter/flutter.git -b stable
else
  echo "✅ Flutter SDK ya existe en caché."
fi

# Añadir Flutter al PATH temporalmente
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Descargar dependencias
echo "📦 Instalando dependencias de Flutter..."
flutter pub get

# 4. Compilar la aplicación web
echo "🔨 Compilando la aplicación para Web..."
flutter build web --release

echo "✅ Compilación terminada con éxito. Vercel servirá la carpeta build/web."
