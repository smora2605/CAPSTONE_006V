// index.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Importar las rutas
const usuariosRoutes = require('./routes/usuariosRoutes');
const doctoresRoutes = require('./routes/doctoresRoutes');
const especialidadesRoutes = require('./routes/especialidadesRoutes');
const citasRoutes = require('./routes/citasRoutes');
const disponibilidadesRoutes = require('./routes/disponibilidadesRoutes');
const pacientesRoutes = require('./routes/pacientesRoutes');
const authRoutes = require('./routes/authRoutes');
const fichasMedicasRoutes = require('./routes/fichasMedicasRoutes');
const registroSaludRoutes = require('./routes/registroSaludRoutes');
const recordatorioRoutes = require('./routes/recordatorioRoutes');

// Usar las rutas
app.use('/api/usuarios', usuariosRoutes);
app.use('/api/doctores', doctoresRoutes);
app.use('/api/especialidades', especialidadesRoutes);
app.use('/api/citas', citasRoutes);
app.use('/api/disponibilidades', disponibilidadesRoutes);
app.use('/api/pacientes', pacientesRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/fichasMedicas', fichasMedicasRoutes);
app.use('/api/registro_salud', registroSaludRoutes);
app.use('/api/recordatorios', recordatorioRoutes);

// Ruta principal que responde con "Hola Mundo"
app.get('/', (req, res) => {
  res.send('Server running');
});

// Middleware para manejo de errores
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({ error: 'Ocurrió un error en el servidor' });
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});