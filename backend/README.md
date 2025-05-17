# TrackTalk Backend

Este es el backend de la aplicación **TrackTalk**, creado con **Node.js**, **SQLite** y **Express**. Aquí se gestionan la base de datos local, la autenticación de usuarios, canciones favoritas, y un asistente conversacional musical con integración a **OpenAI** y **Spotify** (para obtener previews de canciones).

---

## 🧰 Tecnologías utilizadas

- Node.js
- Express
- SQLite (a través de `sqlite3`)
- Axios (para llamadas HTTP a APIs externas)
- dotenv (para claves privadas)
- OpenAI (asistente de chat)
- spotify-preview-finder (para previews de canciones)
- CORS y Body Parser

---

## ⚙️ Pasos de configuración

### 1. Inicializar proyecto

```bash
npm init -y
```

### 2. Instalar dependencias necesarias

```bash
npm install express cors body-parser sqlite3 dotenv axios openai spotify-preview-finder
```

---

## 🛠️ Iniciar base de datos

Esto crea el archivo local `tracktalk.db` con todas las tablas necesarias si no está creado ya:

```bash
node db/init.js
```

---

## 🚀 Ejecutar servidor

Cada vez que quieras lanzar el backend:

```bash
node server.js
```

El backend quedará disponible en:

```
http://localhost:3000
```

---

## 🧪 Endpoints disponibles hasta ahora

### 🔐 Autenticación

- `POST /auth/register` → Registra un nuevo usuario.
- `POST /auth/login` → Valida usuario y contraseña.

### ⭐ Favoritos

- `POST /favoritos` → Añadir canción a favoritos.
- `GET /favoritos/:usuarioId` → Obtener canciones favoritas de un usuario.

### 💬 Chat y Recomendaciones

- `POST /chat/recomendar` → Envía un mensaje al asistente y recibe un mensaje personalizado + una lista de canciones recomendadas con previews si están disponibles.

**Body esperado:**

```json
{
  "mensaje": "Recomiéndame canciones tristes en inglés"
}
```

**Respuesta:**

```json
{
  "mensaje_bonito": "Claro, aquí tienes algunas canciones melancólicas en inglés:",
  "canciones": [
    {
      "nombre": "Someone Like You",
      "artista": "Adele",
      "url": "https://open.spotify.com/track/...",
      "preview": "https://p.scdn.co/mp3-preview/..."
    }
  ]
}
```

---

## 📁 Estructura del backend (simplificada)

```
backend/
├── controllers/        # Controladores de rutas (auth, favoritos, chat...)
├── db/                 # Scripts de inicialización de base de datos
├── routes/             # Rutas Express para cada recurso
├── services/           # Lógica externa (ej. Spotify API)
├── utils/              # Funciones auxiliares (ej. extracción de canciones)
├── systemPrompt.js     # Prompt personalizado para OpenAI
├── server.js           # Punto de entrada principal
├── .env                # Variables de entorno
```
