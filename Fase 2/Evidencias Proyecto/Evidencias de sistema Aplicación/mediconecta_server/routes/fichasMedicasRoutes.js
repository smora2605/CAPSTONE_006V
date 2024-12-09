const express = require('express');
const router = express.Router();
const fichasMedicasController = require('../controllers/fichaMedicaController');

router.get('/', fichasMedicasController.getAllFichasMedicas);
// router.get('/doctoresName', doctoresController.getDoctoresNames);
// router.get('/doctoresMedicinaGeneral', doctoresController.getDoctoresConEspecialidadMedicinaGeneral);
// router.get('/doctoresCardiologia', doctoresController.getDoctoresConEspecialidadCardiologia);
// router.get('/usuario/:userId', doctoresController.getDoctorByUserId);
router.post('/', fichasMedicasController.createFichaMedica);

module.exports = router;