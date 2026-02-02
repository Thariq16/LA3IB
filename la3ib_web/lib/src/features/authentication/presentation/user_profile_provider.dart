import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../data/firestore_service.dart';
import '../domain/app_user.dart';

part 'user_profile_provider.g.dart';

/// Cached stream provider for the current user's profile
/// This prevents creating new Firestore listeners on every navigation
@riverpod
Stream<AppUser?> currentUserProfile(CurrentUserProfileRef ref) {
  final authUser = ref.watch(authStateChangesProvider).value;
  
  if (authUser == null) {
    return Stream.value(null);
  }
  
  return ref.watch(firestoreServiceProvider).watchAppUser(authUser.uid);
}

/// Synchronous access to cached user profile
/// Returns null if not loaded yet or user not logged in
@riverpod
AppUser? currentUserProfileSync(CurrentUserProfileSyncRef ref) {
  return ref.watch(currentUserProfileProvider).value;
}
