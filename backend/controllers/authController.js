const db = require('../db/sqlite');

// ----------- FUNCION DE REGISTRO ----------
const register = (req, res) => {
  const { nombre, email, pass } = req.body;

  if (!nombre || !email || !pass) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  // Verificación 
  const checkQuery = `SELECT * FROM Usuario WHERE email = ?`;
  db.get(checkQuery, [email], (err, row) => {
    if (err) {
      console.error('Error comprobando email:', err);
      return res.status(500).json({ error: 'Error en el servidor' });
    }

    if (row) {
      return res.status(409).json({ error: 'El correo ya está registrado' });
    }

    const insertQuery = `
      INSERT INTO Usuario (nombre, email, pass, fecha_registro)
      VALUES (?, ?, ?, datetime('now'))
    `;

    db.run(insertQuery, [nombre, email, pass], function (err) {
      if (err) {
        console.error('Error al registrar usuario:', err);
        return res.status(500).json({ error: 'Error al registrar' });
      }

      return res.status(201).json({ message: 'Usuario registrado correctamente', userId: this.lastID });
    });
  });
};

// ----------- FUNCION DE LOGIN ----------
const login = (req, res) => {
  const { email, pass } = req.body;

  if (!email || !pass) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  const query = `SELECT * FROM Usuario WHERE email = ? AND pass = ?`;

  db.get(query, [email, pass], (err, row) => {
    if (err) {
      console.error('Error en login:', err);
      return res.status(500).json({ error: 'Error en el servidor' });
    }

    if (!row) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    return res.status(200).json({
      message: 'Login correcto',
      user: {
        id: row.id,
        nombre: row.nombre,
        email: row.email,
        fecha_registro: row.fecha_registro
      }
    });
  });
};


// Exportar las funciones
module.exports = { register, login };

