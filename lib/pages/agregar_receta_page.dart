import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/categoria_service.dart';
import 'package:flutter_application_1/services/receta_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgregarRecetaPage extends StatefulWidget {
  const AgregarRecetaPage({super.key});

  @override
  _AgregarRecetaPageState createState() => _AgregarRecetaPageState();
}

class _AgregarRecetaPageState extends State<AgregarRecetaPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _nombre = '';
  String? _categoriaSeleccionada;
  String _instrucciones = '';
  String? _autor;
  String? _imagenSeleccionada;

  @override
  void initState() {
    super.initState();
    _autor = _auth.currentUser?.displayName ?? 'Usuario';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Receta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    _nombre = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: CategoriaService().categorias(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  List<DropdownMenuItem<String>> items =
                      snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc['nombre'],
                      child: Text(doc['nombre']),
                      onTap: () {
                        setState(() {
                          _imagenSeleccionada = doc['imagen'];
                        });
                      },
                    );
                  }).toList();
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    value: _categoriaSeleccionada,
                    items: items,
                    onChanged: (value) {
                      setState(() {
                        _categoriaSeleccionada = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La categoría es requerida';
                      }
                      return null;
                    },
                  );
                },
              ),
              if (_imagenSeleccionada != null)
                Image.asset('assets/images/$_imagenSeleccionada',
                    errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                }),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Instrucciones'),
                maxLines: 5,
                onChanged: (value) {
                  setState(() {
                    _instrucciones = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Las instrucciones son requeridas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('Autor: $_autor'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    RecetaService()
                        .agregarReceta(
                      _nombre,
                      _categoriaSeleccionada!,
                      _instrucciones,
                      _autor!,
                      _imagenSeleccionada!,
                    )
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Receta agregada')));
                      Navigator.pop(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Error al agregar receta')));
                    });
                  }
                },
                child: const Text('Agregar Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
