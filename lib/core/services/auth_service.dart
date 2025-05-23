import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    print('[AuthService] Tentative de connexion avec email: $email');
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('[AuthService] Connexion réussie: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('[AuthService] Erreur de connexion: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('[AuthService] Erreur inattendue lors de la connexion: $e');
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    print('[AuthService] Tentative d\'inscription avec email: $email');
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('[AuthService] Inscription réussie: ${userCredential.user?.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('[AuthService] Erreur d\'inscription: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('[AuthService] Erreur inattendue lors de l\'inscription: $e');
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    print('[AuthService] Tentative de connexion avec Google');
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('[AuthService] Connexion Google annulée par l\'utilisateur');
        return null;
      }

      print('[AuthService] Authentification Google réussie: ${googleUser.email}');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('[AuthService] Connexion à Firebase avec les identifiants Google...');
      final userCredential = await _auth.signInWithCredential(credential);
      print('[AuthService] Connexion Firebase réussie: ${userCredential.user?.uid}');
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('[AuthService] Erreur de connexion Google: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('[AuthService] Erreur inattendue lors de la connexion Google: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    print('[AuthService] Déconnexion en cours...');
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print('[AuthService] Déconnexion réussie');
    } catch (e) {
      print('[AuthService] Erreur lors de la déconnexion: $e');
      rethrow;
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Handle auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'too-many-requests':
        return 'Trop de tentatives. Veuillez réessayer plus tard.';
      case 'operation-not-allowed':
        return 'Cette opération n\'est pas autorisée.';
      default:
        return 'Une erreur inconnue est survenue. Code: ${e.code}';
    }
  }
}
