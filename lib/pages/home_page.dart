import 'package:flutter/material.dart';
import '../data/database.dart';
import 'package:serpentaire_perso_app/pages/save_tile.dart';

class HomePage extends StatefulWidget {
  final SavesDatabase db;
  const HomePage({super.key, required this.db});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SavesDatabase db; // déclaré ici

  @override
  void initState() {
    super.initState();
    db = widget.db; // initialisé ici
  }


  void deleteSave(int index) {
    setState(() {
      db.mySaves.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    // plus besoin de "final db = widget.db;" ici
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Serpentaire Perso App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/new_save');
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Text("Bienvenue dans l'application de gestion de personnage pour Serpentaire!"),
          Text("Choisissez une sauvegarde pour commencer à gérer votre personnage."),
          Expanded(
            child: ListView.builder(
              itemCount: db.mySaves.length,
              itemBuilder: (context, index) {
                return SaveTile(
                  name: db.mySaves[index].name,
                  onTap: () {
                    Navigator.pushNamed(context, '/save', arguments: db.mySaves[index].id);
                  },
                  deleteFunction: (context) => deleteSave(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}