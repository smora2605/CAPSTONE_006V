const express = require('express');
const router = express.Router();
const recordatorioController = require('../controllers/recordatorioController');

router.get('/', recordatorioController.getAllRecordatorios);
// router.get('/doctoresName', doctoresController.getDoctoresNames);
// router.get('/doctoresMedicinaGeneral', doctoresController.getDoctoresConEspecialidadMedicinaGeneral);
// router.get('/doctoresCardiologia', doctoresController.getDoctoresConEspecialidadCardiologia);
// router.get('/usuario/:userId', doctoresController.getDoctorByUserId);
router.post('/', recordatorioController.createRecordatorio);

module.exports = router;