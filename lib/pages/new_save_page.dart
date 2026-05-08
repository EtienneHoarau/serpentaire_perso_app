import 'package:flutter/material.dart';
import '../data/database.dart';
import 'package:serpentaire_perso_app/data/classes.dart';

class NewSavePage extends StatefulWidget {
  final SavesDatabase db;

  const NewSavePage({super.key, required this.db});

  @override
  State<NewSavePage> createState() => _NewSavePageState();
}

class _NewSavePageState extends State<NewSavePage> {
  Save save = Save();
  int pointsCapacitesRestants = 5;
  int pointsTalentsRestants = 12;

  void createNewSave(Save save) {
    widget.db.mySaves.add(save);
    widget.db.updateData();
  }

  void increment(Capacite capacite) {
    if (pointsCapacitesRestants > 0) {
      setState(() {
        capacite.setValeur(capacite.valeur + 1);
        pointsCapacitesRestants--;
      });
    }
  }

  void decrement(Capacite capacite) {
    if (capacite.valeur > 0) {
      setState(() {
        capacite.setValeur(capacite.valeur - 1);
        pointsCapacitesRestants++;
      });
    }
  }

  void incrementTalent(Talent talent) {
    if (pointsTalentsRestants > 0) {
      setState(() {
        talent.setValeur(talent.valeur + 1);
        pointsTalentsRestants--;
      });
    }
  }

  void decrementTalent(Talent talent) {
    if (talent.valeur > 0) {
      setState(() {
        talent.setValeur(talent.valeur - 1);
        pointsTalentsRestants++;
      });
    }
  }

  void _editerValeur({
    required int valeurActuelle,
    required int pointsRestants,
    required void Function(int nouvelleValeur, int diff) onValide,
  }) {
    final controller = TextEditingController(text: valeurActuelle.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier la valeur'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final nouvelleValeur = int.tryParse(controller.text);
              if (nouvelleValeur != null && nouvelleValeur >= 0) {
                final diff = nouvelleValeur - valeurActuelle;
                if (diff > 0 && diff <= pointsRestants) {
                  setState(() => onValide(nouvelleValeur, diff));
                } else if (diff < 0) {
                  setState(() => onValide(nouvelleValeur, diff));
                }
              }
              Navigator.pop(context);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  Widget _boutonPlusMoins(IconData icone, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icone, size: 16),
      ),
    );
  }

  Widget capaciteBox(String label, Capacite capacite) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _editerValeur(
            valeurActuelle: capacite.valeur,
            pointsRestants: pointsCapacitesRestants,
            onValide: (nouvelleValeur, diff) {
              capacite.setValeur(nouvelleValeur);
              pointsCapacitesRestants -= diff;
            },
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                capacite.valeur.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _boutonPlusMoins(Icons.remove, () => decrement(capacite)),
            const SizedBox(width: 4),
            _boutonPlusMoins(Icons.add, () => increment(capacite)),
          ],
        ),
      ],
    );
  }

  Widget talentBox(String label, Talent talent) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _editerValeur(
            valeurActuelle: talent.valeur,
            pointsRestants: pointsTalentsRestants,
            onValide: (nouvelleValeur, diff) {
              talent.setValeur(nouvelleValeur);
              pointsTalentsRestants -= diff;
            },
          ),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                talent.valeur.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _boutonPlusMoins(Icons.remove, () => decrementTalent(talent)),
            const SizedBox(width: 4),
            _boutonPlusMoins(Icons.add, () => incrementTalent(talent)),
          ],
        ),
      ],
    );
  }

  bool get peutCreer =>
      pointsCapacitesRestants == 0 && pointsTalentsRestants == 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer une nouvelle sauvegarde')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Ici, vous pourrez créer une nouvelle sauvegarde.'),
          const SizedBox(height: 24),

          // Capacités
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Attribuez vos points de capacité',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    capaciteBox('Habileté', save.habilite),
                    capaciteBox('Force', save.force),
                    capaciteBox('Discrétion', save.discretion),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Il reste $pointsCapacitesRestants point${pointsCapacitesRestants > 1 ? 's' : ''} à assigner',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Talents
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Attribuez vos points de talent',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Table(
                  children: [
                    TableRow(children: [
                      talentBox('Savoir', save.savoir),
                      talentBox('Équitation', save.equitation),
                      talentBox('Tir', save.tir),
                    ]),
                    const TableRow(children: [
                      SizedBox(height: 12),
                      SizedBox(height: 12),
                      SizedBox(height: 12),
                    ]),
                    TableRow(children: [
                      talentBox('Crochetage', save.crochetage),
                      talentBox('Mêlée', save.melee),
                      talentBox('Manipulation', save.manipulation),
                    ]),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Il reste $pointsTalentsRestants point${pointsTalentsRestants > 1 ? 's' : ''} à assigner',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: peutCreer
                ? () {
                    createNewSave(save);
                    Navigator.pushNamed(
                      context,
                      '/save',
                      arguments: widget.db.mySaves.last.id,
                    );
                  }
                : null,
            child: const Text('Créer une sauvegarde'),
          ),
        ],
      ),
    );
  }
}