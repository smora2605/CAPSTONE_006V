const express = require('express');
const router = express.Router();
const especialidadesController = require('../controllers/especialidadesController');

// Rutas para especialidades
router.get('/', especialidadesController.getAllEspecialidades);
router.post('/', especialidadesController.createEspecialidad);
router.put('/:id', especialidadesController.updateEspecialidad);
router.delete('/:id', especialidadesController.deleteEspecialidad);

module.exports = router;