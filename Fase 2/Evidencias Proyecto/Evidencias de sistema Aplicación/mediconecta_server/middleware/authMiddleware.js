const jwt = require('jsonwebtoken');

// Middleware para verificar si el usuario está autenticado
const verifyToken = (req, res, next) => {
  const token = req.header('Authorization');
  if (!token) return res.status(401).json({ error: 'Acceso denegado' });

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified;
    next();
  } catch (err) {
    res.status(400).json({ error: 'Token inválido' });
  }
};

// Middleware para verificar si el usuario es admin
const isAdmin = (req, res, next) => {
  if (req.user.tipo_usuario !== 'Administrador') {
    return res.status(403).json({ error: 'Acceso denegado. Se requiere un administrador.' });
  }
  next();
};

// Middleware para verificar si el usuario es doctor
const isDoctor = (req, res, next) => {
  if (req.user.tipo_usuario !== 'Doctor') {
    return res.status(403).json({ error: 'Acceso denegado. Se requiere un doctor.' });
  }
  next();
};

module.exports = { verifyToken, isAdmin, isDoctor };