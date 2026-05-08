import 'package:hive_ce/hive.dart';
import './classes.dart';

class Save {
  int id;
  static int idCounter = 0;
  String name;

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
    s.pointsSupplementaires = PointsSupplementaires.fromMap(
        Map<String, dynamic>.from(map['pointsSupplementaires'] ?? {}));
    s.habilite = Capacite.fromMap(Map<String, dynamic>.from(map['habilite'] ?? {}));
    s.force = Capacite.fromMap(Map<String, dynamic>.from(map['force'] ?? {}));
    s.vigueur = Capacite.fromMap(Map<String, dynamic>.from(map['vigueur'] ?? {}));
    s.discretion = Capacite.fromMap(Map<String, dynamic>.from(map['discretion'] ?? {}));
    s.savoir = Talent.fromMap(Map<String, dynamic>.from(map['savoir'] ?? {}));
    s.equitation = Talent.fromMap(Map<String, dynamic>.from(map['equitation'] ?? {}));
    s.tir = Talent.fromMap(Map<String, dynamic>.from(map['tir'] ?? {}));
    s.crochetage = Talent.fromMap(Map<String, dynamic>.from(map['crochetage'] ?? {}));
    s.melee = Talent.fromMap(Map<String, dynamic>.from(map['melee'] ?? {}));
    s.manipulation = Talent.fromMap(Map<String, dynamic>.from(map['manipulation'] ?? {}));
    s.consommables = Consommables.fromMap(Map<String, dynamic>.from(map['consommables'] ?? {}));
    s.besace = Besace.fromMap(Map<String, dynamic>.from(map['besace'] ?? {}));
    s.poches = Poches.fromMap(Map<String, dynamic>.from(map['poches'] ?? {}));
    return s;
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
  }

  void updateData() {
    _mybox.put('MY_DATA', mySaves.map((s) => s.toMap()).toList());
  }
}