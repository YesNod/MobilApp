import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Administrar Películas")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("movies").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar películas"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No hay películas registradas"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  leading: Image.network(
                    data['image'] ?? "https://via.placeholder.com/100",
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(data['title'] ?? "Sin título"),
                  subtitle: Text(
                    "Año: ${data['year']}\nDirector: ${data['director']}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("movies")
                          .doc(doc.id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, "/addMovie"),
      ),
    );
  }
}
