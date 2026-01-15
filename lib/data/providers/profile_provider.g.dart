// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allProfilesHash() => r'1c56183911fcd945da26f4cc4de6f4c2643c5dd2';

/// All Profiles Stream Provider
///
/// Copied from [allProfiles].
@ProviderFor(allProfiles)
final allProfilesProvider = AutoDisposeStreamProvider<List<Profile>>.internal(
  allProfiles,
  name: r'allProfilesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allProfilesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllProfilesRef = AutoDisposeStreamProviderRef<List<Profile>>;
String _$profileByIdHash() => r'01db66537df1a2cb7e31866fd47810b413db68a0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Profile by ID Stream Provider
///
/// Copied from [profileById].
@ProviderFor(profileById)
const profileByIdProvider = ProfileByIdFamily();

/// Profile by ID Stream Provider
///
/// Copied from [profileById].
class ProfileByIdFamily extends Family<AsyncValue<Profile?>> {
  /// Profile by ID Stream Provider
  ///
  /// Copied from [profileById].
  const ProfileByIdFamily();

  /// Profile by ID Stream Provider
  ///
  /// Copied from [profileById].
  ProfileByIdProvider call(String id) {
    return ProfileByIdProvider(id);
  }

  @override
  ProfileByIdProvider getProviderOverride(
    covariant ProfileByIdProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'profileByIdProvider';
}

/// Profile by ID Stream Provider
///
/// Copied from [profileById].
class ProfileByIdProvider extends AutoDisposeStreamProvider<Profile?> {
  /// Profile by ID Stream Provider
  ///
  /// Copied from [profileById].
  ProfileByIdProvider(String id)
    : this._internal(
        (ref) => profileById(ref as ProfileByIdRef, id),
        from: profileByIdProvider,
        name: r'profileByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$profileByIdHash,
        dependencies: ProfileByIdFamily._dependencies,
        allTransitiveDependencies: ProfileByIdFamily._allTransitiveDependencies,
        id: id,
      );

  ProfileByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<Profile?> Function(ProfileByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProfileByIdProvider._internal(
        (ref) => create(ref as ProfileByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Profile?> createElement() {
    return _ProfileByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProfileByIdRef on AutoDisposeStreamProviderRef<Profile?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ProfileByIdProviderElement
    extends AutoDisposeStreamProviderElement<Profile?>
    with ProfileByIdRef {
  _ProfileByIdProviderElement(super.provider);

  @override
  String get id => (origin as ProfileByIdProvider).id;
}

String _$currentUserStreamHash() => r'19ed4d86dc6f3416a24718d1613c2e39b4cc7633';

/// Current User Stream Provider
///
/// Copied from [currentUserStream].
@ProviderFor(currentUserStream)
final currentUserStreamProvider = AutoDisposeStreamProvider<Profile?>.internal(
  currentUserStream,
  name: r'currentUserStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserStreamRef = AutoDisposeStreamProviderRef<Profile?>;
String _$currentProfileHash() => r'2e8f1f726a2bd36c0c351232176c069e11cbca3c';

/// Current Profile Provider
///
/// Copied from [CurrentProfile].
@ProviderFor(CurrentProfile)
final currentProfileProvider =
    AutoDisposeNotifierProvider<CurrentProfile, Profile?>.internal(
      CurrentProfile.new,
      name: r'currentProfileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentProfile = AutoDisposeNotifier<Profile?>;
String _$profileServiceHash() => r'5cca11cdfb939a3b83162c28c4ed8a46e6a3738e';

/// Profile Service Provider
///
/// Copied from [ProfileService].
@ProviderFor(ProfileService)
final profileServiceProvider =
    AutoDisposeNotifierProvider<ProfileService, void>.internal(
      ProfileService.new,
      name: r'profileServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProfileService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
