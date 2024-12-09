const pool = require('../db/pool');

// Obtener todas las citas
exports.getAllRecordatorios = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM recordatorios_medicamentos');
    console.log('result.rowsRecordatorios',result.rows)
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Crear un nuevo recordatorio
exports.createRecordatorio = async (req, res) => {
  const { id_paciente, id_doctor, id_ficha_medica, desc_medicamento, frecuencia, duracion_dias } = req.body;

  console.log('CreaRecordatorio');
  try {
    const result = await pool.query(
      `INSERT INTO recordatorios_medicamentos 
       (id_paciente, id_doctor, id_ficha_medica, desc_medicamento, frecuencia, duracion_dias) 
       VALUES ($1, $2, $3, $4, $5, $6) 
       RETURNING *`,
      [id_paciente, id_doctor, id_ficha_medica, desc_medicamento, frecuencia, duracion_dias]
    );

    res.status(201).json(result.rows[0]); // Devuelve el registro insertado
  } catch (err) {
    console.error('Error al crear el recordatorio:', err);
    res.status(500).json({ error: err.message });
  }
};
