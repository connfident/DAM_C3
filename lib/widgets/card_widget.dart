import 'package:flutter/material.dart';

class TarjetaReceta extends StatelessWidget {
  final String nombre;
  final String categoria;
  final String imagen;
  final String autor;
  final VoidCallback alPresionarDetalles;

  const TarjetaReceta({
    super.key,
    required this.nombre,
    required this.categoria,
    required this.imagen,
    required this.autor,
    required this.alPresionarDetalles,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombre,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              categoria,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/$imagen', errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Autor: $autor',
                  style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
                ElevatedButton(
                  onPressed: alPresionarDetalles,
                  child: const Text('Detalles'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}