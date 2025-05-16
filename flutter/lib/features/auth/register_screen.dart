import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String email = '';
  String pass = '';
  String repeatPass = '';
  String mensaje = '';
  bool cargando = false;

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      cargando = true;
      mensaje = '';
    });

    final url = Uri.parse('http://10.0.2.2:3000/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'email': email,
          'pass': pass,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          mensaje = '✅ Registro exitoso';
        });
      } else {
        final body = jsonDecode(response.body);
        setState(() {
          mensaje = '❌ ${body['error'] ?? 'Error desconocido'}';
        });
      }
    } catch (e) {
      setState(() {
        mensaje = '❌ Error de conexión';
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: const Color(0xFF2E4E45),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Completa el formulario para registrarte',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (val) => nombre = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Introduce tu nombre' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => email = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Introduce un email' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onChanged: (val) => pass = val,
                validator: (val) => val != null && val.length < 4
                    ? 'Mínimo 4 caracteres'
                    : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Repite la contraseña'),
                obscureText: true,
                onChanged: (val) => repeatPass = val,
                validator: (val) =>
                    val != pass ? 'Las contraseñas no coinciden' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: cargando ? null : _registrarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E4E45),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: cargando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Registrarse',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20),
              Text(
                mensaje,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
