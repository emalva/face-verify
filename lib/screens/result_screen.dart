import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map user;
  const ResultScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Nombre: \${user['first_name']} \${user['last_name']}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              Text('Correo: \${user['email']}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
