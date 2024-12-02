import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriaService {
  Stream<QuerySnapshot> categorias() {
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }
}