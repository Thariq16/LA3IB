import 'package:firebase_auth/firebase_auth.dart';

class ErrorMessageUtil {
  static String getErrorMessage(Object? error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is badly formatted.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'user-not-found':
          return 'No user found for this email.';
        case 'wrong-password':
          return 'Incorrect password provided.';
        case 'email-already-in-use':
          return 'The email address is already in use by another account.';
        case 'operation-not-allowed':
          return 'Operation not allowed.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'invalid-credential':
          return 'Invalid credentials. Please check your email and password.';
        default:
          return error.message ?? 'An unknown authentication error occurred.';
      }
    }
    return error.toString();
  }
}
