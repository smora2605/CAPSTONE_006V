const express = require('express');
const router = express.Router();
const disponibilidadesController = require('../controllers/disponibilidadesController');

// Rutas para citas
router.get('/', disponibilidadesController.getAllDisponibilidades);
router.get('/:doctor_id', disponibilidadesController.getDisponibilidadDoctor);

module.exports = router;