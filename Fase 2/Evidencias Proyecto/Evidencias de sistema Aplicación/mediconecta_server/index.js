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

// Usar las rutas
app.use('/api/usuarios', usuariosRoutes);
app.use('/api/doctores', doctoresRoutes);
app.use('/api/especialidades', especialidadesRoutes);
app.use('/api/citas', citasRoutes);
app.use('/api/disponibilidades', disponibilidadesRoutes);
app.use('/api/pacientes', pacientesRoutes);
app.use('/api/auth', authRoutes);

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});