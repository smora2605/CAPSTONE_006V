const pool = require('../db/pool');

exports.getDoctores = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT d.id, u.rut, u.nombre, u.email, u.telefono, d.licencia_medica, d.direccion_consulta, d.status, e.nombre AS especialidad
      FROM doctores d
      JOIN usuarios u ON d.usuario_id = u.id
      LEFT JOIN especialidades e ON d.especialidad_id = e.id
      Order By id ASC 
    `);
    res.json(result.rows);
  } catch (err) {
    console.log(err)
    res.status(500).json({ error: err.message });
  }
};

exports.getDoctoresNames = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT d.id, u.nombre, u.genero , e.nombre AS especialidad
      FROM doctores d
      JOIN usuarios u ON d.usuario_id = u.id
      LEFT JOIN especialidades e ON d.especialidad_id = e.id
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getDoctoresConEspecialidadMedicinaGeneral = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT d.id, u.nombre, e.nombre AS especialidad
      FROM doctores d
      JOIN usuarios u ON d.usuario_id = u.id
      LEFT JOIN especialidades e ON d.especialidad_id = e.id
      JOIN disponibilidades disp ON disp.doctor_id = d.id
      WHERE e.nombre = 'Medicina general'
      AND disp.fecha = CURRENT_DATE  -- Filtra por la fecha actual
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getDoctoresConEspecialidadCardiologia = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT d.id, u.nombre, e.nombre AS especialidad
      FROM doctores d
      JOIN usuarios u ON d.usuario_id = u.id
      LEFT JOIN especialidades e ON d.especialidad_id = e.id
      JOIN disponibilidades disp ON disp.doctor_id = d.id
      WHERE e.nombre = 'Cardiología'
      AND disp.fecha = CURRENT_DATE  -- Filtra por la fecha actual
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getDoctorByUserId = async (req, res) => {
  const userId = req.params.userId; // Asumiendo que el id del usuario viene en los parámetros de la solicitud

  console.log('userId',userId)
  try {
    const result = await pool.query(`
      SELECT 
        d.id, 
        u.rut, 
        u.nombre, 
        d.licencia_medica, 
        d.status, 
        e.nombre AS especialidad
      FROM 
        doctores d
      JOIN 
        usuarios u ON d.usuario_id = u.id
      LEFT JOIN 
        especialidades e ON d.especialidad_id = e.id
      WHERE 
        d.usuario_id = $1  -- Filtramos por el user_id
        AND d.status = 'Activo'
      ORDER BY 
        d.id ASC
    `, [userId]); // Pasamos el userId como parámetro de consulta para evitar inyección SQL
    console.log('result',result.rows)

    res.json(result.rows); // Devolver los resultados como JSON
  } catch (err) {
    console.log('error',err);
    res.status(500).json({ error: err.message }); // Manejo de errores
  }
};

exports.createDoctor = async (req, res) => {
  const { usuario_id, licencia_medica, direccion_consulta, especialidad_id } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO doctores (usuario_id, licencia_medica, direccion_consulta, especialidad_id) VALUES ($1, $2, $3, $4) RETURNING *',
      [usuario_id, licencia_medica, direccion_consulta, especialidad_id]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};