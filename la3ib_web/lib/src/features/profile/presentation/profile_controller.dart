import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../authentication/data/auth_repository.dart';

part 'profile_controller.g.dart';

/// Provider for user game statistics
@riverpod
Future<UserStats> userStats(UserStatsRef ref) async {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    return const UserStats(gamesOrganized: 0, gamesJoined: 0);
  }

  final firestore = FirebaseFirestore.instance;
  
  // Count games organized
  final organizedQuery = await firestore
      .collection('games')
      .where('organizerId', isEqualTo: user.uid)
      .count()
      .get();
  
  // Count games joined (check participants subcollection)
  // For now, we'll use a simpler approach
  final allGames = await firestore.collection('games').get();
  int joinedCount = 0;
  
  for (final gameDoc in allGames.docs) {
    final participant = await gameDoc.reference
        .collection('participants')
        .doc(user.uid)
        .get();
    if (participant.exists) {
      joinedCount++;
    }
  }

  return UserStats(
    gamesOrganized: organizedQuery.count ?? 0,
    gamesJoined: joinedCount,
  );
}

/// User statistics data class
class UserStats {
  const UserStats({
    required this.gamesOrganized,
    required this.gamesJoined,
  });

  final int gamesOrganized;
  final int gamesJoined;
}
