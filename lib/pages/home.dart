import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/agregar_receta_page.dart';
import 'package:flutter_application_1/pages/detalle_page.dart';
import 'package:flutter_application_1/pages/gestion_receta_page.dart';
import 'package:flutter_application_1/services/auth_services.dart';
import 'package:flutter_application_1/widgets/card_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 25, 0, 255),
        title: const Text('Recetario', style: TextStyle(color: Colors.white)),
        leading: Icon(MdiIcons.firebase, color: Colors.white),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                _auth.currentUser?.displayName ?? 'Usuario',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(_auth.currentUser?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_auth.currentUser?.photoURL ??
                    'https://www.example.com/default-avatar.png'),
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 25, 0, 255),
              ),
            ),
            // Agregar Receta
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Agregar Receta'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AgregarRecetaPage(),
                  ),
                );
              },
            ),
            // Gestionar Recetas
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Gestionar Recetas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GestionRecetaPage(),
                  ),
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () async {
                await _authService.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hola, ${_auth.currentUser?.displayName ?? 'Usuario'}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('recetas')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No hay recetas disponibles.'));
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var receta = snapshot.data!.docs[index];
                      return TarjetaReceta(
                        nombre: receta['nombre'],
                        categoria: receta['categoria'],
                        imagen: receta['imagen'],
                        autor: receta['autor'],
                        alPresionarDetalles: () {
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
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
