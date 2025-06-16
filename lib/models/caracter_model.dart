import 'package:cloud_firestore/cloud_firestore.dart';

class AppCharacter {
  final int id;
  final String name;
  final String type;
  final int pv; // Points de vie
  final int cost; // Coût de l'agent
  final bool isProtector;
  final String description;
  final String? photoUrl;
  final List<Map<String, dynamic>>?
  attackData; // Données d'attaque (ex: dégâts, portée)

  AppCharacter({
    required this.id,
    required this.name,
    required this.type,
    required this.pv,
    required this.cost,
    required this.description,
    required this.isProtector,
    this.photoUrl,
    this.attackData,
  });

  // Convertir l'objet AppCharacter en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'pv': pv,
      'cost': cost,
      'description': description,
      'isProtector': isProtector,
      'photoUrl': photoUrl,
      'attackData': attackData, // Stockez la liste de Maps directement
    };
  }

  // Créer un objet AppCharacter à partir d'une Map (données de Firestore)
  factory AppCharacter.fromMap(Map<String, dynamic> map) {
    // S'assurer que attackData est bien une List<Map<String, dynamic>>
    List<Map<String, dynamic>>? parsedAttackData;
    if (map['attackData'] is List) {
      parsedAttackData =
          (map['attackData'] as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
    }

    return AppCharacter(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      pv: map['pv'] as int,
      cost: map['cost'] as int,
      description: map['description'] as String,
      isProtector: map['isProtector'] as bool,
      photoUrl: map['photoUrl'] as String?,
      attackData: parsedAttackData,
    );
  }
}

class ProgressAppCharacter extends AppCharacter {
  final int progressLimit = 4;
  int _progress = 0;
  AppCharacter appCharacter;
  ProgressAppCharacter(this.appCharacter, int progress)
    : super(
        id: appCharacter.id,
        name: appCharacter.name,
        type: appCharacter.type,
        pv: appCharacter.pv,
        cost: appCharacter.cost,
        description: appCharacter.description,
        isProtector: appCharacter.isProtector,
        photoUrl: appCharacter.photoUrl,
        attackData: appCharacter.attackData,
      ) {
    _progress = (isProtector) ? progressLimit : progress;
  }

  bool progress() {
    if (_progress == progressLimit) return false;
    _progress++;
    return true;
  }

  int getProgress() {
    return _progress;
  }

  @override
  Map<String, dynamic> toMap() {
    return {'character': super.toMap(), 'progress': _progress};
  }

  factory ProgressAppCharacter.fromMap(Map<String, dynamic> map) {
    final appCharacter = AppCharacter.fromMap(map['character'] ?? map);
    final progress = map['progress'] ?? 0;
    return ProgressAppCharacter(appCharacter, progress);
  }
}

