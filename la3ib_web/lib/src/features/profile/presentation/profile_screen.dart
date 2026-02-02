import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common_widgets/responsive_center.dart';
import '../../../constants/app_sizes.dart';
import '../../../theme/brand_colors.dart';
import '../../authentication/data/auth_repository.dart';
import '../../authentication/data/firestore_service.dart';
import '../../authentication/presentation/user_profile_provider.dart';
import 'profile_controller.dart';
import 'widgets/user_stats_widget.dart';
import 'widgets/profile_info_row.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final user = ref.read(authRepositoryProvider).currentUser;
        if (user != null) {
          // Delete Firestore data
          await ref.read(firestoreServiceProvider).deleteUser(user.uid);
          // Delete Auth account
          await user.delete(); 
          // Note: Auth state change will trigger redirect to login
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting account: $e')),
          );
        }
      }
    }
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appUserAsync = ref.watch(currentUserProfileProvider);
    final userStatsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: () => context.pushNamed('editProfile'),
          ),
        ],
      ),
      body: appUserAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (appUser) {
          if (appUser == null) {
            return const Center(child: Text('User not found'));
          }

          return ResponsiveCenter(
            maxContentWidth: 500,
            padding: const EdgeInsets.all(AppSizes.p24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        // Profile Photo
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: BrandColors.primaryGreen.withOpacity(0.2),
                          backgroundImage: appUser.photoUrl != null
                              ? NetworkImage(appUser.photoUrl!)
                              : null,
                          child: appUser.photoUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: BrandColors.primaryGreen,
                                )
                              : null,
                        ),
                        gapH16,
                        // Display Name
                        Text(
                          appUser.displayName ?? 'No Name',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        gapH4,
                        // Email
                        Text(
                          appUser.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH32,

                  // User Stats
                  userStatsAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => const SizedBox.shrink(),
                    data: (stats) => UserStatsWidget(
                      gamesOrganized: stats.gamesOrganized,
                      gamesJoined: stats.gamesJoined,
                      memberSince: appUser.createdAt,
                    ),
                  ),
                  gapH32,

                  // User Info Section
                  Text(
                    'Profile Info',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gapH16,
                  Container(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        ProfileInfoRow(
                          icon: Icons.location_city,
                          label: 'City',
                          value: appUser.city ?? 'Not set',
                        ),
                        Divider(color: theme.colorScheme.outline.withOpacity(0.2)),
                        ProfileInfoRow(
                          icon: Icons.person_outline,
                          label: 'Gender',
                          value: appUser.gender ?? 'Not set',
                        ),
                        Divider(color: theme.colorScheme.outline.withOpacity(0.2)),
                        ProfileInfoRow(
                          icon: Icons.sports_soccer,
                          label: 'Preferred Sports',
                          value: appUser.preferredSports.isNotEmpty
                              ? appUser.preferredSports.join(', ')
                              : 'Not set',
                        ),
                      ],
                    ),
                  ),
                  gapH32,

                  // Actions Section
                  Text(
                    'Account',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  gapH16,
                  
                  // Edit Profile Button
                  OutlinedButton.icon(
                    onPressed: () => context.pushNamed('editProfile'),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  gapH12,
                  
                  // Sign Out Button
                  OutlinedButton.icon(
                    onPressed: () => _signOut(context, ref),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  gapH12,
                  
                  // Delete Account Button
                  OutlinedButton.icon(
                    onPressed: () => _deleteAccount(context, ref),
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    label: const Text(
                      'Delete Account',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                  gapH32,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
