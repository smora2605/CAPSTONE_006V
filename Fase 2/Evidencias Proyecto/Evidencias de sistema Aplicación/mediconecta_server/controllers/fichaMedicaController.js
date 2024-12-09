const pool = require('../db/pool');

// Obtener todas las citas
exports.getAllFichasMedicas = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM ficha_medica');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Crear una nueva cita
exports.createFichaMedica = async (req, res) => {
    const {
        id_cita,
        id_paciente,
        id_doctor,
        motivo_consulta,
        peso,
        altura,
        presion_arterial,
        frecuencia_cardiaca,
        examen_fisico,
        diagnostico,
        tratamiento,
        // medicamento_1,
        // frecuencia_medicamento_1,
        // dias_medicamento_1,
        // medicamento_2,
        // frecuencia_medicamento_2,
        // dias_medicamento_2,
        // recordatorio,
        // frecuencia_recordatorio,
        // dias_recordatorio
    } = req.body;

    console.log('Request Body:', req.body);

    try {
        const result = await pool.query(
            `INSERT INTO ficha_medica (
                id_cita, id_paciente, id_doctor, motivo_consulta, 
                peso, altura, presion_arterial, frecuencia_cardiaca, examen_fisico, diagnostico, 
                tratamiento
            ) VALUES (
                $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
            ) RETURNING *`,
            [
                id_cita, id_paciente, id_doctor, motivo_consulta, 
                peso, altura, presion_arterial, frecuencia_cardiaca, 
                examen_fisico, diagnostico, 
                tratamiento
            ]
        );

        res.json(result.rows[0]);  // Responder con la ficha creada
    } catch (err) {
        console.error('Error al crear ficha médica:', err.message);
        res.status(500).json({ error: err.message });
    }
};
