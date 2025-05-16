import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:go_router/go_router.dart';

import 'package:tracktalk/shared/models/usuario_global.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';
  String mensaje = '';
  bool cargando = false;

  Future<void> _loginUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      cargando = true;
      mensaje = '';
    });

    final url = Uri.parse('http://10.0.2.2:3000/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'pass': pass,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // DATOS DEL USUARIO
        UsuarioGlobal.id = data['user']['id'];
        UsuarioGlobal.nombre = data['user']['nombre'];
        UsuarioGlobal.email = data['user']['email'];

        if (!mounted) return;
        context.go('/home');
      } else {
        final body = jsonDecode(response.body);
        setState(() {
          mensaje = '❌ ${body['error'] ?? 'Credenciales inválidas'}';
        });
      }
    } catch (e) {
      setState(() {
        mensaje = '❌ Error de conexión con el servidor';
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
        title: const Text('Iniciar sesión'),
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
                'Introduce tus credenciales',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
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
                validator: (val) => val == null || val.isEmpty
                    ? 'Introduce tu contraseña'
                    : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: cargando ? null : _loginUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E4E45),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: cargando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Iniciar sesión'),
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
