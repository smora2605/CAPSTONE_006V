const pool = require('../db/pool');

exports.getPacientes = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        p.id, 
        u.rut, 
        u.nombre, 
        p.prioridad, 
        p.enfermedades_cronicas AS "enfermedadesCronicas", 
        p.alergias, 
        p.status
      FROM pacientes p
      JOIN usuarios u ON p.usuario_id = u.id
      ORDER BY p.id ASC
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getPatientByUserId = async (req, res) => {
  const userId = req.params.userId; // Asumiendo que el id del usuario viene en los parámetros de la solicitud

  console.log('userId',userId)
  try {
    const result = await pool.query(`
      SELECT 
        p.id, 
        u.rut, 
        u.nombre, 
        p.prioridad, 
        p.status
      FROM 
        pacientes p
      JOIN 
        usuarios u ON p.usuario_id = u.id
      WHERE 
        p.usuario_id = $1  -- Filtramos por el user_id
        AND p.status = 'Activo'
      ORDER BY 
        p.id ASC
    `, [userId]); // Pasamos el userId como parámetro de consulta para evitar inyección SQL
    console.log('result',result.rows)

    res.json(result.rows); // Devolver los resultados como JSON
  } catch (err) {
    console.log('error',err);
    res.status(500).json({ error: err.message }); // Manejo de errores
  }
};

exports.createPatient = async (req, res) => {
  const {
    usuarioId,
    prioridad,
    enfermedadesCronicas,
    alergias,
    status,
  } = req.body;

  console.log('usuarioId', usuarioId)

  try {

    const result = await pool.query(
      `INSERT INTO pacientes (usuario_id, prioridad, enfermedades_cronicas, alergias, status) 
      VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [usuarioId, prioridad, enfermedadesCronicas, alergias, status]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.log('err', err);
    res.status(500).json({ error: err.message });
  }
};