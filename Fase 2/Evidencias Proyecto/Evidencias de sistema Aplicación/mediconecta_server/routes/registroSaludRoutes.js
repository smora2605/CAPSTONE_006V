const express = require('express');
const router = express.Router();
const registroSaludController = require('../controllers/registroSaludController');
const { verifyToken, isAdmin } = require('../middleware/authMiddleware');

// router.get('/', verifyToken, isAdmin, usuariosController.getUsuarios);
router.get('/', registroSaludController.getAllRegistrosSalud);
router.get('/:pacienteId', registroSaludController.getRegistrosSaludPorPaciente);
router.post('/', registroSaludController.createRegistroSalud);

module.exports = router;