//--
//--
//--
//--
// code d'initialisation des characters
//a appeler une seul fois dans le main apres initialisation de firebase
class FirestoreInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fonction pour initialiser les données des protecteurs et pathogènes
  Future<void> initializeCharacters() async {
    print('Initialisation des données des agents...');

    final List<AppCharacter> protectors = [
      AppCharacter(
        id: 0,
        name: 'Giga Phagocyte',
        type: 'Tank de Mêlée',
        pv: 150,
        cost: 70,
        description:
            'Une unité de choc massive, capable d\'engloutir et de digérer de grandes menaces.',
        isProtector: true,
        photoUrl: 'assets/images/phagocyte_giga.png',
        attackData: [
          {'name': 'Assimilation Massive', 'damage': 30, 'range': 1},
          {
            'name': 'Barrière Cellulaire',
            'effect': 'Shield',
            'amount': 20,
            'duration': 2,
          },
        ],
      ),
      AppCharacter(
        id: 1,
        name: 'Éclair Neutrophile',
        type: 'Assaut Rapide',
        pv: 90,
        cost: 55,
        description:
            'Rapide et agressif, il traque et élimine les envahisseurs isolés avec une précision chirurgicale.',
        isProtector: true,
        photoUrl: 'assets/images/neutrophile_eclair.png',
        attackData: [
          {'name': 'Charge Foudroyante', 'damage': 25, 'range': 1},
          {'name': 'Salve d\'Enzyme', 'damage': 10, 'range': 2},
        ],
      ),
      AppCharacter(
        id: 2,
        name: 'Lymphocyte Arcanique',
        type: 'Contrôle à Distance',
        pv: 80,
        cost: 65,
        description:
            'Maître des arts arcaniques immunitaires, il affaiblit les ennemis et protège les alliés de loin.',
        isProtector: true,
        photoUrl: 'assets/images/lymphocyte_arcane.png',
        attackData: [
          {
            'name': 'Malédiction Virale',
            'damage': 15,
            'range': 4,
            'effect': 'Vulnérabilité',
          },
          {
            'name': 'Soins Cellulaires',
            'effect': 'PV+',
            'amount': 15,
            'range': 3,
          },
        ],
      ),
      AppCharacter(
        id: 3,
        name: 'Spectre NK',
        type: 'Infiltrateur',
        pv: 75,
        cost: 60,
        description:
            'Invisible aux scanners pathogènes, elle élimine silencieusement les cellules infectées.',
        isProtector: true,
        photoUrl: 'assets/images/cellule_nk_spectre.png',
        attackData: [
          {
            'name': 'Exécution Silencieuse',
            'damage': 40,
            'range': 1,
            'effect': 'Ignorer Armure',
          },
        ],
      ),
      AppCharacter(
        id: 4,
        name: 'Anticorps Stellaire',
        type: 'Support Stratégique',
        pv: 70,
        cost: 45,
        description:
            'Une entité d\'anticorps lumineuse qui marque les cibles pour des attaques massives et booste la défense.',
        isProtector: true,
        photoUrl: 'assets/images/anticorps_stellaire.png',
        attackData: [
          {
            'name': 'Marque Étoile',
            'damage': 5,
            'range': 5,
            'effect': 'Cible Faible',
          },
          {
            'name': 'Aura de Protection',
            'effect': 'DEF+',
            'amount': 10,
            'range': 2,
          },
        ],
      ),
      AppCharacter(
        id: 5,
        name: 'Titan Macrophage',
        type: 'Contrôle de Zone',
        pv: 120,
        cost: 80,
        description:
            'Un géant qui absorbe les débris et lance des contre-attaques dévastatrices sur les groupes ennemis.',
        isProtector: true,
        photoUrl: 'assets/images/macrophage_titan.png',
        attackData: [
          {
            'name': 'Tempête Cytokinique',
            'damage': 20,
            'range': 2,
            'aoe': true,
          },
          {
            'name': 'Purge Cellulaire',
            'damage': 5,
            'range': 1,
            'effect': 'Nettoyage Débris',
          },
        ],
      ),
      AppCharacter(
        id: 6,
        name: 'Commando Cellule T',
        type: 'Dégâts Ciblés',
        pv: 95,
        cost: 70,
        description:
            'Entraînée pour la précision, elle neutralise les menaces prioritaires avec des attaques imparables.',
        isProtector: true,
        photoUrl: 'assets/images/cellule_t_commando.png',
        attackData: [
          {'name': 'Frappe Précise', 'damage': 35, 'range': 2},
          {
            'name': 'Extermination Ciblée',
            'damage': 50,
            'range': 1,
            'cooldown': 5,
          },
        ],
      ),
      AppCharacter(
        id: 7,
        name: 'Alchimiste Basophile',
        type: 'Amélioration / Débuff',
        pv: 65,
        cost: 50,
        description:
            'Manipule les réactifs chimiques pour affaiblir les ennemis et booster les capacités des alliés.',
        isProtector: true,
        photoUrl: 'assets/images/basophile_alchimiste.png',
        attackData: [
          {
            'name': 'Brouillard Toxique',
            'damage': 5,
            'range': 3,
            'effect': 'Dégâts sur Temps',
          },
          {
            'name': 'Catalyseur Réactif',
            'effect': 'ATK+',
            'amount': 10,
            'duration': 3,
          },
        ],
      ),
    ];

    final List<AppCharacter> pathogens = [
      AppCharacter(
        id: 0,
        name: 'Corruptrice Bactérie',
        type: 'Pion Répandant',
        pv: 85,
        cost: 45,
        description:
            'Une menace virulente qui se multiplie rapidement, cherchant à déborder les défenses.',
        isProtector: false,
        photoUrl: 'assets/images/bacterie_corruptrice.png',
        attackData: [
          {'name': 'Essaim Microbien', 'damage': 18, 'range': 1, 'aoe': true},
          {
            'name': 'Division Cellulaire',
            'effect': 'Invoque Unité',
            'unitId': 0,
          },
        ],
      ),
      AppCharacter(
        id: 1,
        name: 'Fantôme Viral',
        type: 'Infiltrateur',
        pv: 70,
        cost: 65,
        description:
            'Difficile à cibler, ce virus se glisse à travers les lignes de défense, infectant de l\'intérieur.',
        isProtector: false,
        photoUrl: 'assets/images/virus_fantome.png',
        attackData: [
          {
            'name': 'Code Malveillant',
            'damage': 25,
            'range': 2,
            'effect': 'Ignorer Armure',
          },
          {
            'name': 'Incubation Silencieuse',
            'effect': 'Dégâts sur Temps',
            'duration': 3,
          },
        ],
      ),
      AppCharacter(
        id: 2,
        name: 'Colosse Parasite',
        type: 'Tank Pathogène',
        pv: 160,
        cost: 85,
        description:
            'Une bête imposante, lente mais incroyablement résistante, absorbant les dégâts pour ses alliés.',
        isProtector: false,
        photoUrl: 'assets/images/parasite_colossal.png',
        attackData: [
          {
            'name': 'Étreinte Dévorante',
            'damage': 20,
            'range': 1,
            'effect': 'Drain de PV',
          },
          {
            'name': 'Carapace Chitineuse',
            'effect': 'Réduction Dégâts',
            'amount': 15,
          },
        ],
      ),
      AppCharacter(
        id: 3,
        name: 'Nécrotique Fongus',
        type: 'Affliction de Zone',
        pv: 90,
        cost: 50,
        description:
            'Se répand et dégrade l\'environnement, infligeant des dégâts continus aux protecteurs proches.',
        isProtector: false,
        photoUrl: 'assets/images/fongus_necrotique.png',
        attackData: [
          {
            'name': 'Spores Toxiques',
            'damage': 10,
            'range': 2,
            'aoe': true,
            'effect': 'Dégâts sur Temps',
          },
          {
            'name': 'Propagation Racinaire',
            'effect': 'Ralentissement',
            'range': 3,
          },
        ],
      ),
      AppCharacter(
        id: 4,
        name: 'Mortelle Toxine',
        type: 'Support Toxique',
        pv: 60,
        cost: 70,
        description:
            'Une entité purement chimique qui n\'attaque pas directement mais empoisonne les défenses ennemies.',
        isProtector: false,
        photoUrl: 'assets/images/toxine_mortelle.png',
        attackData: [
          {
            'name': 'Injection de Venom',
            'damage': 0,
            'range': 3,
            'effect': 'Poison',
            'amount': 15,
            'duration': 3,
          },
          {
            'name': 'Nuage Corrosif',
            'damage': 5,
            'range': 2,
            'aoe': true,
            'effect': 'Réduction DEF',
          },
        ],
      ),
      AppCharacter(
        id: 5,
        name: 'Prion Dément',
        type: 'Perturbateur',
        pv: 100,
        cost: 75,
        description:
            'Une anomalie protéique qui désorganise les fonctions immunitaires, semant la confusion.',
        isProtector: false,
        photoUrl: 'assets/images/prion_fou.png',
        attackData: [
          {
            'name': 'Désordre Moléculaire',
            'damage': 15,
            'range': 1,
            'effect': 'Confusion',
          },
          {
            'name': 'Mutation Incohérente',
            'effect': 'Saut de Cible',
            'range': 4,
          },
        ],
      ),
      AppCharacter(
        id: 6,
        name: 'Cyber Bactériophage',
        type: 'Pirate Cellulaire',
        pv: 95,
        cost: 80,
        description:
            'Un virus biotechnologique capable de reprogrammer les cellules hôtes pour attaquer leurs alliés.',
        isProtector: false,
        photoUrl: 'assets/images/bacteriophage_cyber.png',
        attackData: [
          {
            'name': 'Contrôle Neural',
            'damage': 0,
            'range': 2,
            'effect': 'Tournement d\'Allié',
          },
          {
            'name': 'Surcharge Virale',
            'damage': 30,
            'range': 1,
            'effect': 'Désactivation Compétence',
          },
        ],
      ),
      AppCharacter(
        id: 7,
        name: 'Mimic Protozoaire',
        type: 'Caméléon',
        pv: 110,
        cost: 60,
        description:
            'Un organisme unicellulaire qui peut changer son apparence pour éviter les défenses et frapper.',
        isProtector: false,
        photoUrl: 'assets/images/protozoaire_mimic.png',
        attackData: [
          {
            'name': 'Absorption Biologique',
            'damage': 20,
            'range': 1,
            'effect': 'Vol de PV',
          },
          {
            'name': 'Camouflage Cellulaire',
            'effect': 'Évitement',
            'duration': 1,
          },
        ],
      ),
    ];

    // --- Ajout des protecteurs ---
    for (var agent in protectors) {
      try {
        // Vérifiez si l'agent existe déjà pour éviter les doublons
        final querySnapshot =
            await _firestore
                .collection('agents_protecteurs')
                .where('name', isEqualTo: agent.name)
                .get();

        if (querySnapshot.docs.isEmpty) {
          await _firestore
              .collection('agents_protecteurs')
              .doc('${agent.id}')
              .set(agent.toMap());

          print('Ajouté protecteur: ${agent.name}');
        } else {
          print('Protecteur ${agent.name} existe déjà. Saut.');
        }
      } catch (e) {
        print('Erreur lors de l\'ajout du protecteur ${agent.name}: $e');
      }
    }

    // --- Ajout des pathogènes ---
    for (var agent in pathogens) {
      try {
        final querySnapshot =
            await _firestore
                .collection('agents_pathogenes')
                .where('name', isEqualTo: agent.name)
                .get();

        if (querySnapshot.docs.isEmpty) {
          await _firestore
              .collection('agents_pathogenes')
              .doc('${agent.id}')
              .set(agent.toMap());

          print('Ajouté pathogène: ${agent.name}');
        } else {
          print('Pathogène ${agent.name} existe déjà. Saut.');
        }
      } catch (e) {
        print('Erreur lors de l\'ajout du pathogène ${agent.name}: $e');
      }
    }

    print('Initialisation des données terminée.');
  }
}
