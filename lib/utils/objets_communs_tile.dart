import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:serpentaire_perso_app/data/classes.dart';

class ObjetsCommunsTile extends StatelessWidget {
  final BuildContext context;
  final Equipement equipement;
  final VoidCallback onTap;
  final Function(BuildContext)? deleteFunction;

  const ObjetsCommunsTile({
    super.key,
    required this.context,
    required this.equipement,
    required this.onTap,
    required this.deleteFunction,
  });

  void showInfos() {
    showDialog(
      context: (context),
      builder: (context) => AlertDialog(
        title: Text(equipement.nom),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Alignement à gauche
          children: [
            Text('Quantité : ${equipement.place}'),
            const SizedBox(height: 10),
            
            // Correction pour les Capacités
            if (equipement.bonusCapacites.isNotEmpty) ...[
              const Text('Bonus Capacités :', style: TextStyle(fontWeight: FontWeight.bold)),
              ...equipement.bonusCapacites.map((b) => Text('${b.nomStat.name} +${b.valeur}')),
              const SizedBox(height: 10),
            ],
            
            // Correction pour les Talents
            if (equipement.bonusTalents.isNotEmpty) ...[
              const Text('Bonus Talents :', style: TextStyle(fontWeight: FontWeight.bold)),
              ...equipement.bonusTalents.map((b) => Text('${b.nomStat.name} +${b.valeur}')),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              //label: 'Supprimer',
            ),
          ],
        ),
        child: Row(
          children: [
            ElevatedButton.icon(
              onPressed: showInfos, 
              
              icon : const Icon(Icons.inventory_2, color: Colors.white),
              label: const Text(''),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            
            const SizedBox(width: 20),
            Text(
              equipement.nom,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "x${equipement.place}",
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
