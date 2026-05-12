import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:serpentaire_perso_app/data/classes.dart';
import '../data/database.dart';
import 'dart:math';
import '../utils/objets_communs_tile.dart';
import '../utils/objets_speciaux_tile.dart';

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

  Future<int> lancerDe() async {
    int result = Random().nextInt(10) + 1;

    // 1. Premier Dialogue : Demander l'utilisation du point
    bool? utiliserDestin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choisi ton destin"),
        content: const Text("Veux-tu utiliser un point de Destin ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Oui"),
          ),
        ],
      ),
    );

    // 2. Si l'utilisateur a choisi "Oui"
    if (utiliserDestin == true) {
      setState(() {
        save.pointsSupplementaires.pointsDestin -= 1;
      });

      final TextEditingController controller = TextEditingController(
        text: "10",
      );

      if (mounted) {
        // On attend que l'utilisateur saisisse son résultat choisi
        await showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) {
              void updateValue(int delta) {
                setDialogState(() {
                  int current = int.tryParse(controller.text) ?? 1;
                  controller.text = (current + delta).clamp(1, 10).toString();
                });
              }

              return AlertDialog(
                title: const Text("Destin invoqué !"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Quel résultat souhaites-tu obtenir ?"),
                    const SizedBox(height: 15),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      autofocus: true,
                      decoration: const InputDecoration(suffixText: "/ 10"),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => updateValue(-1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => updateValue(1),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      // On récupère la valeur finale du controller avant de fermer
                      result = int.tryParse(controller.text) ?? 10;
                      Navigator.pop(context);
                    },
                    child: const Text("Valider"),
                  ),
                ],
              );
            },
          ),
        );
      }
    }

    return result;
  }

  Widget capaciteBox(
    String label,
    Capacite capacite, {
    bool printModificateur = false,
    bool printTotal = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (printTotal)
            Text("Total: ${capacite.getTotal()}")
          else if (printModificateur)
            Text("${capacite.modificateur}")
          else
            Text("${capacite.valeur}"),
        ],
      ),
    );
  }

  Widget talentBox(String label, Talent talent, {bool printXp = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (printXp)
            GestureDetector(
              onTap: () => _editerTalentXp(talent: talent),
              child: Text("${talent.xp}/${talent.getMaxXp()}"),
            )
          else
            Text("${talent.valeur}"),
        ],
      ),
    );
  }

  Widget infoBox(String label, String valeur) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(valeur),
        ],
      ),
    );
  }

  void _editerTalentXp({required Talent talent}) {
    final TextEditingController controller = TextEditingController(
      text: talent.xp.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final int maxXp = talent.getMaxXp();

            // Fonction locale pour mettre à jour le texte dans le dialogue
            void updateValue(int delta) {
              setDialogState(() {
                int currentValue = int.tryParse(controller.text) ?? 0;
                // On ne met pas de clamp max ici pour permettre de dépasser
                // et déclencher la logique de montée de niveau au moment du "Enregistrer"
                int newValue = (currentValue + delta).clamp(0, 999);
                controller.text = newValue.toString();
              });
            }

            return AlertDialog(
              title: Text('Modifier XP'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: controller,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      suffixText: '/ $maxXp',
                      helperText: "L'excédent sera converti en niveaux",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 32),
                        onPressed: () => updateValue(-1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 32),
                        onPressed: () => updateValue(1),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newValue = int.tryParse(controller.text) ?? 0;
                    final int maxXpConst = talent.getMaxXp();

                    setState(() {
                      if (newValue >= maxXpConst) {
                        // Logique de montée de niveau
                        talent.addValeur(newValue ~/ maxXpConst);
                        talent.setXp(newValue % maxXpConst);
                      } else {
                        talent.setXp(newValue);
                      }
                    });

                    Navigator.pop(context);

                    // Alerte si le talent a évolué
                    if (newValue >= maxXpConst) {
                      _showLevelUpDialog(talent);
                    }
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Petite fonction helper pour la clarté du code
  void _showLevelUpDialog(Talent talent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Talent amélioré !'),
        content: Text('Le talent a évolué grâce à l\'XP accumulée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Super !'),
          ),
        ],
      ),
    );
  }

  void levelUpCapacite(int pointsGagnes) {
    // On stocke le nom de la capacité sélectionnée
    NomCapacite selectedNom = NomCapacite.force;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Améliorer une capacité"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Points à distribuer : $pointsGagnes"),
                  const SizedBox(height: 15),
                  DropdownButton<NomCapacite>(
                    value: selectedNom,
                    isExpanded: true,
                    items: NomCapacite.values.map((nom) {
                      return DropdownMenuItem<NomCapacite>(
                        value: nom,
                        child: Text(nom.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (NomCapacite? newValue) {
                      if (newValue != null) {
                        // Met à jour l'UI interne du dialogue
                        setDialogState(() {
                          selectedNom = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // On récupère l'objet Capacite réel depuis la save
                      Capacite aChanger = save.getCapacite(selectedNom);
                      // On applique les points
                      aChanger.addValeur(pointsGagnes);
                    });
                    Navigator.pop(context);

                    // Petit feedback optionnel
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${selectedNom.name} a été amélioré !"),
                      ),
                    );
                  },
                  child: const Text("Confirmer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editerXpCapacite({required Save save}) {
    // On récupère le maximum actuel pour le calcul du palier
    final int maxXp = save.pointsSupplementaires.getXpMax();

    final TextEditingController controller = TextEditingController(
      text: save.pointsSupplementaires.xp.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void updateValue(int delta) {
              setDialogState(() {
                int currentValue = int.tryParse(controller.text) ?? 0;
                // On clamp à 0, mais on laisse monter au-delà du max pour
                // permettre la conversion en points au moment de l'enregistrement.
                int newValue = (currentValue + delta).clamp(0, 9999);
                controller.text = newValue.toString();
              });
            }

            return AlertDialog(
              title: const Text('Modifier l\'expérience'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: controller,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      suffixText: '/ $maxXp',
                      helperText: "L'excédent sera converti en points",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 32),
                        onPressed: () => updateValue(-1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 32),
                        onPressed: () => updateValue(1),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newValue = int.tryParse(controller.text) ?? 0;
                    final int currentMax = save.pointsSupplementaires
                        .getXpMax();
                    Navigator.pop(context);

                    setState(() {
                      if (newValue >= currentMax) {
                        // Logique identique à Talent : conversion du surplus
                        int pointsGagnes = newValue ~/ currentMax;
                        int xpRestante = newValue % currentMax;
                        _showCapaciteUpDialog();
                        levelUpCapacite(pointsGagnes);
                        save.pointsSupplementaires.xp = xpRestante;
                      } else {
                        save.pointsSupplementaires.xp = newValue;
                      }
                    });
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialogue de confirmation pour la capacité
  void _showCapaciteUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Palier atteint !'),
        content: const Text(
          'Votre expérience a été convertie en points de capacité.',
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

  void _editerPointsSupplementaires({required int points}) {
    final TextEditingController controller = TextEditingController(
      text: points.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void updateValue(int delta) {
              setDialogState(() {
                int currentValue = int.tryParse(controller.text) ?? 0;
                // On empêche de descendre en dessous de 0
                int newValue = (currentValue + delta).clamp(0, 99);
                controller.text = newValue.toString();
              });
            }

            return AlertDialog(
              title: const Text('Modifier les points de destin'),
              content: Column(
                mainAxisSize: MainAxisSize.min, // Ajuste la taille au contenu
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: controller,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Nombre de points',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 32),
                        onPressed: () => updateValue(-1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 32),
                        onPressed: () => updateValue(1),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newValue = int.tryParse(controller.text) ?? 0;
                    setState(() {
                      save.pointsSupplementaires.pointsDestin = newValue;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void editConsommable(String type, {required int val}) {
    final TextEditingController controller = TextEditingController(
      text: val.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        // Le StatefulBuilder permet de mettre à jour le contenu du dialogue
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Déterminer le maximum selon le type
            int maxVal = (type == 'Souverains')
                ? Consommables.maxSouverains
                : (type == 'Poignards')
                ? Consommables.maxPoignards
                : Consommables.maxCarreaux;

            void updateValue(int delta) {
              setDialogState(() {
                int currentValue = int.tryParse(controller.text) ?? 0;
                int newValue = (currentValue + delta).clamp(0, maxVal);
                controller.text = newValue.toString();
              });
            }

            return AlertDialog(
              title: Text('Modifier $type'),
              content: Column(
                mainAxisSize: MainAxisSize
                    .min, // Important pour éviter que le dialogue soit géant
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: controller,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(suffixText: '/ $maxVal'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => updateValue(-1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => updateValue(1),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newValue = int.tryParse(controller.text) ?? 0;
                    setState(() {
                      // setState du widget principal pour refléter les changements
                      final clampedValue = newValue.clamp(0, maxVal);
                      if (type == 'Souverains') {
                        save.consommables.souverains = clampedValue;
                      }
                      if (type == 'Poignards') {
                        save.consommables.poignards = clampedValue;
                      }
                      if (type == 'Carreaux') {
                        save.consommables.carreaux = clampedValue;
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget consommablesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Consommables",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => editConsommable(
                'Souverains',
                val: save.consommables.souverains,
              ),
              child: Column(
                children: [
                  const Text(
                    "Souverains",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${save.consommables.souverains}/${Consommables.maxSouverains}",
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => editConsommable(
                'Poignards',
                val: save.consommables.poignards,
              ),
              child: Column(
                children: [
                  const Text(
                    "Poignards",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${save.consommables.poignards}/${Consommables.maxPoignards}",
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () =>
                  editConsommable('Carreaux', val: save.consommables.carreaux),
              child: Column(
                children: [
                  const Text(
                    "Carreaux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${save.consommables.carreaux}/${Consommables.maxCarreaux}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void appliquerBonusEquipement(Save save, Equipement equipement) {
    for (final bonus in equipement.bonusCapacites) {
      save.getCapacite(bonus.nomStat).addModificateur(bonus.valeur);
    }

    for (final bonus in equipement.bonusTalents) {
      save.getTalent(bonus.nomStat).addValeur(bonus.valeur);
    }
  }

  void retirerBonusEquipement(Save save, Equipement equipement) {
    for (final bonus in equipement.bonusCapacites) {
      save.getCapacite(bonus.nomStat).addModificateur(-bonus.valeur);
    }

    for (final bonus in equipement.bonusTalents) {
      save.getTalent(bonus.nomStat).addValeur(-bonus.valeur);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          children: [
            FloatingActionButton.small(
              heroTag: 'de',
              onPressed: () async {
                // Ajout de async ici
                // On attend que l'utilisateur finisse ses choix dans lancerDe()
                final resultat = await lancerDe();

                // Une fois le résultat obtenu, on affiche le dialogue final
                if (!mounted) return; // Sécurité contextuelle

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Lancer de dé'),
                    content: Text('Résultat : $resultat / 10'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.casino),
            ),
            FloatingActionButton.small(
              heroTag: 'combat',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Combat'),
                    content: const Text(
                      'Le menu de combat sera développé plus tard.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.sports_martial_arts),
            ),
          ],
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 200,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/home'),
                    child: const Icon(Icons.home),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Save: ${widget.id}"),
                      if (save.lastChapiter > 0)
                        Text("Last Chapiter : ${save.lastChapiter}"),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/edit_save',
                      arguments: widget.id,
                    ),
                    child: const Icon(Icons.edit),
                  ),
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
                    capaciteBox("Habileté", save.habilite, printTotal: true),
                    const SizedBox(width: 8),
                    capaciteBox("Force", save.force, printTotal: true),
                    const SizedBox(width: 8),
                    capaciteBox("Vigueur", save.vigueur, printTotal: true),
                    const SizedBox(width: 8),
                    capaciteBox(
                      "Discrétion",
                      save.discretion,
                      printTotal: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Capacités"),
              Tab(text: "Talents"),
              Tab(text: "Besace"),
              Tab(text: "Poches"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Capacités
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Capacités",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "Capacité",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "Modif.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          capaciteBox("Habileté", save.habilite),
                          capaciteBox(
                            "",
                            save.habilite,
                            printModificateur: true,
                          ),
                          capaciteBox("", save.habilite, printTotal: true),
                        ],
                      ),
                      TableRow(
                        children: [
                          capaciteBox("Force", save.force),
                          capaciteBox("", save.force, printModificateur: true),
                          capaciteBox("", save.force, printTotal: true),
                        ],
                      ),
                      TableRow(
                        children: [
                          capaciteBox("Vigueur", save.vigueur),
                          capaciteBox(
                            "",
                            save.vigueur,
                            printModificateur: true,
                          ),
                          capaciteBox("", save.vigueur, printTotal: true),
                        ],
                      ),
                      TableRow(
                        children: [
                          capaciteBox("Discrétion", save.discretion),
                          capaciteBox(
                            "",
                            save.discretion,
                            printModificateur: true,
                          ),
                          capaciteBox("", save.discretion, printTotal: true),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _editerXpCapacite(save: save),
                        child: infoBox(
                          "XP capacités",
                          "${save.pointsSupplementaires.xp}/${PointsSupplementaires.xpMax}",
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _editerPointsSupplementaires(
                          points: save.pointsSupplementaires.pointsDestin,
                        ),
                        child: infoBox(
                          "Points de Destin",
                          "${save.pointsSupplementaires.pointsDestin}",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Talents
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Talents",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: Colors.grey),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      const TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "Talent",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              "XP",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          talentBox("Savoir", save.savoir),
                          talentBox("", save.savoir, printXp: true),
                        ],
                      ),
                      TableRow(
                        children: [
                          talentBox("Équitation", save.equitation),
                          talentBox("", save.equitation, printXp: true),
                        ],
                      ),
                      TableRow(
                        children: [
                          talentBox("Tir", save.tir),
                          talentBox("", save.tir, printXp: true),
                        ],
                      ),
                      TableRow(
                        children: [
                          talentBox("Crochetage", save.crochetage),
                          talentBox("", save.crochetage, printXp: true),
                        ],
                      ),
                      TableRow(
                        children: [
                          talentBox("Mêlée", save.melee),
                          talentBox("", save.melee, printXp: true),
                        ],
                      ),
                      TableRow(
                        children: [
                          talentBox("Manipulation", save.manipulation),
                          talentBox("", save.manipulation, printXp: true),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Besace
            // Besace
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  consommablesWidget(),
                  const SizedBox(height: 16),
                  const Text(
                    "Besace",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  save.besace.equipements.isEmpty
                      ? const Text("Aucun équipement")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: save.besace.equipements.length,
                          itemBuilder: (context, index) {
                            return ObjetsCommunsTile(
                              context: context,
                              equipement: save.besace.equipements[index],
                              onTap: () {},
                              deleteFunction: (context) {
                                setState(() {
                                  retirerBonusEquipement(
                                    save,
                                    save.besace.equipements[index],
                                  );

                                  save.besace.equipements.removeAt(index);
                                  widget.db.updateData();
                                });
                              },
                            );
                          },
                        ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed:
                        save.besace.getTotalQuantity() < Besace.maxEmplacements
                        ? () {
                            Navigator.pushNamed(
                              context,
                              '/new_equipement',
                              arguments: save,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.add),
                    label: Text(
                      save.besace.equipements.length < Besace.maxEmplacements
                          ? 'Ajouter un équipement (${save.besace.getTotalQuantity()}/${Besace.maxEmplacements})'
                          : 'Besace pleine (${Besace.maxEmplacements}/${Besace.maxEmplacements})',
                    ),
                  ),
                ],
              ),
            ),

            // Poches
            // Poches
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  consommablesWidget(),
                  const SizedBox(height: 16),
                  const Text(
                    "Poches",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  save.poches.objets.isEmpty
                      ? const Text("Aucun objet")
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: save.poches.objets.length,
                          itemBuilder: (context, index) {
                            return ObjetsSpeciauxTile(
                              name: save.poches.objets[index].keys.first,
                              onTap: () {},
                              deleteFunction: (context) {
                                setState(() {
                                  save.poches.objets.removeAt(index);
                                  widget.db.updateData();
                                });
                              },
                            );
                          },
                        ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {
                      final nomController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Ajouter un objet'),
                          content: TextField(
                            controller: nomController,
                            decoration: const InputDecoration(
                              labelText: 'Nom',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () {
                                final nom = nomController.text.trim();
                                if (nom.isNotEmpty) {
                                  setState(
                                    () => save.poches.objets.add({nom: ''}),
                                  );
                                  widget.db.updateData();
                                }
                                Navigator.pop(context);
                              },
                              child: const Text('Ajouter'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un objet'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
