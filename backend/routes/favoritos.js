const express = require('express');
const router = express.Router();
const { addFavorito, getFavoritos } = require('../controllers/favoritosController');

//POST /favoritos
router.post('/', addFavorito);

//GET /favoritos/:usuarioId
router.get('/:usuarioId', getFavoritos);

module.exports = router;
