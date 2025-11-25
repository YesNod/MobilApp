import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController title = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController director = TextEditingController();
  final TextEditingController genre = TextEditingController();
  final TextEditingController sinopsis = TextEditingController();
  final TextEditingController image = TextEditingController();

  bool loading = false;

  Future<void> saveMovie() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    await FirebaseFirestore.instance.collection("movies").add({
      "title": title.text,
      "year": year.text,
      "director": director.text,
      "genre": genre.text,
      "sinopsis": sinopsis.text,
      "image": image.text,
    });

    setState(() => loading = false);
    Navigator.pop(context); // regresar a admin
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Película")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: year,
                decoration: const InputDecoration(labelText: "Año"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: director,
                decoration: const InputDecoration(labelText: "Director"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: genre,
                decoration: const InputDecoration(labelText: "Género"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: sinopsis,
                decoration: const InputDecoration(labelText: "Sinopsis"),
                maxLines: 4,
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              TextFormField(
                controller: image,
                decoration: const InputDecoration(labelText: "URL de imagen"),
                validator: (v) => v!.isEmpty ? "Requerido" : null,
              ),
              const SizedBox(height: 25),

              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Guardar"),
                      onPressed: saveMovie,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
