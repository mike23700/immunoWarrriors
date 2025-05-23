import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:immuno_warriors/core/services/auth_service.dart';
import 'package:immuno_warriors/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final user = await ref.watch(authServiceProvider).currentUser;
  if (user == null) return null;
  return AppUser.fromFirebaseUser(user);
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  
  AuthNotifier(this.ref) : super(const AsyncValue.data(null));
  
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    print('[AuthNotifier] signInWithEmailAndPassword appelé avec email: $email');
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      print('[AuthNotifier] Appel à authService.signInWithEmailAndPassword...');
      await authService.signInWithEmailAndPassword(email, password);
      print('[AuthNotifier] Connexion réussie via AuthNotifier');
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      print('[AuthNotifier] Erreur lors de la connexion: $e');
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
  
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    print('[AuthNotifier] registerWithEmailAndPassword appelé avec email: $email');
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      print('[AuthNotifier] Appel à authService.registerWithEmailAndPassword...');
      await authService.registerWithEmailAndPassword(email, password);
      print('[AuthNotifier] Inscription réussie via AuthNotifier');
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      print('[AuthNotifier] Erreur lors de l\'inscription: $e');
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
  
  Future<void> signInWithGoogle() async {
    print('[AuthNotifier] signInWithGoogle appelé');
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      print('[AuthNotifier] Appel à authService.signInWithGoogle...');
      await authService.signInWithGoogle();
      print('[AuthNotifier] Connexion Google réussie via AuthNotifier');
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      print('[AuthNotifier] Erreur lors de la connexion Google: $e');
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
  
  Future<void> signOut() async {
    print('[AuthNotifier] signOut appelé');
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      print('[AuthNotifier] Appel à authService.signOut...');
      await authService.signOut();
      print('[AuthNotifier] Déconnexion réussie via AuthNotifier');
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      print('[AuthNotifier] Erreur lors de la déconnexion: $e');
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (ref) => AuthNotifier(ref),
);
