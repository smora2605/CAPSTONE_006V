const pool = require('../db/pool');

// Obtener todas las disponibilidades
exports.getAllDisponibilidades = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM disponibilidades');
    res.json(result.rows);
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
