import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/pages/detalle_page.dart';
import 'package:flutter_application_1/services/receta_service.dart';
import 'package:flutter_application_1/widgets/cardchico_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GestionRecetaPage extends StatelessWidget {
  const GestionRecetaPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? userName = FirebaseAuth.instance.currentUser!.displayName;

    if (userName == null) {
      return const Center(child: Text('No hay usuario logueado.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Recetas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: RecetaService().recetasByUser(userName),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tienes recetas disponibles.'));
          }

          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var receta = snapshot.data!.docs[index];
              return Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallePage(
                              nombre: receta['nombre'],
                              categoria: receta['categoria'],
                              imagen: receta['imagen'],
                              autor: receta['autor'],
                              instrucciones: receta['instrucciones'],
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.info,
                      label: 'Detalles',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) =>
                          _eliminarReceta(context, receta.id),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Eliminar',
                    ),
                  ],
                ),
                child: CardChico(
                  nombre: receta['nombre'],
                  categoria: receta['categoria'],
                  imagen: receta['imagen'],
                  autor: receta['autor'],
                  onTapDetalles: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetallePage(
                          nombre: receta['nombre'],
                          categoria: receta['categoria'],
                          imagen: receta['imagen'],
                          autor: receta['autor'],
                          instrucciones: receta['instrucciones'],
                        ),
                      ),
                    );
                  },
                  onTapEliminar: () => _eliminarReceta(context, receta.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _eliminarReceta(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta receta?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                RecetaService().eliminarReceta(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
