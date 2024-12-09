const express = require('express');
const router = express.Router();
const disponibilidadesController = require('../controllers/disponibilidadesController');

// Rutas para citas
router.get('/', disponibilidadesController.getAllDisponibilidades);
router.get('/:doctor_id', disponibilidadesController.getDisponibilidadDoctor);
router.get('/date/:fecha', disponibilidadesController.getDisponibilidadesPorFecha);
router.post('/', disponibilidadesController.createAvailability);

module.exports = router;