import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterModal extends StatefulWidget {
  const RegisterModal({super.key});

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
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
        body: jsonEncode({'nombre': nombre, 'email': email, 'pass': pass}),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        final body = jsonDecode(response.body);
        setState(() {
          mensaje = '❌ ${body['error'] ?? 'Error desconocido'}';
        });
      }
    } catch (_) {
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
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.49,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8F6),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.15),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Crear cuenta',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E4E45),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF2E4E45)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...[
                    {
                      'label': 'Nombre',
                      'onChanged': (val) => nombre = val,
                      'validator': (val) =>
                          val!.isEmpty ? 'Introduce tu nombre' : null,
                    },
                    {
                      'label': 'Correo electrónico',
                      'onChanged': (val) => email = val,
                      'validator': (val) =>
                          val!.isEmpty ? 'Introduce un email' : null,
                    },
                    {
                      'label': 'Contraseña',
                      'obscure': true,
                      'onChanged': (val) => pass = val,
                      'validator': (val) => val!.length < 4
                          ? 'Debe tener al menos 4 caracteres'
                          : null,
                    },
                    {
                      'label': 'Confirmar contraseña',
                      'obscure': true,
                      'onChanged': (val) => repeatPass = val,
                      'validator': (val) =>
                          val != pass ? 'Las contraseñas no coinciden' : null,
                    },
                  ].map((field) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        obscureText: field['obscure'] == true,
                        decoration: InputDecoration(
                          labelText: field['label'] as String,
                          labelStyle: const TextStyle(color: Color(0xFF2E4E45)),
                          floatingLabelStyle:
                              const TextStyle(color: Color(0xFF2E4E45)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: Color(0xFFE1E1E1), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: Color(0xFF2E4E45), width: 2),
                          ),
                          focusColor: const Color(0xFF2E4E45),
                        ),
                        validator:
                            field['validator'] as String? Function(String?)?,
                        onChanged: field['onChanged'] as void Function(String),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: cargando ? null : _registrarUsuario,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E4E45),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: cargando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Registrarse',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    mensaje,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
