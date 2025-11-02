import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'verify_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  Uint8List? imageBytes;
  final ImagePicker picker = ImagePicker();
  bool loading = false;

  Future<void> pickPhoto() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      imageBytes = await photo.readAsBytes();
      setState(() {});
    }
  }

  Future<void> register() async {
    if (firstNameCtrl.text.isEmpty || emailCtrl.text.isEmpty || imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa nombre, correo y foto')));
      return;
    }
    setState(() { loading = true; });
    final res = await ApiService.registerUser(
      firstName: firstNameCtrl.text,
      lastName: lastNameCtrl.text,
      email: emailCtrl.text,
      photoBytes: imageBytes!,
    );
    setState(() { loading = false; });
    if (res == true) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const VerifyScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro falló')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: firstNameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: lastNameCtrl, decoration: const InputDecoration(labelText: 'Apellido')),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Correo')),
              const SizedBox(height: 12),
              if (imageBytes != null) Image.memory(imageBytes!, width: 150, height: 150),
              ElevatedButton.icon(onPressed: pickPhoto, icon: const Icon(Icons.camera_alt), label: const Text('Tomar foto')),
              const SizedBox(height: 12),
              loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: register, child: const Text('Registrar')),
            ],
          ),
        ),
      ),
    );
  }
}
