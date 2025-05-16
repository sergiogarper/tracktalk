# TrackTalk

TrackTalk es una aplicación de chat impulsada por inteligencia artificial para explorar y conocer nueva música. Este documento explica cómo ejecutar la aplicación en dos entornos: navegador (Chrome) y simulador de Android.

---

## Requisitos previos

Antes de comenzar, asegúrate de tener lo siguiente instalado en tu sistema:

1. **Flutter**:
   - Descarga e instala Flutter desde [flutter.dev](https://flutter.dev/docs/get-started/install).
   - Asegúrate de que Flutter esté agregado a tu `PATH`.

2. **Android Studio** (para simulador de Android):
   - Descarga e instala Android Studio desde [developer.android.com](https://developer.android.com/studio).
   - Configura un dispositivo virtual (AVD) en Android Studio.

3. **Dependencias del proyecto**:
   - Ejecuta el siguiente comando en el directorio raíz del proyecto para instalar las dependencias:
     ```bash
     flutter pub get
     ```

4. **Dispositivo conectado o emulador**:
   - Para Android, asegúrate de que un emulador esté corriendo.

---

## Ejecución en navegador (Chrome)

Sigue estos pasos para ejecutar la aplicación en el navegador:

1. **Verifica que Flutter detecte Chrome**:
   - Ejecuta el siguiente comando:
     ```bash
     flutter devices
     ```
   - Asegúrate de que `Chrome` aparezca en la lista de dispositivos disponibles.

2. **Ejecuta la aplicación en Chrome**:
   - Usa el siguiente comando:
     ```bash
     flutter run -d chrome
     ```

3. **Abre la aplicación**:
   - La aplicación se abrirá automáticamente en una nueva pestaña de Chrome.

---

## Ejecución en simulador de Android

Sigue estos pasos para ejecutar la aplicación en un simulador de Android:

1. **Inicia el emulador de Android**:
   - Abre Android Studio.
   - Ve a `Tools > Device Manager` y selecciona un dispositivo virtual para iniciarlo.

2. **Verifica que Flutter detecte el emulador**:
   - Ejecuta el siguiente comando:
     ```bash
     flutter devices
     ```
   - Asegúrate de que el emulador aparezca en la lista de dispositivos disponibles.

3. **Ejecuta la aplicación en el emulador**:
   - Usa el siguiente comando:
     ```bash
     flutter run
     ```

4. **Abre la aplicación**:
   - La aplicación se abrirá automáticamente en el emulador.
