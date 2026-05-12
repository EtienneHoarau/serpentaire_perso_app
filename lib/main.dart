import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:serpentaire_perso_app/pages/home_page.dart';
import 'package:serpentaire_perso_app/pages/new_save_page.dart';
import 'package:serpentaire_perso_app/data/database.dart';
import 'package:serpentaire_perso_app/pages/save_page.dart';
import 'package:serpentaire_perso_app/pages/edit_save_page.dart';
import 'package:serpentaire_perso_app/pages/new_equipement_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox');
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _myBox = Hive.box('mybox');
  SavesDatabase db = SavesDatabase();
  
  // On va stocker l'ID de la save favorite pour le build
  int? favoriteId;
  bool isAnySave = false;

  @override
  void initState() {
    super.initState();
    
    // 1. Charger les données
    if (_myBox.get('MY_DATA') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    // 2. Analyser l'état des sauvegardes
    isAnySave = db.mySaves.isNotEmpty;
    // 3. Chercher s'il y a un favori
    if (isAnySave) {
      try {
        // On récupère la première save qui est favorite
        final fav = db.mySaves.firstWhere((s) => s.isFavorite);
        favoriteId = fav.id;
      } catch (e) {
        // Aucune save favorite n'a été trouvée, favoriteId reste null
        favoriteId = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // LOGIQUE DE LANCEMENT :
      // 1. Si un favori existe -> Go directement sur SavePage
      // 2. Sinon, si des saves existent -> Go sur HomePage
      // 3. Sinon -> Go sur NewSavePage
      home: favoriteId != null 
          ? SavePage(id: favoriteId!, db: db) 
          : (isAnySave ? HomePage(db: db) : NewSavePage(db: db)),
      
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/home': (context) => HomePage(db: db),
        '/new_save': (context) => NewSavePage(db: db),
        '/save': (context) => SavePage(
              id: ModalRoute.of(context)!.settings.arguments as int, 
              db: db
            ),
        '/edit_save': (context) => EditSavePage(
              id: ModalRoute.of(context)!.settings.arguments as int, 
              db: db
            ),
        '/new_equipement': (context) => NewEquipementPage(
              save: ModalRoute.of(context)!.settings.arguments as Save, 
              db: db
            ),
      },
    );
  }
}