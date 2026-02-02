// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserProfileHash() =>
    r'e851bf43b5b89bfa53ac20109570d9615b861b19';

/// Cached stream provider for the current user's profile
/// This prevents creating new Firestore listeners on every navigation
///
/// Copied from [currentUserProfile].
@ProviderFor(currentUserProfile)
final currentUserProfileProvider = AutoDisposeStreamProvider<AppUser?>.internal(
  currentUserProfile,
  name: r'currentUserProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProfileRef = AutoDisposeStreamProviderRef<AppUser?>;
String _$currentUserProfileSyncHash() =>
    r'673ef26c4686330f3db5032782d2c2ac56a6eb0f';

/// Synchronous access to cached user profile
/// Returns null if not loaded yet or user not logged in
///
/// Copied from [currentUserProfileSync].
@ProviderFor(currentUserProfileSync)
final currentUserProfileSyncProvider = AutoDisposeProvider<AppUser?>.internal(
  currentUserProfileSync,
  name: r'currentUserProfileSyncProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserProfileSyncHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserProfileSyncRef = AutoDisposeProviderRef<AppUser?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
