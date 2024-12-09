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
exports.getCitasPendientesPorPaciente = async (req, res) => {
  const pacienteId = req.params.pacienteId; // Obtener el ID del paciente desde los parámetros de la solicitud

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
        c.estado = $1 AND p.id = $2  -- Filtrar por estado y ID del paciente
      ORDER BY id DESC
    `, ['Pendiente', pacienteId]); // Se pasan los parámetros al query

    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getCitasPorDoctor = async (req, res) => {
  const doctorId = req.params.doctorId; // ID del doctor pasado como parámetro en la solicitud

  try {
    const result = await pool.query(`
      SELECT 
        c.id,
        c.paciente_id,
        c.doctor_id,
        pu.nombre AS paciente_nombre,
        pu.genero AS paciente_genero,
        du.nombre AS doctor_nombre,
        du.genero AS doctor_genero,
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
        c.doctor_id = $1  -- Filtro para el ID del doctor
    `, [doctorId]);

    res.json(result.rows); // Devuelve las citas obtenidas
  } catch (err) {
    console.error('Error al obtener las citas:', err);
    res.status(500).json({ error: err.message });
  }
};


exports.getCitasPendientesPorDoctor = async (req, res) => {
  const doctorId = req.params.doctorId; // Asumiendo que el id del doctor viene en los parámetros de la solicitud

  try {
    const result = await pool.query(`
      SELECT 
        c.id,
        c.paciente_id,
        c.doctor_id,
        pu.nombre AS paciente_nombre,
        pu.genero AS paciente_genero,
        du.nombre AS doctor_nombre,
        du.genero AS doctor_genero,
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
      AND 
        c.doctor_id = $2  -- Filtro para el ID del doctor
    `, ['Pendiente', doctorId]);

    console.log('result.rows', result.rows)
    res.json(result.rows);
  } catch (err) {
    console.log('errCitas', err)
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
    console.log('result.rows[0]',result.rows[0])
  } catch (err) {
    // Manejo de errores
    console.log('error al crear cita');
    res.status(500).json({ error: err.message });
  }
};

// Actualizar una cita
exports.updateCitaEstado = async (req, res) => {
  const { id } = req.params; // ID de la cita
  const { estado } = req.body; // Nuevo estado de la cita

  try {
    const result = await pool.query(
      'UPDATE citas SET estado = $1 WHERE id = $2 RETURNING *', // Consulta para actualizar solo el estado
      [estado, id] // Parámetros de la consulta
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Cita no encontrada' }); // Manejo de error si la cita no existe
    }

    res.json(result.rows[0]); // Respuesta con los datos actualizados de la cita
  } catch (err) {
    res.status(500).json({ error: err.message }); // Manejo de errores
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
