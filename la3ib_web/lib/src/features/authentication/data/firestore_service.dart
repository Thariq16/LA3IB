import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/app_user.dart';

part 'firestore_service.g.dart';

class FirestoreService {
  FirestoreService(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> setAppUser(AppUser appUser) {
    return _firestore.collection('users').doc(appUser.uid).set(appUser.toJson());
  }

  Future<void> deleteUser(String uid) {
    return _firestore.collection('users').doc(uid).delete();
  }

  Stream<AppUser?> watchAppUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return AppUser.fromJson(snapshot.data()!);
      }
      return null;
    });
  }
}

@Riverpod(keepAlive: true)
FirestoreService firestoreService(FirestoreServiceRef ref) {
  return FirestoreService(FirebaseFirestore.instance);
}
