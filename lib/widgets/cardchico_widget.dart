import 'package:flutter/material.dart';

class CardChico extends StatelessWidget {
  final String nombre;
  final String categoria;
  final String imagen;
  final String autor;
  final VoidCallback onTapDetalles;
  final VoidCallback onTapEliminar;

  const CardChico({
    super.key,
    required this.nombre,
    required this.categoria,
    required this.imagen,
    required this.autor,
    required this.onTapDetalles,
    required this.onTapEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset('assets/images/$imagen', errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        }),
        title: Text(nombre),
        subtitle: Text('Categoría: $categoria\nAutor: $autor'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onTapEliminar,
        ),
        onTap: onTapDetalles,
      ),
    );
  }
}