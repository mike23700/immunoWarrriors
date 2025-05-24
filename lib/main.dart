import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:immuno_warriors/firebase_options.dart';
import 'package:immuno_warriors/providers/user_profile_provider.dart';
import 'package:immuno_warriors/screens/auth/auth.dart'; // Exporte LoginScreen
import 'package:immuno_warriors/screens/home/home_screen.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('Initialisation de Firebase...');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialisé avec succès');

    // Vérifier si un utilisateur est déjà connecté
    final currentUser = FirebaseAuth.instance.currentUser;
    print(
      'Utilisateur actuel: ${currentUser?.email ?? "Aucun utilisateur connecté"}',
    );
  } catch (e) {
    print('Erreur lors de l\'initialisation de Firebase: $e');
    rethrow;
  }

  // Initialiser le fournisseur de profil utilisateur
  final userProfileProvider = UserProfileProvider();
  userProfileProvider.initialize();

  // Initialise Gemini avant de lancer l'app
  Gemini.init(apiKey: 'AIzaSyA-gHjd_eYu7hAdorkfGAZglJIO9RmD6k0');

  runApp(
    ChangeNotifierProvider.value(
      value: userProfileProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Immuno Warriors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Mettre à jour le fournisseur de profil utilisateur
          if (snapshot.connectionState == ConnectionState.active) {
            final userProfileProvider = Provider.of<UserProfileProvider>(
              context,
              listen: false,
            );
            userProfileProvider.initialize().then((_) {
              // La mise à jour du fournisseur est terminée
              print('Changement d\'état d\'authentification détecté');
              print('Connection State: ${snapshot.connectionState}');
              print('Has Data: ${snapshot.hasData}');
              print('Error: ${snapshot.error}');
            });
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('En attente de la vérification de l\'authentification...');
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            // User is logged in
            print('Utilisateur connecté: ${snapshot.data?.email}');
            // Initialiser le fournisseur de profil utilisateur
            final userProfileProvider = Provider.of<UserProfileProvider>(
              context,
              listen: false,
            );
            // Utiliser then pour gérer l'initialisation asynchrone
            userProfileProvider.initialize().then((_) {
              print('Profil utilisateur initialisé');
            });
            return const HomeScreen();
          }

          // User is not logged in
          print(
            'Aucun utilisateur connecté, affichage de l\'écran de connexion',
          );
          return const LoginScreen();
        },
      ),
    );
  }
}
