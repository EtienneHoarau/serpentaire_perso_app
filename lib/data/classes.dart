class PointsSupplementaires {
  int xp;
  static const int xpMax = 20;
  int pointsDestin;

  PointsSupplementaires({this.xp = 0, this.pointsDestin = 0});

  void setXp(int newXp) => xp = newXp.clamp(0, xpMax);
  void addXp(int amount) => xp = (xp + amount).clamp(0, xpMax);
  void setPointsDestin(int newPointsDestin) => pointsDestin = newPointsDestin;
  void addPointsDestin(int amount) => pointsDestin += amount;
  int getXpMax()=>xpMax;

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
  void addValeur(int val)=>valeur = valeur +val;
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
  int getMaxXp(){return xpMax;}

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

enum NomCapacite { habilite, force, vigueur, discretion }
enum NomTalent { savoir, equitation, tir, crochetage, melee, manipulation }

class BonusStat<T extends Enum> {

  T nomStat;
  int valeur;

  BonusStat({
    required this.nomStat,
    required this.valeur,
  });

  Map<String, dynamic> toMap() => {
    'nomStat': nomStat.name,
    'valeur': valeur,
  };
}

class BonusCapacite extends BonusStat<NomCapacite> {
  BonusCapacite({required super.nomStat, required super.valeur});

  factory BonusCapacite.fromMap(Map<String, dynamic> map) => BonusCapacite(
        nomStat: NomCapacite.values.byName(map['nomStat']),
        valeur: map['valeur'] ?? 0,
      );
}

class BonusTalent extends BonusStat<NomTalent> {
  BonusTalent({required super.nomStat, required super.valeur});

  factory BonusTalent.fromMap(Map<String, dynamic> map) => BonusTalent(
        nomStat: NomTalent.values.byName(map['nomStat']),
        valeur: map['valeur'] ?? 0,
      );
}

class Equipement {
  String nom;
  int place;
  List<BonusCapacite> bonusCapacites;
  List<BonusTalent> bonusTalents;

  Equipement({
    required this.nom,
    required this.place,
    List<BonusCapacite>? bonusCapacites,
    List<BonusTalent>? bonusTalents,
  })  : bonusCapacites = bonusCapacites ?? [],
        bonusTalents = bonusTalents ?? [];

  Map<String, dynamic> toMap() => {
        'nom': nom,
        'place': place,
        'bonusCapacites': bonusCapacites.map((b) => b.toMap()).toList(),
        'bonusTalents': bonusTalents.map((b) => b.toMap()).toList(),
      };

  factory Equipement.fromMap(Map<String, dynamic> map) => Equipement(
        nom: map['nom'] ?? '',
        place: map['place'] ?? 1,
        bonusCapacites: (map['bonusCapacites'] as List? ?? [])
            .map((b) => BonusCapacite.fromMap(Map<String, dynamic>.from(b)))
            .toList(),
        bonusTalents: (map['bonusTalents'] as List? ?? [])
            .map((b) => BonusTalent.fromMap(Map<String, dynamic>.from(b)))
            .toList(),
      );
}

class Besace {
  static const int maxEmplacements = 10;
  List<Equipement> equipements;

  Besace({List<Equipement>? equipements}) : equipements = equipements ?? [];

  bool addEquipement(Equipement equipement) {
    if (getTotalQuantity() + equipement.place <= maxEmplacements) {
      equipements.add(equipement);
      return true;
    }
    return false;
  }

  int getTotalQuantity() => equipements.fold(0, (total, e) => total + e.place);

  void removeEquipement(String nom) =>
      equipements.removeWhere((e) => e.nom == nom);

  Map<String, dynamic> toMap() => {
        'equipements': equipements.map((e) => e.toMap()).toList(),
      };

  factory Besace.fromMap(Map<String, dynamic> map) {
    final raw = map['equipements'] as List? ?? [];
    return Besace(
      equipements: raw
          .map((e) => Equipement.fromMap(Map<String, dynamic>.from(e)))
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
        'objets': objets.map((o) => o.map((k, v) => MapEntry(k, v))).toList(),
      };

  factory Poches.fromMap(Map<String, dynamic> map) {
    final raw = map['objets'] as List? ?? [];
    return Poches(
      objets: raw.map((e) => Map<String, String>.from(e as Map)).toList(),
    );
  }
}


class PocheAHerbe {
  List<Map<String, int>> herbes;
  int capaciteMax;

  PocheAHerbe({
    List<Map<String, int>>? herbes,
    this.capaciteMax = 10,
  }) : herbes = herbes ?? [];

  bool addHerbe(String nom, int quantite) {
    if (getTotalQuantity() + quantite <= capaciteMax) {
      final existant = herbes.indexWhere((h) => h.containsKey(nom));
      if (existant != -1) {
        herbes[existant][nom] = (herbes[existant][nom] ?? 0) + quantite;
      } else {
        herbes.add({nom: quantite});
      }
      return true;
    }
    return false;
  }

  void removeHerbe(String nom) =>
      herbes.removeWhere((h) => h.containsKey(nom));

  void updateQuantite(String nom, int quantite) {
    final index = herbes.indexWhere((h) => h.containsKey(nom));
    if (index != -1) {
      if (quantite <= 0) {
        herbes.removeAt(index);
      } else {
        herbes[index][nom] = quantite;
      }
    }
  }

  int getTotalQuantity() => herbes.fold(0, (total, h) => total + h.values.first);

  int getQuantite(String nom) {
    final herbe = herbes.firstWhere((h) => h.containsKey(nom), orElse: () => {});
    return herbe[nom] ?? 0;
  }

  Map<String, dynamic> toMap() => {
        'herbes': herbes.map((h) => h.map((k, v) => MapEntry(k, v))).toList(),
        'capaciteMax': capaciteMax,
      };

  factory PocheAHerbe.fromMap(Map<String, dynamic> map) {
    final raw = map['herbes'] as List? ?? [];
    return PocheAHerbe(
      capaciteMax: map['capaciteMax'] ?? 10,
      herbes: raw.map((e) => Map<String, int>.from(e as Map)).toList(),
    );
  }
}

class Fioles {
  List<Map<String, int>> fioles;
  int capaciteMax;

  Fioles({
    List<Map<String, int>>? fioles,
    this.capaciteMax = 6,
  }) : fioles = fioles ?? [];

  bool addFiole(String nom, int quantite) {
    if (getTotalQuantity() + quantite <= capaciteMax) {
      final existant = fioles.indexWhere((f) => f.containsKey(nom));
      if (existant != -1) {
        fioles[existant][nom] = (fioles[existant][nom] ?? 0) + quantite;
      } else {
        fioles.add({nom: quantite});
      }
      return true;
    }
    return false;
  }

  void removeFiole(String nom) =>
      fioles.removeWhere((f) => f.containsKey(nom));

  void updateQuantite(String nom, int quantite) {
    final index = fioles.indexWhere((f) => f.containsKey(nom));
    if (index != -1) {
      if (quantite <= 0) {
        fioles.removeAt(index);
      } else {
        fioles[index][nom] = quantite;
      }
    }
  }

  int getTotalQuantity() => fioles.fold(0, (total, f) => total + f.values.first);

  int getQuantite(String nom) {
    final fiole = fioles.firstWhere((f) => f.containsKey(nom), orElse: () => {});
    return fiole[nom] ?? 0;
  }

  Map<String, dynamic> toMap() => {
        'fioles': fioles.map((f) => f.map((k, v) => MapEntry(k, v))).toList(),
        'capaciteMax': capaciteMax,
      };

  factory Fioles.fromMap(Map<String, dynamic> map) {
    final raw = map['fioles'] as List? ?? [];
    return Fioles(
      capaciteMax: map['capaciteMax'] ?? 6,
      fioles: raw.map((e) => Map<String, int>.from(e as Map)).toList(),
    );
  }
}