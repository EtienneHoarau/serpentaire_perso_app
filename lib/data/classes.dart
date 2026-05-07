class PointsSupplementaires {
  int xp;
  static const int xpMax = 20;
  int pointsDestin;

  PointsSupplementaires({this.xp = 0, this.pointsDestin = 0});

  void setXp(int newXp) {
    xp = newXp.clamp(0, xpMax);
  }

  void addXp(int amount) {
    xp = (xp + amount).clamp(0, xpMax);
  }

  void setPointsDestin(int newPointsDestin) {
    pointsDestin = newPointsDestin;
  }

  void addPointsDestin(int amount) {
    pointsDestin += amount;
  }

  @override
  String toString() =>
      'PointsSupplementaires(xp: $xp, pointsDestin: $pointsDestin)';
}
/*
class PointsInitiaux {
  int habilite;
  int force;
  int vigueur;
  int discretion;

  PointsInitiaux({
    this.habilite = 0,
    this.force = 0,
    this.vigueur = 0,
    this.discretion = 0,
  });

  void setHabilite(int newHabilite) {
    habilite = newHabilite;
  }

  void setForce(int newForce) {
    force = newForce;
  }

  void setVigueur(int newVigueur) {
    vigueur = newVigueur;
  }

  void setDiscretion(int newDiscretion) {
    discretion = newDiscretion;
  }

}

class Modificateurs{
  int habilite;
  int force;
  int vigueur;
  int discretion;

  Modificateurs({
    this.habilite = 0,
    this.force = 0,
    this.vigueur = 0,
    this.discretion = 0,
  });

  void addHabilite(int amount) {
    habilite += amount;
  }
  void addForce(int amount) {
    force += amount;
  }
  void addVigueur(int amount) {
    vigueur += amount;
  }
  void addDiscretion(int amount) {
    discretion += amount;
  }
}

*/

class Capacite {
  int valeur;
  int modificateur;
  Capacite({this.valeur = 0, this.modificateur = 0});

  void setValeur(int newValeur) {
    valeur = newValeur;
  }

  void setModificateur(int newModificateur) {
    modificateur = newModificateur;
  }

  void addModificateur(int amount) {
    modificateur += amount;
  }

  int getTotal() {
    return valeur + modificateur;
  }
}

class Talent {
  int valeur;
  int xp;
  static const int xpMax = 10;

  Talent({this.valeur = 0, this.xp = 0});
  void setValeur(int newValeur) {
    valeur = newValeur;
  }

  void setXp(int newXp) {
    xp = newXp.clamp(0, xpMax);
  }

  void addXp(int amount) {
    xp = (xp + amount).clamp(0, xpMax);
  }

  void addValeur(int amount) {
    valeur += amount;
  }
}

class Consommables {
  int souverains;
  int poignards;
  int carreaux;
  static const int maxSouverains = 100;
  static const int maxPoignards = 6;
  static const int maxCarreaux = 12;
  Consommables({this.souverains = 0, this.poignards = 0, this.carreaux = 0});

  void addSouverains(int amount) {
    souverains = (souverains + amount).clamp(0, maxSouverains);
  }

  void addPoignards(int amount) {
    poignards = (poignards + amount).clamp(0, maxPoignards);
  }

  void addCarreaux(int amount) {
    carreaux = (carreaux + amount).clamp(0, maxCarreaux);
  }
}

class Besace {
  static const int maxEmplacements = 10;
  List<Map<String, int>> equipements = [];

  bool addEquipement(String nom, int quantite) {
    if (equipements.length < maxEmplacements) {
      equipements.add({nom: quantite});
      return true;
    } else {
      print('Besace pleine !');
      return false;
    }
  }

  void removeEquipement(String nom) {
    equipements.removeWhere((equipement) => equipement.containsKey(nom));
  }
}

class Poches {
  List<Map<String, String>> objets = [];
  
  void addObjet(String nom, String description) {
    objets.add({nom: description});
  }

  void removeObjet(String nom) {
    objets.removeWhere((objet) => objet.containsKey(nom));
  }

}