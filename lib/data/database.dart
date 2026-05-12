import 'package:hive_ce/hive.dart';
import './classes.dart';

class Save {
  int id;
  static int idCounter = 0;
  String name;
  bool isFavorite;
  int lastChapiter;

  PointsSupplementaires pointsSupplementaires;
  Capacite habilite;
  Capacite force;
  Capacite vigueur;
  Capacite discretion;

  Talent savoir;
  Talent equitation;
  Talent tir;
  Talent crochetage;
  Talent melee;
  Talent manipulation;

  Consommables consommables;
  Besace besace;
  Poches poches;

  Save()
    : id = idCounter++,
      name = 'Save ${idCounter - 1}',
      lastChapiter =0,
      isFavorite = false,
      pointsSupplementaires = PointsSupplementaires(pointsDestin: 2),
      habilite = Capacite(),
      force = Capacite(),
      vigueur = Capacite(valeur: 15),
      discretion = Capacite(),
      savoir = Talent(),
      equitation = Talent(),
      tir = Talent(),
      crochetage = Talent(),
      melee = Talent(),
      manipulation = Talent(),
      consommables = Consommables(),
      besace = Besace(),
      poches = Poches();

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'isFavorite': isFavorite,
    'lastChapiter':lastChapiter,
    'pointsSupplementaires': pointsSupplementaires.toMap(),
    'habilite': habilite.toMap(),
    'force': force.toMap(),
    'vigueur': vigueur.toMap(),
    'discretion': discretion.toMap(),
    'savoir': savoir.toMap(),
    'equitation': equitation.toMap(),
    'tir': tir.toMap(),
    'crochetage': crochetage.toMap(),
    'melee': melee.toMap(),
    'manipulation': manipulation.toMap(),
    'consommables': consommables.toMap(),
    'besace': besace.toMap(),
    'poches': poches.toMap(),
  };

  factory Save.fromMap(Map<String, dynamic> map) {
    final s = Save();
    s.id = map['id'] ?? s.id;
    s.name = map['name'] ?? s.name;
    s.isFavorite = map['isFavorite'] ?? false;
    s.lastChapiter = map['lastChapiter'] ?? 0;
    s.pointsSupplementaires = PointsSupplementaires.fromMap(
      Map<String, dynamic>.from(map['pointsSupplementaires'] ?? {}),
    );
    s.habilite = Capacite.fromMap(
      Map<String, dynamic>.from(map['habilite'] ?? {}),
    );
    s.force = Capacite.fromMap(Map<String, dynamic>.from(map['force'] ?? {}));
    s.vigueur = Capacite.fromMap(
      Map<String, dynamic>.from(map['vigueur'] ?? {}),
    );
    s.discretion = Capacite.fromMap(
      Map<String, dynamic>.from(map['discretion'] ?? {}),
    );
    s.savoir = Talent.fromMap(Map<String, dynamic>.from(map['savoir'] ?? {}));
    s.equitation = Talent.fromMap(
      Map<String, dynamic>.from(map['equitation'] ?? {}),
    );
    s.tir = Talent.fromMap(Map<String, dynamic>.from(map['tir'] ?? {}));
    s.crochetage = Talent.fromMap(
      Map<String, dynamic>.from(map['crochetage'] ?? {}),
    );
    s.melee = Talent.fromMap(Map<String, dynamic>.from(map['melee'] ?? {}));
    s.manipulation = Talent.fromMap(
      Map<String, dynamic>.from(map['manipulation'] ?? {}),
    );
    s.consommables = Consommables.fromMap(
      Map<String, dynamic>.from(map['consommables'] ?? {}),
    );
    s.besace = Besace.fromMap(Map<String, dynamic>.from(map['besace'] ?? {}));
    s.poches = Poches.fromMap(Map<String, dynamic>.from(map['poches'] ?? {}));
    return s;
  }

  Capacite getCapacite(NomCapacite nom) {
    switch (nom) {
      case NomCapacite.habilite:
        return habilite;
      case NomCapacite.force:
        return force;
      case NomCapacite.vigueur:
        return vigueur;
      case NomCapacite.discretion:
        return discretion;
    }
  }

  Talent getTalent(NomTalent nom) {
    switch (nom) {
      case NomTalent.savoir:
        return savoir;
      case NomTalent.equitation:
        return equitation;
      case NomTalent.tir:
        return tir;
      case NomTalent.crochetage:
        return crochetage;
      case NomTalent.melee:
        return melee;
      case NomTalent.manipulation:
        return manipulation;
    }
  }
}

class SavesDatabase {
  List<Save> mySaves = [];
  final _mybox = Hive.box('mybox');

  void createInitialData() {
    mySaves = [];
  }

  void loadData() {
  final raw = _mybox.get('MY_DATA');
  if (raw == null) {
    mySaves = [];
    return;
  }
  mySaves = (raw as List)
      .map((e) => Save.fromMap(Map<String, dynamic>.from(e as Map)))
      .toList();

  // On recalibre le compteur pour éviter les doublons après redémarrage
  if (mySaves.isNotEmpty) {
    // On cherche l'ID le plus grand et on ajoute 1
    Save.idCounter = mySaves.map((s) => s.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}

  void setFavorite(Save targetSave) {
    for (var s in mySaves) {
      if (s.id == targetSave.id) {
        // On inverse l'état actuel (permet de décocher)
        s.isFavorite = !s.isFavorite;
      } else {
        // Toutes les autres repassent à false
        s.isFavorite = false;
      }
    }
    updateData(); // Sauvegarde immédiate dans Hive
  }

  /// Récupère la save favorite s'il y en a une
  Save? get favoriteSave {
    try {
      return mySaves.firstWhere((s) => s.isFavorite);
    } catch (e) {
      return null;
    }
  }

  void updateData() {
    _mybox.put('MY_DATA', mySaves.map((s) => s.toMap()).toList());
  }
}
