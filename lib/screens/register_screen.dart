import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool isAdmin = false; // toggle para rol

  Future<void> register() async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // Guardamos el rol en Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': emailCtrl.text.trim(),
        'role': isAdmin ? "admin" : "user",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario registrado correctamente")),
      );

      Navigator.pushReplacementNamed(context, "/login");

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Es administrador"),
                Switch(
                  value: isAdmin,
                  onChanged: (v) => setState(() => isAdmin = v),
                )
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: register, child: const Text("Crear cuenta")),
          ],
        ),
      ),
    );
  }
}
