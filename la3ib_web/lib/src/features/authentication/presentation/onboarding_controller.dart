import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../authentication/data/auth_repository.dart';
import '../../authentication/data/firestore_service.dart';
import '../../authentication/domain/app_user.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  Future<void> completeOnboarding({
    required String displayName,
    required String city,
    required String gender,
    required List<String> preferredSports,
  }) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    print('DEBUG: completeOnboarding started');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final appUser = AppUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: displayName,
          photoUrl: user.photoURL,
          city: city,
          gender: gender,
          preferredSports: preferredSports,
          createdAt: DateTime.now(),
        );
        print('DEBUG: Setting app user in firestore');
        await ref.read(firestoreServiceProvider).setAppUser(appUser);
        print('DEBUG: setAppUser completed');
      } catch (e) {
        print('DEBUG: Error in completeOnboarding: $e');
        rethrow;
      }
    });
  }
}
