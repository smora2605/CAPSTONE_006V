const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const pool = require('../db/pool');

// Método para registrar un nuevo usuario
exports.register = async (req, res) => {
  const { nombre, email, telefono, fecha_nacimiento, genero, password } = req.body;

  try {
    // Verificar si el usuario ya existe
    const userExists = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
    if (userExists.rows.length > 0) {
      return res.status(400).json({ error: 'El email ya está registrado.' });
    }

    // Hashear la contraseña
    const hashedPassword = await bcrypt.hash(password, 10);

    // Registrar solo pacientes
    const tipo_usuario = 'Paciente';

    // Insertar el nuevo usuario en la base de datos
    const result = await pool.query(
      'INSERT INTO usuarios (nombre, email, telefono, fecha_nacimiento, genero, password, tipo_usuario) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [nombre, email, telefono, fecha_nacimiento, genero, hashedPassword, tipo_usuario]
    );

    // Retornar la información del usuario (sin la contraseña)
    res.status(201).json({
      id: result.rows[0].id,
      nombre: result.rows[0].nombre,
      email: result.rows[0].email,
      tipo_usuario: result.rows[0].tipo_usuario
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Método para login de usuarios
exports.login = async (req, res) => {
  const { email, password } = req.body;

  console.log('email', email);
  console.log('password', password);

  try {
    // Verificar si el usuario existe
    const result = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
    const user = result.rows[0];
    console.log('user',user);

    if (!user) {
      console.log('user2',user);
      return res.status(400).json({ error: 'Credenciales incorrectas.' });
    }

    // Comparar la contraseña
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      console.log('validPassword', validPassword)
      return res.status(400).json({ error: 'Credenciales incorrectas.' });
    }

    // Generar un token JWT
    const token = jwt.sign(
      {
        id: user.id,
        nombre: user.nombre,
        email: user.email,
        tipo_usuario: user.tipo_usuario
      },
      process.env.JWT_SECRET, // Llave secreta almacenada en las variables de entorno
      { expiresIn: '1h' } // El token expirará en 1 hora
    );

    // Retornar el token
    res.json({ token });
  } catch (err) {
    console.log('err',err)
    res.status(500).json({ error: err.message });
  }
};