import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  Uint8List? imageBytes;
  final ImagePicker picker = ImagePicker();
  bool loading = false;

  Future<void> pickPhoto() async {
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      imageBytes = await photo.readAsBytes();
      setState(() {});
    }
  }

  Future<void> verify() async {
    if (emailCtrl.text.isEmpty || imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa correo y toma foto')));
      return;
    }
    setState(() { loading = true; });
    final result = await ApiService.verifyUser(email: emailCtrl.text, photoBytes: imageBytes!);
    setState(() { loading = false; });
    if (result != null && result['match'] == true) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(user: result['user'])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay coincidencia')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Correo')),
            const SizedBox(height: 12),
            if (imageBytes != null) Image.memory(imageBytes!, width: 150, height: 150),
            ElevatedButton.icon(onPressed: pickPhoto, icon: const Icon(Icons.camera_alt), label: const Text('Tomar foto')),
            const SizedBox(height: 12),
            loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: verify, child: const Text('Verificar')),
          ],
        ),
      ),
    );
  }
}
