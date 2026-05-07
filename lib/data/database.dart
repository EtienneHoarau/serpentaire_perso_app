import 'package:hive_ce/hive.dart';
import './classes.dart';


class Save{
  //basic info
  late int id;
  late String name;

  // capacities et points bonus
  late PointsSupplementaires pointsSupplementaires;
  late Capacite habilite;
  late Capacite force;
  late Capacite vigueur;
  late Capacite discretion;

  // Talents 
  late Talent savoir;
  late Talent equitation;
  late Talent tir;
  late Talent crochetage;
  late Talent melee;
  late Talent manipulation;

  // Equipements
  late Consommables consommables;
  late Besace besace;
  late Poches poches;

}


class SavesDatabase{

  List mySaves = [];

  final _mybox = Hive.box('mybox');

  void createInitialData(){
    mySaves = [];
  }

  void loadData(){
    mySaves = _mybox.get('MY_DATA');
  }

  void updateData(){
    _mybox.put('MY_DATA', mySaves);
  }

}