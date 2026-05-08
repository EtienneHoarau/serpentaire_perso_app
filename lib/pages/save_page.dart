import 'package:flutter/material.dart';
import 'package:serpentaire_perso_app/data/classes.dart';
import '../data/database.dart';

class SavePage extends StatefulWidget {
  final SavesDatabase db;
  final int id;

  const SavePage({super.key, required this.id, required this.db});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  late Save save;

  @override
  void initState() {
    super.initState();
    save = widget.db.mySaves.firstWhere((s) => s.id == widget.id);
  }

  Widget capaciteBox(String label, Capacite capacite) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("${capacite.valeur}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 200,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: const Icon(Icons.home),
                  ),
                  const SizedBox(width: 8),
                  Text("Save: ${widget.id}"),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "Détails du personnage",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    capaciteBox("Habileté", save.habilite),
                    const SizedBox(width: 8),
                    capaciteBox("Force", save.force),
                    const SizedBox(width: 8),
                    capaciteBox("Vigueur", save.vigueur),
                    const SizedBox(width: 8),
                    capaciteBox("Discrétion", save.discretion),
                  ],
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Capacités"),
              Tab(text: "Talents"),
              Tab(text: "Inventaire"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("Capacités")),
            Center(child: Text("Talents")),
            Center(child: Text("Inventaire")),
          ],
        ),
      ),
    );
  }
}
