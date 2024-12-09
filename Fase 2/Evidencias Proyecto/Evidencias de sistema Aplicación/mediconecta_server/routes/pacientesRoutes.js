// /routes/usuariosRoutes.js
const express = require('express');
const router = express.Router();
const pacientesController = require('../controllers/pacientesController');

router.get('/', pacientesController.getPacientes);
router.get('/usuario/:userId', pacientesController.getPatientByUserId);
// router.get('/:id', usuariosController.getUsuarioById);
router.post('/', pacientesController.createPatient);
// router.put('/:id', usuariosController.updateUsuario);
// router.delete('/:id', usuariosController.deleteUsuario);

module.exports = router;