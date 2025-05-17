# TrackTalk Backend

Este es el backend de la aplicación TrackTalk, creado con Node.js, SQLite y Express. Aquí se gestionan la base de datos, los usuarios, canciones favoritas, y la integración con OpenAI y Spotify.

---

## 🧰 Tecnologías utilizadas

- Node.js
- Express
- SQLite (a través de `sqlite3`)
- Axios (para llamadas HTTP a APIs externas)
- dotenv (para claves privadas)
- OpenAI (asistente de chat)
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

