const express = require('express');
const router = express.Router();
const citasController = require('../controllers/citasController');

// Rutas para citas
router.get('/', citasController.getAllCitas);
router.get('/pending', citasController.getCitasPendientes);
router.post('/', citasController.createCita);
router.put('/:id', citasController.updateCita);
router.delete('/:id', citasController.deleteCita);

module.exports = router;