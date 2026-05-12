import 'package:flutter/material.dart';
import '../data/classes.dart';


class ChooseBonusEquipementTile extends StatefulWidget {
  final bool isCapacite;
  final BonusStat bonus;
  final VoidCallback? onDelete;
  const ChooseBonusEquipementTile({super.key, required this.bonus, this.onDelete, required this.isCapacite});

  @override
  State<ChooseBonusEquipementTile> createState() => _ChooseBonusEquipementTileState();
}

class _ChooseBonusEquipementTileState extends State<ChooseBonusEquipementTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          DropdownButton(
            value: widget.isCapacite ? (widget.bonus as BonusCapacite).nomStat : (widget.bonus as BonusTalent).nomStat,
            items: widget.isCapacite
                ? NomCapacite.values.map((nom) {
                    return DropdownMenuItem(
                      value: nom,
                      child: Text(nom.name),
                    );
                  }).toList()
                : NomTalent.values.map((nom) {
                    return DropdownMenuItem(
                      value: nom,
                      child: Text(nom.name),
                    );
                  }).toList(),
            onChanged: (value) {
              setState(() {
                widget.bonus.nomStat = value!;
              });
            },
          ),
          
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: 'Valeur'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  widget.bonus.valeur = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: widget.onDelete,
          )
        ],
      ),
    );
  }
}