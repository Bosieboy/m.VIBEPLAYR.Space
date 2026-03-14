# 🎵 VIBEPLAYR Space — Android APK Project

Een native Android-app wrapper voor [vibeplayr.space/indexmobile](https://vibeplayr.space/indexmobile).

## Hoe het werkt

1. **Eerste start (online):** De app downloadt de volledige HTML van `vibeplayr.space/indexmobile` + favicon en slaat die op in `localStorage`.
2. **Daarna (offline):** De app laadt direct uit de cache. Geen internet nodig.
3. **Cache vernieuwen:** Zodra je weer online bent, herstart de app — hij update automatisch.

---

## Bouwen (optie A — Android Studio, aanbevolen)

1. Installeer [Android Studio](https://developer.android.com/studio)
2. Open dit project: **File → Open → map selecteren**
3. Wacht tot Gradle sync klaar is
4. Klik **▶ Run** of ga naar **Build → Build APK(s)**
5. APK staat in: `app/build/outputs/apk/debug/app-debug.apk`

---

## Bouwen (optie B — command line)

```bash
# Vereisten: Java 17+, Android SDK, ANDROID_HOME ingesteld
export ANDROID_HOME=~/Android/Sdk   # pas aan naar jouw pad

./build-apk.sh
```

---

## Installeren op je telefoon

**Via Android Studio:** klik gewoon ▶ Run terwijl je telefoon verbonden is.

**Via adb:**
```bash
adb install app/build/outputs/apk/debug/app-debug.apk
```

**Handmatig:**
1. Kopieer de `.apk` naar je telefoon
2. Zet "Onbekende bronnen" aan in Instellingen → Beveiliging
3. Open de APK en installeer

---

## Release APK (gesigneerd, voor distributie)

```bash
./gradlew assembleRelease
# Dan signeren met jarsigner of apksigner
```

---

## Structuur

```
vibeplayr-apk/
├── app/src/main/
│   ├── AndroidManifest.xml      # App config, permissions
│   ├── assets/www/loader.html   # De offline loader pagina
│   ├── java/.../MainActivity.java  # WebView host
│   └── res/                     # Icons, styles
├── build.gradle
├── settings.gradle
└── build-apk.sh                 # Handige build helper
```

## Permissions

- `INTERNET` — voor het downloaden van de VIBEPLAYR pagina
- `ACCESS_NETWORK_STATE` — om online/offline te detecteren
- `READ_MEDIA_AUDIO` — muziekbestanden afspelen (Android 13+)

