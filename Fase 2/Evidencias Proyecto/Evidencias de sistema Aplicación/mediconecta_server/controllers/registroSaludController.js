const pool = require('../db/pool');

// Obtener todas las citas
exports.getAllRegistrosSalud = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM citas');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Obtener el ID del paciente desde los parámetros de la solicitud
exports.getRegistrosSaludPorPaciente = async (req, res) => {
    const pacienteId = req.params.pacienteId; 

    try {
        const result = await pool.query(`
        SELECT 
            rs.id,
            rs.paciente_id,
            rs.nivel_glucosa,
            rs.presion_arterial,
            rs.frecuencia_cardiaca,
            rs.fecha_creacion
        FROM 
            registro_salud rs
        WHERE 
            rs.paciente_id = $1  -- Filtrar por ID del paciente
        ORDER BY rs.fecha_creacion ASC
        `, [pacienteId]); // Se pasan los parámetros al query

        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};
  

// Crear un nuevo registro de salud
exports.createRegistroSalud = async (req, res) => {
    const {
        paciente_id,
        nivel_glucosa,
        presion_arterial,
        frecuencia_cardiaca
    } = req.body;

    console.log('req.body', req.body);

    try {
        // Construimos el query SQL para insertar el registro de salud
        const result = await pool.query(
        `INSERT INTO registro_salud (paciente_id, nivel_glucosa, presion_arterial, frecuencia_cardiaca)
            VALUES ($1, $2, $3, $4) RETURNING *`,
        [
            paciente_id,
            nivel_glucosa || null,       // Si no se proporciona, insertar NULL
            presion_arterial || null,    // Si no se proporciona, insertar NULL
            frecuencia_cardiaca || null  // Si no se proporciona, insertar NULL
        ]
        );
        
        // Responder con el nuevo registro de salud creado
        res.json(result.rows[0]);
        console.log('result.rows[0]', result.rows[0]);
    } catch (err) {
        // Manejo de errores
        console.log('Error al crear registro de salud:', err.message);
        res.status(500).json({ error: err.message });
    }
};
  

