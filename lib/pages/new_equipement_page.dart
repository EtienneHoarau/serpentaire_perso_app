import 'package:flutter/material.dart';
import 'package:serpentaire_perso_app/data/database.dart';
import 'package:serpentaire_perso_app/data/classes.dart';
import '../utils/choose_bonus_equipement_tile.dart';

class NewEquipementPage extends StatefulWidget {
  final Save  save;
  final SavesDatabase db;
  const NewEquipementPage({super.key, required this.save, required this.db});

  @override
  State<NewEquipementPage> createState() => _NewEquipementPageState();
}

class _NewEquipementPageState extends State<NewEquipementPage> {

  Equipement newEquipement = Equipement(nom: '', place: 1, bonusCapacites: [], bonusTalents: []);
  List<BonusCapacite> bonusCapacites = [];
  List<BonusTalent> bonusTalents = [];


  void appliquerBonusEquipement(Save save, Equipement equipement) {
    for (final bonus in equipement.bonusCapacites) {
      save.getCapacite(bonus.nomStat).addModificateur(bonus.valeur);
    }

    for (final bonus in equipement.bonusTalents) {
      save.getTalent(bonus.nomStat).addValeur(bonus.valeur);
    }
  }

  void saveEquipement() {
    setState(() {
      widget.save.besace.addEquipement(newEquipement);
      appliquerBonusEquipement(widget.save, newEquipement);
      widget.db.updateData();
    });
    Navigator.pop(context);
  }

  bool get canSave => newEquipement.nom.trim().isNotEmpty && newEquipement.place > 0 ;

  bool get tooBigBonus => widget.save.besace.getTotalQuantity() + newEquipement.place > Besace.maxEmplacements;

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un équipement'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (!canSave) {
                return;
              }
              else if (tooBigBonus) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Besace pleine'),
                    content: Text('Cet équipement dépasse la capacité maximale de votre besace. Veuillez réduire la place occupée ou supprimer d\'autres équipements.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
                return;
              }
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirmer l\'ajout'),
                  content: Text('Êtes-vous sûr de vouloir ajouter cet équipement ?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        saveEquipement();
                        Navigator.pop(context);
                      },
                      child: Text('Oui'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Non'),
                    ),
                  ],
                ),
              );
            },
          )],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ici, vous pourrez ajouter un équipement à votre besace.'),  
              _sectionTitle('Nom de l\'équipement'),
              TextField(
                decoration: InputDecoration(labelText: 'Nom de l\'équipement'),
                onChanged: (value) {
                  setState(() {
                    newEquipement.nom = value;
                  });
                },
              ),
              _sectionTitle("Place occupée par l'équipement"),
              TextField(
                decoration: InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    newEquipement.place = int.tryParse(value) ?? 1;
                  });
                },
              ),
              _sectionTitle("Modificateurs de capacité"),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: newEquipement.bonusCapacites.length,
                itemBuilder: (context, index) {
                  return ChooseBonusEquipementTile(isCapacite: true, bonus: newEquipement.bonusCapacites[index]);
                },
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    newEquipement.bonusCapacites.add(BonusCapacite(nomStat: NomCapacite.force, valeur: 0));
                  });
                },
                label: Text('Ajouter un bonus de capacité'),
                icon: Icon(Icons.add),
              ),
              _sectionTitle("Modificateurs de talent"),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: newEquipement.bonusTalents.length,
                itemBuilder: (context, index) {
                  return ChooseBonusEquipementTile(isCapacite: false, bonus: newEquipement.bonusTalents[index]);
                },
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    newEquipement.bonusTalents.add(BonusTalent(nomStat: NomTalent.melee, valeur: 0));
                  });
                },
                label: Text('Ajouter un bonus de talent'),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}