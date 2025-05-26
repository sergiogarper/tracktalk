// routes/chatFull.js
const express = require('express');
const router = express.Router();
const {
  procesarMensajeChat,
  obtenerHistorialChats,
  obtenerChatCompleto
} = require('../controllers/chatFullController');

router.post('/mensaje', procesarMensajeChat);
router.get('/historial/:usuario_id', obtenerHistorialChats);
router.get('/completo/:usuario_id/:chat_id', obtenerChatCompleto);

module.exports = router;
