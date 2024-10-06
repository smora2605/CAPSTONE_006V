const express = require('express');
const router = express.Router();
const doctoresController = require('../controllers/doctoresController');

router.get('/', doctoresController.getDoctores);
router.get('/doctoresName', doctoresController.getDoctoresNames);
router.get('/doctoresMedicinaGeneral', doctoresController.getDoctoresConEspecialidadMedicinaGeneral);
router.get('/doctoresCardiologia', doctoresController.getDoctoresConEspecialidadCardiologia);
router.post('/', doctoresController.createDoctor);

module.exports = router;
