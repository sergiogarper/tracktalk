const db = require('../db/sqlite');
const bcrypt = require('bcryptjs');

// ----------- FUNCION DE REGISTRO ----------
const register = (req, res) => {
  const { nombre, email, pass } = req.body;

  if (!nombre || !email || !pass) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  // Verificar si el email ya existe
  const checkQuery = `SELECT * FROM Usuario WHERE email = ?`;
  db.get(checkQuery, [email], async (err, row) => {
    if (err) {
      console.error('Error comprobando email:', err);
      return res.status(500).json({ error: 'Error en el servidor' });
    }

    if (row) {
      return res.status(409).json({ error: 'El correo ya está registrado' });
    }

    try {
      // Hashear la contraseña antes de guardar
      const hashedPass = await bcrypt.hash(pass, 10);

      const insertQuery = `
        INSERT INTO Usuario (nombre, email, pass, fecha_registro)
        VALUES (?, ?, ?, datetime('now'))
      `;

      db.run(insertQuery, [nombre, email, hashedPass], function (err) {
        if (err) {
          console.error('Error al registrar usuario:', err);
          return res.status(500).json({ error: 'Error al registrar' });
        }

        return res.status(201).json({
          message: 'Usuario registrado correctamente',
          userId: this.lastID,
        });
      });
    } catch (err) {
      console.error('Error al hashear contraseña:', err);
      return res.status(500).json({ error: 'Error interno al registrar' });
    }
  });
};

// ----------- FUNCION DE LOGIN ----------
const login = (req, res) => {
  const { email, pass } = req.body;

  if (!email || !pass) {
    return res.status(400).json({ error: 'Faltan campos obligatorios' });
  }

  const query = `SELECT * FROM Usuario WHERE email = ?`;

  db.get(query, [email], async (err, user) => {
    if (err) {
      console.error('Error en login:', err);
      return res.status(500).json({ error: 'Error en el servidor' });
    }

    if (!user) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    // Compara la contraseña con el hash
    const match = await bcrypt.compare(pass, user.pass);

    if (!match) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    return res.status(200).json({
      message: 'Login correcto',
      user: {
        id: user.id,
        nombre: user.nombre,
        email: user.email,
        fecha_registro: user.fecha_registro
      }
    });
  });
};

module.exports = { register, login };
