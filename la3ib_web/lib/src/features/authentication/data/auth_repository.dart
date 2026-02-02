import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import '../../../config/env_config.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;
  
  // Google Sign-In instance - uses environment variable for web client ID
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb && EnvConfig.googleClientId.isNotEmpty
        ? EnvConfig.googleClientId
        : null,
  );

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kDebugMode) print('DEBUG: Starting Google Sign-In');
      final googleUser = await _googleSignIn.signIn();
      if (kDebugMode) print('DEBUG: Google User: $googleUser');
      
      final googleAuth = await googleUser?.authentication;
      if (kDebugMode) print('DEBUG: Google Auth: $googleAuth');

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        if (kDebugMode) print('DEBUG: Signing in with credential');
        return await _auth.signInWithCredential(credential);
      }
      throw FirebaseAuthException(
        code: 'ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    } catch (e, st) {
      if (kDebugMode) print('DEBUG: Google Sign-In Error: $e\n$st');
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(FirebaseAuth.instance);
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
