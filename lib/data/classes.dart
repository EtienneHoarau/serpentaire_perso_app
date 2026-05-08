class PointsSupplementaires {
  int xp;
  static const int xpMax = 20;
  int pointsDestin;

  PointsSupplementaires({this.xp = 0, this.pointsDestin = 0});

  void setXp(int newXp) => xp = newXp.clamp(0, xpMax);
  void addXp(int amount) => xp = (xp + amount).clamp(0, xpMax);
  void setPointsDestin(int newPointsDestin) => pointsDestin = newPointsDestin;
  void addPointsDestin(int amount) => pointsDestin += amount;

  Map<String, dynamic> toMap() => {'xp': xp, 'pointsDestin': pointsDestin};

  factory PointsSupplementaires.fromMap(Map<String, dynamic> map) =>
      PointsSupplementaires(xp: map['xp'] ?? 0, pointsDestin: map['pointsDestin'] ?? 0);

  @override
  String toString() => 'PointsSupplementaires(xp: $xp, pointsDestin: $pointsDestin)';
}

class Capacite {
  int valeur;
  int modificateur;

  Capacite({this.valeur = 0, this.modificateur = 0});

  void setValeur(int newValeur) => valeur = newValeur;
  void setModificateur(int newModificateur) => modificateur = newModificateur;
  void addModificateur(int amount) => modificateur += amount;
  int getTotal() => valeur + modificateur;

  Map<String, dynamic> toMap() => {'valeur': valeur, 'modificateur': modificateur};

  factory Capacite.fromMap(Map<String, dynamic> map) =>
      Capacite(valeur: map['valeur'] ?? 0, modificateur: map['modificateur'] ?? 0);
}

class Talent {
  int valeur;
  int xp;
  static const int xpMax = 10;

  Talent({this.valeur = 0, this.xp = 0});

  void setValeur(int newValeur) => valeur = newValeur;
  void setXp(int newXp) => xp = newXp.clamp(0, xpMax);
  void addXp(int amount) => xp = (xp + amount).clamp(0, xpMax);
  void addValeur(int amount) => valeur += amount;

  Map<String, dynamic> toMap() => {'valeur': valeur, 'xp': xp};

  factory Talent.fromMap(Map<String, dynamic> map) =>
      Talent(valeur: map['valeur'] ?? 0, xp: map['xp'] ?? 0);
}

class Consommables {
  int souverains;
  int poignards;
  int carreaux;
  static const int maxSouverains = 100;
  static const int maxPoignards = 6;
  static const int maxCarreaux = 12;

  Consommables({this.souverains = 0, this.poignards = 0, this.carreaux = 0});

  void addSouverains(int amount) => souverains = (souverains + amount).clamp(0, maxSouverains);
  void addPoignards(int amount) => poignards = (poignards + amount).clamp(0, maxPoignards);
  void addCarreaux(int amount) => carreaux = (carreaux + amount).clamp(0, maxCarreaux);

  Map<String, dynamic> toMap() => {
        'souverains': souverains,
        'poignards': poignards,
        'carreaux': carreaux,
      };

  factory Consommables.fromMap(Map<String, dynamic> map) => Consommables(
        souverains: map['souverains'] ?? 0,
        poignards: map['poignards'] ?? 0,
        carreaux: map['carreaux'] ?? 0,
      );
}

class Besace {
  static const int maxEmplacements = 10;
  List<Map<String, int>> equipements;

  Besace({List<Map<String, int>>? equipements}) : equipements = equipements ?? [];

  bool addEquipement(String nom, int quantite) {
    if (equipements.length < maxEmplacements) {
      equipements.add({nom: quantite});
      return true;
    }
    print('Besace pleine !');
    return false;
  }

  void removeEquipement(String nom) =>
      equipements.removeWhere((e) => e.containsKey(nom));

  Map<String, dynamic> toMap() => {
        'equipements': equipements
            .map((e) => e.map((k, v) => MapEntry(k, v)))
            .toList(),
      };

  factory Besace.fromMap(Map<String, dynamic> map) {
    final raw = map['equipements'] as List? ?? [];
    return Besace(
      equipements: raw
          .map((e) => Map<String, int>.from(e as Map))
          .toList(),
    );
  }
}

class Poches {
  List<Map<String, String>> objets;

  Poches({List<Map<String, String>>? objets}) : objets = objets ?? [];

  void addObjet(String nom, String description) => objets.add({nom: description});
  void removeObjet(String nom) => objets.removeWhere((o) => o.containsKey(nom));

  Map<String, dynamic> toMap() => {
        'objets': objets
            .map((o) => o.map((k, v) => MapEntry(k, v)))
            .toList(),
      };

  factory Poches.fromMap(Map<String, dynamic> map) {
    final raw = map['objets'] as List? ?? [];
    return Poches(
      objets: raw
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
    );
  }
}