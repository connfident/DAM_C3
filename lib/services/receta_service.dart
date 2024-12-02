import 'package:cloud_firestore/cloud_firestore.dart';

class RecetaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<QuerySnapshot> recetasByUser(String userName) {
    return _db
        .collection('recetas')
        .where('autor', isEqualTo: userName)
        .snapshots();
  }

  Stream<QuerySnapshot> recetas() {
    return FirebaseFirestore.instance.collection('recetas').snapshots();
  }

  Future<void> agregarReceta(String nombre, String categoria,
      String instrucciones, String autor, String imagen) {
    return FirebaseFirestore.instance.collection('recetas').add({
      'nombre': nombre,
      'categoria': categoria,
      'imagen': imagen,
      'instrucciones': instrucciones,
      'autor': autor,
    });
  }

  Future<void> eliminarReceta(String id) {
    return FirebaseFirestore.instance.collection('recetas').doc(id).delete();
  }
}
