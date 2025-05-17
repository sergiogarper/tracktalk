const express = require('express');
const router = express.Router();
const { recomendarCanciones } = require('../controllers/chatController');

router.post('/recomendar', recomendarCanciones);

module.exports = router;
