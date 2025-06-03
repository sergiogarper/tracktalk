# 🎵 TrackTalk

TrackTalk es una app móvil que te recomienda música a través de un chat con IA. Usa la API de OpenAI para entender lo que quieres y Spotify para traerte canciones mostrando una preview.

Funciona tanto en navegador (Chrome) como en un emulador Android. Este README te explica cómo ponerlo todo en marcha desde cero.

---

## ✅ Requisitos previos

- Flutter instalado (https://docs.flutter.dev)
- Node.js y npm instalados (https://nodejs.org)
- Emulador de Android configurado (en mi caso utilizo el Pixel 8 Pro)
- Archivo `.env` dentro de backend/

---

## 1. Clonar el repositorio

```bash
git clone https://github.com/sergiogarper/tracktalk.git
cd tracktalk
```

---

## 2. Configura el backend (Node.js)

```bash
cd backend
npm install
```

> ⚠️ **IMPORTANTE:**  
> El archivo `.env` debe estar dentro de la carpeta `backend/` para que la app funcione correctamente.

Luego ejecuta el servidor:

```bash
node server.js
```

---

## 3. Ejecuta el frontend en Flutter

### Opción A – Usar en navegador (Chrome)

```bash
cd frontend
flutter pub get
flutter run -d chrome
```


### Opción B – Usar en emulador Android (ej: Pixel 8 Pro)

Primero arranca el backend (si no lo has hecho ya):

```bash
cd backend
node server.js
```

Luego, en otra terminal:

```bash
cd frontend
flutter pub get
flutter run
```
---

## 🚀 Ejecución rápida con `runAll_chrome.bat`

El proyecto incluye un archivo llamado `runAll_Chrome.bat` que permite iniciar tanto el servidor backend como la aplicación Flutter en Chrome de forma automática.

### Pasos:
1. Haz doble clic en el archivo `runAll_Chrome.bat` ubicado en la raíz del proyecto.
2. Esto abrirá dos ventanas de consola:
   - Una para el servidor backend (Node.js).
   - Otra para la aplicación Flutter ejecutándose en Chrome.

> ⚠️ **Nota:** Asegúrate de tener configurado el archivo `.env` en la carpeta `backend/` y de haber instalado las dependencias necesarias antes de usar este archivo.

---

## ✅   PRUEBAS

1. Una vez la app se esté ejecutando, registrar un nuevo usuario o utilizar el usuario de prueba:
```bash
example@example.com
1234
```
2. Si funciona todo correctamente, probar a chatear con la IA.
3. Reproducir las previews de las recomendaciones, probar a crear un nuevo chat, cerrar sesión, etc.

