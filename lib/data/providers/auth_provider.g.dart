// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authNotifierHash() => r'7248d273a23949d98ceb097a67a7bbf84dafcca6';

/// Auth State Notifier
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeNotifierProvider<AuthNotifier, User?>.internal(
      AuthNotifier.new,
      name: r'authNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthNotifier = AutoDisposeNotifier<User?>;
String _$authLoadingNotifierHash() =>
    r'31296214f62c8ee470c9d01a1ef854deb6a2558a';

/// Loading State Provider
///
/// Copied from [AuthLoadingNotifier].
@ProviderFor(AuthLoadingNotifier)
final authLoadingNotifierProvider =
    AutoDisposeNotifierProvider<AuthLoadingNotifier, bool>.internal(
      AuthLoadingNotifier.new,
      name: r'authLoadingNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authLoadingNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthLoadingNotifier = AutoDisposeNotifier<bool>;
String _$authErrorNotifierHash() => r'60ef0968f0448135c057cc424e286b5cef306ef7';

/// Error Message Provider
///
/// Copied from [AuthErrorNotifier].
@ProviderFor(AuthErrorNotifier)
final authErrorNotifierProvider =
    AutoDisposeNotifierProvider<AuthErrorNotifier, String>.internal(
      AuthErrorNotifier.new,
      name: r'authErrorNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authErrorNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthErrorNotifier = AutoDisposeNotifier<String>;
String _$authServiceHash() => r'fbdbb742d63837494682ca63f14c73b42515418b';

/// Auth Service Provider
///
/// Copied from [AuthService].
@ProviderFor(AuthService)
final authServiceProvider =
    AutoDisposeNotifierProvider<AuthService, void>.internal(
      AuthService.new,
      name: r'authServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
