#!/bin/bash
echo "Descargando Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Compilando aplicación Web..."
flutter build web --release
