const express = require('express');
const router = express.Router();
const citasController = require('../controllers/citasController');

// Rutas para citas
router.get('/', citasController.getAllCitas);
router.get('/doctor/:doctorId', citasController.getCitasPendientesPorDoctor);
router.get('/pending/:pacienteId', citasController.getCitasPendientesPorPaciente);
router.get('/doctorAll/:doctorId', citasController.getCitasPorDoctor);
router.post('/', citasController.createCita);
router.put('/:id', citasController.updateCitaEstado);
router.delete('/:id', citasController.deleteCita);

module.exports = router;