const pool = require('../db/pool');

// Obtener todas las disponibilidades
exports.getAllDisponibilidades = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        d.id AS doctor_id,
        u.nombre AS doctor_nombre,
        u.genero AS doctor_genero,
        e.nombre AS especialidad_nombre,
        di.fecha,
        di.hora_inicio,
        di.hora_fin
      FROM 
        disponibilidades di
      JOIN 
        doctores d ON di.doctor_id = d.id
      JOIN 
        usuarios u ON d.usuario_id = u.id  -- JOIN con la tabla usuarios
      JOIN 
        especialidades e ON d.especialidad_id = e.id
    `);
    res.json(result.rows);
    console.log('result.rows', result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getDisponibilidadesPorFecha = async (req, res) => {
  const { fecha } = req.params; // Suponemos que la fecha viene como parámetro en la query string
  console.log('req',req.params.fecha)
  console.log('Fecha', fecha);
  try {
    // Validación simple para asegurarnos de que la fecha no esté vacía
    if (!fecha) {
      return res.status(400).json({ error: 'La fecha es requerida' });
    }

    const result = await pool.query(
      `
      SELECT 
        d.id AS doctor_id,
        u.nombre AS doctor_nombre,
        u.genero AS doctor_genero,
        e.nombre AS especialidad_nombre,
        di.fecha,
        di.hora_inicio,
        di.hora_fin
      FROM 
        disponibilidades di
      JOIN 
        doctores d ON di.doctor_id = d.id
      JOIN 
        usuarios u ON d.usuario_id = u.id
      JOIN 
        especialidades e ON d.especialidad_id = e.id
      WHERE 
        di.fecha = $1
      `,
      [fecha] // Pasamos la fecha como parámetro para evitar inyección SQL
    );

    res.json(result.rows);
    console.log('Disponibilidades en la fecha:', result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Obtener disponibilidad de un doctor específico para el día actual
exports.getDisponibilidadDoctor = async (req, res) => {
  const { doctor_id } = req.params;
  const doctorIdNumber = parseInt(doctor_id, 10);

  // Obtener la fecha actual en formato YYYY-MM-DD
  const today = new Date().toISOString().split('T')[0]; // Formato: YYYY-MM-DD
  console.log(today);

  try {
    const result = await pool.query(
      `SELECT * FROM disponibilidades 
       WHERE doctor_id = $1 AND fecha = $2`,
      [doctorIdNumber, today]
    );
    console.log('Disponibilidades de hoy:', result.rows);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createAvailability = async (req, res) => {
  const { doctor_id, fecha, hora_inicio, hora_fin } = req.body;
  console.log('req.body',req.body)

  try {
    const result = await pool.query(
      `INSERT INTO disponibilidades (doctor_id, fecha, hora_inicio, hora_fin) 
       VALUES ($1, $2, $3, $4) 
       RETURNING *`,
      [doctor_id, fecha, hora_inicio, hora_fin]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Error al crear disponibilidad:', err);
    res.status(500).json({ error: err.message });
  }
};
