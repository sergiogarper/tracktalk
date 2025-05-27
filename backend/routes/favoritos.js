const express = require('express');
const router = express.Router();
const { addFavorito, getFavoritos, removeFavorito } = require('../controllers/favoritosController');


//POST /favoritos
router.post('/', addFavorito);

//GET /favoritos/:usuarioId
router.get('/:usuarioId', getFavoritos);

// POST /favoritos/delete
router.post('/delete', removeFavorito);


module.exports = router;
