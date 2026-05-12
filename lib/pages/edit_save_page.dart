import 'package:flutter/material.dart';
import '../data/database.dart';
import '../data/classes.dart';

class EditSavePage extends StatefulWidget {
  final int id;
  final SavesDatabase db;

  const EditSavePage({super.key, required this.id, required this.db});

  @override
  State<EditSavePage> createState() => _EditSavePageState();
}

class _EditSavePageState extends State<EditSavePage> {
  late Save save;

  late TextEditingController _nameController;
  late TextEditingController _lastChapiterController;
  late TextEditingController _habValeur, _habModif;
  late TextEditingController _forceValeur, _forceModif;
  late TextEditingController _vigueurValeur, _vigueurModif;
  late TextEditingController _discValeur, _discModif;
  late TextEditingController _xpController;
  late TextEditingController _destController;
  late TextEditingController _savoirValeur, _savoirXp;
  late TextEditingController _equitValeur, _equitXp;
  late TextEditingController _tirValeur, _tirXp;
  late TextEditingController _crochValeur, _crochXp;
  late TextEditingController _meleeValeur, _meleeXp;
  late TextEditingController _manipValeur, _manipXp;
  late TextEditingController _souverains, _poignards, _carreaux;

  @override
  void initState() {
    super.initState();
    save = widget.db.mySaves.firstWhere((s) => s.id == widget.id);

    _nameController = TextEditingController(text: save.name);
    _lastChapiterController = TextEditingController(
      text: save.lastChapiter.toString(),
    );
    _habValeur = TextEditingController(text: save.habilite.valeur.toString());
    _habModif = TextEditingController(
      text: save.habilite.modificateur.toString(),
    );
    _forceValeur = TextEditingController(text: save.force.valeur.toString());
    _forceModif = TextEditingController(
      text: save.force.modificateur.toString(),
    );
    _vigueurValeur = TextEditingController(
      text: save.vigueur.valeur.toString(),
    );
    _vigueurModif = TextEditingController(
      text: save.vigueur.modificateur.toString(),
    );
    _discValeur = TextEditingController(
      text: save.discretion.valeur.toString(),
    );
    _discModif = TextEditingController(
      text: save.discretion.modificateur.toString(),
    );
    _xpController = TextEditingController(
      text: save.pointsSupplementaires.xp.toString(),
    );
    _destController = TextEditingController(
      text: save.pointsSupplementaires.pointsDestin.toString(),
    );
    _savoirValeur = TextEditingController(text: save.savoir.valeur.toString());
    _savoirXp = TextEditingController(text: save.savoir.xp.toString());
    _equitValeur = TextEditingController(
      text: save.equitation.valeur.toString(),
    );
    _equitXp = TextEditingController(text: save.equitation.xp.toString());
    _tirValeur = TextEditingController(text: save.tir.valeur.toString());
    _tirXp = TextEditingController(text: save.tir.xp.toString());
    _crochValeur = TextEditingController(
      text: save.crochetage.valeur.toString(),
    );
    _crochXp = TextEditingController(text: save.crochetage.xp.toString());
    _meleeValeur = TextEditingController(text: save.melee.valeur.toString());
    _meleeXp = TextEditingController(text: save.melee.xp.toString());
    _manipValeur = TextEditingController(
      text: save.manipulation.valeur.toString(),
    );
    _manipXp = TextEditingController(text: save.manipulation.xp.toString());
    _souverains = TextEditingController(
      text: save.consommables.souverains.toString(),
    );
    _poignards = TextEditingController(
      text: save.consommables.poignards.toString(),
    );
    _carreaux = TextEditingController(
      text: save.consommables.carreaux.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastChapiterController.dispose();
    _habValeur.dispose();
    _habModif.dispose();
    _forceValeur.dispose();
    _forceModif.dispose();
    _vigueurValeur.dispose();
    _vigueurModif.dispose();
    _discValeur.dispose();
    _discModif.dispose();
    _xpController.dispose();
    _destController.dispose();
    _savoirValeur.dispose();
    _savoirXp.dispose();
    _equitValeur.dispose();
    _equitXp.dispose();
    _tirValeur.dispose();
    _tirXp.dispose();
    _crochValeur.dispose();
    _crochXp.dispose();
    _meleeValeur.dispose();
    _meleeXp.dispose();
    _manipValeur.dispose();
    _manipXp.dispose();
    _souverains.dispose();
    _poignards.dispose();
    _carreaux.dispose();
    super.dispose();
  }

  int _parseInt(TextEditingController c, int fallback) =>
      int.tryParse(c.text) ?? fallback;

  void saveChanges() {
    setState(() {
      save.name = _nameController.text;
      save.lastChapiter = _parseInt(_lastChapiterController, save.lastChapiter);
      save.habilite.setValeur(_parseInt(_habValeur, save.habilite.valeur));
      save.habilite.setModificateur(
        _parseInt(_habModif, save.habilite.modificateur),
      );
      save.force.setValeur(_parseInt(_forceValeur, save.force.valeur));
      save.force.setModificateur(
        _parseInt(_forceModif, save.force.modificateur),
      );
      save.vigueur.setValeur(_parseInt(_vigueurValeur, save.vigueur.valeur));
      save.vigueur.setModificateur(
        _parseInt(_vigueurModif, save.vigueur.modificateur),
      );
      save.discretion.setValeur(_parseInt(_discValeur, save.discretion.valeur));
      save.discretion.setModificateur(
        _parseInt(_discModif, save.discretion.modificateur),
      );
      save.pointsSupplementaires.setXp(
        _parseInt(_xpController, save.pointsSupplementaires.xp),
      );
      save.pointsSupplementaires.setPointsDestin(
        _parseInt(_destController, save.pointsSupplementaires.pointsDestin),
      );
      save.savoir.setValeur(_parseInt(_savoirValeur, save.savoir.valeur));
      save.savoir.setXp(_parseInt(_savoirXp, save.savoir.xp));
      save.equitation.setValeur(
        _parseInt(_equitValeur, save.equitation.valeur),
      );
      save.equitation.setXp(_parseInt(_equitXp, save.equitation.xp));
      save.tir.setValeur(_parseInt(_tirValeur, save.tir.valeur));
      save.tir.setXp(_parseInt(_tirXp, save.tir.xp));
      save.crochetage.setValeur(
        _parseInt(_crochValeur, save.crochetage.valeur),
      );
      save.crochetage.setXp(_parseInt(_crochXp, save.crochetage.xp));
      save.melee.setValeur(_parseInt(_meleeValeur, save.melee.valeur));
      save.melee.setXp(_parseInt(_meleeXp, save.melee.xp));
      save.manipulation.setValeur(
        _parseInt(_manipValeur, save.manipulation.valeur),
      );
      save.manipulation.setXp(_parseInt(_manipXp, save.manipulation.xp));
      save.consommables.souverains = _parseInt(
        _souverains,
        save.consommables.souverains,
      ).clamp(0, Consommables.maxSouverains);
      save.consommables.poignards = _parseInt(
        _poignards,
        save.consommables.poignards,
      ).clamp(0, Consommables.maxPoignards);
      save.consommables.carreaux = _parseInt(
        _carreaux,
        save.consommables.carreaux,
      ).clamp(0, Consommables.maxCarreaux);
    });
    widget.db.updateData();
    Navigator.pop(context);
  }

  void _ajouterEquipement() {
    final nomController = TextEditingController();
    final quantiteController = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un équipement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: quantiteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantité',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final nom = nomController.text.trim();
              final quantite = int.tryParse(quantiteController.text) ?? 1;
              if (nom.isNotEmpty) {
                setState(
                  () => save.besace.addEquipement(
                    Equipement(nom: nom, place: quantite),
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _ajouterObjet() {
    final nomController = TextEditingController();
    final descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un objet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final nom = nomController.text.trim();
              final description = descriptionController.text.trim();
              if (nom.isNotEmpty) {
                setState(() => save.poches.addObjet(nom, description));
              }
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _fieldRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget _capaciteSection(
    String label,
    TextEditingController valeur,
    TextEditingController modif,
  ) {
    return Row(
      children: [
        Expanded(child: _fieldRow('$label - Valeur', valeur)),
        const SizedBox(width: 8),
        Expanded(child: _fieldRow('$label - Modif.', modif)),
      ],
    );
  }

  Widget _talentSection(
    String label,
    TextEditingController valeur,
    TextEditingController xp,
  ) {
    return Row(
      children: [
        Expanded(child: _fieldRow('$label - Valeur', valeur)),
        const SizedBox(width: 8),
        Expanded(child: _fieldRow('$label - XP', xp)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la sauvegarde'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: saveChanges),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Général'),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _lastChapiterController,
              decoration: const InputDecoration(
                labelText: 'Last Chapiter',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            _sectionTitle('Points supplémentaires'),
            _fieldRow('XP (max ${PointsSupplementaires.xpMax})', _xpController),
            const SizedBox(height: 8),
            _fieldRow('Points de Destin', _destController),

            _sectionTitle('Capacités'),
            _capaciteSection('Habileté', _habValeur, _habModif),
            const SizedBox(height: 8),
            _capaciteSection('Force', _forceValeur, _forceModif),
            const SizedBox(height: 8),
            _capaciteSection('Vigueur', _vigueurValeur, _vigueurModif),
            const SizedBox(height: 8),
            _capaciteSection('Discrétion', _discValeur, _discModif),

            _sectionTitle('Talents'),
            _talentSection('Savoir', _savoirValeur, _savoirXp),
            const SizedBox(height: 8),
            _talentSection('Équitation', _equitValeur, _equitXp),
            const SizedBox(height: 8),
            _talentSection('Tir', _tirValeur, _tirXp),
            const SizedBox(height: 8),
            _talentSection('Crochetage', _crochValeur, _crochXp),
            const SizedBox(height: 8),
            _talentSection('Mêlée', _meleeValeur, _meleeXp),
            const SizedBox(height: 8),
            _talentSection('Manipulation', _manipValeur, _manipXp),

            _sectionTitle('Consommables'),
            _fieldRow(
              'Souverains (max ${Consommables.maxSouverains})',
              _souverains,
            ),
            const SizedBox(height: 8),
            _fieldRow(
              'Poignards (max ${Consommables.maxPoignards})',
              _poignards,
            ),
            const SizedBox(height: 8),
            _fieldRow('Carreaux (max ${Consommables.maxCarreaux})', _carreaux),

            _sectionTitle(
              'Besace (${save.besace.equipements.length}/${Besace.maxEmplacements})',
            ),
            ...save.besace.equipements.map((equipement) {
              final nom = equipement.nom;
              final quantite = equipement.place;
              return ListTile(
                title: Text('$nom x$quantite'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      setState(() => save.besace.removeEquipement(nom)),
                ),
              );
            }),
            TextButton.icon(
              onPressed: save.besace.equipements.length < Besace.maxEmplacements
                  ? _ajouterEquipement
                  : null,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un équipement'),
            ),

            _sectionTitle('Poches'),
            ...save.poches.objets.map((objet) {
              final nom = objet.keys.first;
              final description = objet.values.first;
              return ListTile(
                title: Text(nom),
                subtitle: Text(description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => save.poches.removeObjet(nom)),
                ),
              );
            }),
            TextButton.icon(
              onPressed: _ajouterObjet,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un objet'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
