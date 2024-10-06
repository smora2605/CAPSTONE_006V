const pool = require('../db/pool');

// Obtener todas las citas
exports.getAllCitas = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM citas');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Obtiene todas las citas en Pendiente //Proximamente solo debe traer las del mismo user que esta loggeado en la app
// Obtiene todas las citas en Pendiente, con nombres de paciente y doctor
exports.getCitasPendientes = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        c.id,
        pu.nombre AS paciente_nombre,
        pu.genero AS paciente_genero,   -- Género del paciente
        du.nombre AS doctor_nombre,
        du.genero AS doctor_genero,     -- Género del doctor
        e.nombre AS especialidad,
        c.fecha,
        c.hora,
        c.motivo,
        c.estado
      FROM 
        citas c
      JOIN 
        pacientes p ON c.paciente_id = p.id
      JOIN 
        usuarios pu ON p.usuario_id = pu.id  -- Unir con la tabla usuarios (paciente)
      JOIN 
        doctores d ON c.doctor_id = d.id
      JOIN 
        usuarios du ON d.usuario_id = du.id  -- Unir con la tabla usuarios (doctor)
      JOIN 
        especialidades e ON d.especialidad_id = e.id
      WHERE 
        c.estado = $1
    `, ['Pendiente']);

    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Crear una nueva cita
exports.createCita = async (req, res) => {
  const {
    paciente_id,
    doctor_id,
    fecha,
    hora,         // Hora específica de la cita (tipo TIME o similar)
    motivo,       
    estado        
  } = req.body;

  console.log('reqbody', req.body);

  try {
    // Actualizamos el query SQL con los nuevos campos
    const result = await pool.query(
      `INSERT INTO citas (paciente_id, doctor_id, fecha, hora, motivo, estado)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [paciente_id, doctor_id, fecha, hora, motivo, estado]
    );
    
    // Responder con la nueva cita creada
    res.json(result.rows[0]);
  } catch (err) {
    // Manejo de errores
    console.log('error al crear cita');
    res.status(500).json({ error: err.message });
  }
};


// Actualizar una cita
exports.updateCita = async (req, res) => {
  const { id } = req.params;
  const { paciente_id, doctor_id, especialidad_id, fecha, duracion, descripcion } = req.body;
  try {
    const result = await pool.query(
      'UPDATE citas SET paciente_id = $1, doctor_id = $2, especialidad_id = $3, fecha = $4, duracion = $5, descripcion = $6 WHERE id = $7 RETURNING *',
      [paciente_id, doctor_id, especialidad_id, fecha, duracion, descripcion, id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Eliminar una cita
exports.deleteCita = async (req, res) => {
  const { id } = req.params;
  try {
    await pool.query('DELETE FROM citas WHERE id = $1', [id]);
    res.status(204).send();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
