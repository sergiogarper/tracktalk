require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

// Rutas
const authRoutes = require('./routes/auth');
const favoritosRoutes = require('./routes/favoritos');

const chatRoutes = require('./routes/chat');
const chatFullRoutes = require('./routes/chatFull');

const app = express();
const port = 3000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());

// Rutas
app.use('/auth', authRoutes);
app.use('/favoritos', favoritosRoutes);


app.use('/chat', chatRoutes);
app.use('/chat', chatFullRoutes);


// Arrancar servidor
app.listen(port, '0.0.0.0', () => {
  console.log(`Servidor backend escuchando en http://0.0.0.0:${port}`);
});
