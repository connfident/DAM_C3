import 'package:flutter/material.dart';

class DetallePage extends StatelessWidget {
  final String nombre;
  final String categoria;
  final String imagen;
  final String autor;
  final String instrucciones;

  const DetallePage({
    super.key,
    required this.nombre,
    required this.categoria,
    required this.imagen,
    required this.autor,
    required this.instrucciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nombre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              nombre,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Categoría: $categoria',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/$imagen',
                errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            }),
            const SizedBox(height: 10),
            Text(
              'Autor: $autor',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            const Text(
              'Instrucciones:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              instrucciones,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
