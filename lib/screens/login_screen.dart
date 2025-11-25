import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  Future<void> login() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      final uid = userCredential.user!.uid;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("ERROR: El usuario no tiene rol asignado."),
        ));
        return;
      }

      final role = doc['role'];

      // 🔥 Cambiado: navegación por rutas nombradas
      if (role == "admin") {
        Navigator.pushReplacementNamed(context, "/admin");
      } else {
        Navigator.pushReplacementNamed(context, "/home");
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/register"),
              child: const Text("Crear cuenta"),
            )
          ],
        ),
      ),
    );
  }
}
