#!/bin/bash
echo "Descargando Flutter 3.35.4..."
git clone https://github.com/flutter/flutter.git -b 3.35.4
export PATH="$PATH:`pwd`/flutter/bin"

echo "Compilando aplicación Web..."
flutter build web --release
