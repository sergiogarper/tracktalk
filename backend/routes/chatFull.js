// routes/chatFull.js
const express = require('express');
const router = express.Router();
const { procesarMensajeChat } = require('../controllers/chatFullController');

router.post('/mensaje', procesarMensajeChat);

module.exports = router;
