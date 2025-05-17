require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

// Rutas
const authRoutes = require('./routes/auth');
const favoritosRoutes = require('./routes/favoritos');

const chatRoutes = require('./routes/chat');

const app = express();
const port = 3000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());

// Rutas
app.use('/auth', authRoutes);
app.use('/favoritos', favoritosRoutes);


app.use('/chat', chatRoutes);


// Arrancar servidor
app.listen(port, () => {
  console.log(`🚀 Servidor backend escuchando en http://localhost:${port}`);
});
