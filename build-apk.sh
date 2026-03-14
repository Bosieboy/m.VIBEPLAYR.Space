#!/usr/bin/env bash
# ============================================================
# VIBEPLAYR APK Build Script
# Vereist: Android SDK + Java 17+
# ============================================================
set -e

echo ""
echo "  🎵 VIBEPLAYR APK Builder"
echo "  ========================"
echo ""

# Check Java
if ! command -v java &>/dev/null; then
  echo "❌ Java niet gevonden. Installeer JDK 17+"
  exit 1
fi

JAVA_VER=$(java -version 2>&1 | head -1 | grep -oP '(?<=version ")[\d.]+')
echo "✅ Java: $JAVA_VER"

# Check ANDROID_HOME
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
  echo ""
  echo "❌ ANDROID_HOME niet ingesteld."
  echo "   Stel in met: export ANDROID_HOME=/pad/naar/android/sdk"
  echo "   Of installeer Android Studio — die doet het automatisch."
  exit 1
fi

SDK="${ANDROID_HOME:-$ANDROID_SDK_ROOT}"
echo "✅ Android SDK: $SDK"

# Write local.properties
echo "sdk.dir=$SDK" > local.properties
echo "✅ local.properties aangemaakt"

# Download gradle wrapper jar als die er nog niet is
JAR="gradle/wrapper/gradle-wrapper.jar"
if [ ! -f "$JAR" ]; then
  echo "⬇️  Downloading gradle-wrapper.jar..."
  # Try via curl from gradle.org CDN
  GRADLE_VER="8.4"
  curl -sL \
    "https://services.gradle.org/distributions/gradle-${GRADLE_VER}-bin.zip" \
    -o /tmp/gradle-${GRADLE_VER}.zip
  unzip -p /tmp/gradle-${GRADLE_VER}.zip \
    "gradle-${GRADLE_VER}/lib/plugins/gradle-wrapper-*.jar" \
    > "$JAR" 2>/dev/null || true
  
  if [ ! -s "$JAR" ]; then
    echo "⚠️  Kon wrapper jar niet downloaden."
    echo "   Open dit project in Android Studio — dat regelt het automatisch."
    exit 1
  fi
  echo "✅ gradle-wrapper.jar klaar"
fi

echo ""
echo "🔨 Bouwen... (eerste keer kan 2-5 minuten duren)"
echo ""

./gradlew assembleDebug

APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK_PATH" ]; then
  echo ""
  echo "✅ APK gebouwd!"
  echo "📦 Pad: $(pwd)/$APK_PATH"
  echo ""
  echo "Installeren op verbonden telefoon:"
  echo "  adb install $APK_PATH"
else
  echo "❌ Build mislukt. Controleer de output hierboven."
  exit 1
fi
