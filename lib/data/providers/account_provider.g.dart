// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountsStreamHash() => r'b25a5804dfbbd2927dbe83513b4f23b92b9ddf84';

/// See also [accountsStream].
@ProviderFor(accountsStream)
final accountsStreamProvider =
    AutoDisposeStreamProvider<List<Account>>.internal(
      accountsStream,
      name: r'accountsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountsStreamRef = AutoDisposeStreamProviderRef<List<Account>>;
String _$accountTransactionsStreamHash() =>
    r'cb3182206eba82aa3bd2678c04fabf71c90ab8e7';

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

/// See also [accountTransactionsStream].
@ProviderFor(accountTransactionsStream)
const accountTransactionsStreamProvider = AccountTransactionsStreamFamily();

/// See also [accountTransactionsStream].
class AccountTransactionsStreamFamily
    extends Family<AsyncValue<List<AccountTransaction>>> {
  /// See also [accountTransactionsStream].
  const AccountTransactionsStreamFamily();

  /// See also [accountTransactionsStream].
  AccountTransactionsStreamProvider call(int accountId) {
    return AccountTransactionsStreamProvider(accountId);
  }

  @override
  AccountTransactionsStreamProvider getProviderOverride(
    covariant AccountTransactionsStreamProvider provider,
  ) {
    return call(provider.accountId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountTransactionsStreamProvider';
}

/// See also [accountTransactionsStream].
class AccountTransactionsStreamProvider
    extends AutoDisposeStreamProvider<List<AccountTransaction>> {
  /// See also [accountTransactionsStream].
  AccountTransactionsStreamProvider(int accountId)
    : this._internal(
        (ref) => accountTransactionsStream(
          ref as AccountTransactionsStreamRef,
          accountId,
        ),
        from: accountTransactionsStreamProvider,
        name: r'accountTransactionsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$accountTransactionsStreamHash,
        dependencies: AccountTransactionsStreamFamily._dependencies,
        allTransitiveDependencies:
            AccountTransactionsStreamFamily._allTransitiveDependencies,
        accountId: accountId,
      );

  AccountTransactionsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountId,
  }) : super.internal();

  final int accountId;

  @override
  Override overrideWith(
    Stream<List<AccountTransaction>> Function(
      AccountTransactionsStreamRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountTransactionsStreamProvider._internal(
        (ref) => create(ref as AccountTransactionsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountId: accountId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<AccountTransaction>> createElement() {
    return _AccountTransactionsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountTransactionsStreamProvider &&
        other.accountId == accountId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountTransactionsStreamRef
    on AutoDisposeStreamProviderRef<List<AccountTransaction>> {
  /// The parameter `accountId` of this provider.
  int get accountId;
}

class _AccountTransactionsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<AccountTransaction>>
    with AccountTransactionsStreamRef {
  _AccountTransactionsStreamProviderElement(super.provider);

  @override
  int get accountId => (origin as AccountTransactionsStreamProvider).accountId;
}

String _$allTransactionsStreamHash() =>
    r'047ce0d84beba6ec0d864c458a22f88c61e41723';

/// See also [allTransactionsStream].
@ProviderFor(allTransactionsStream)
final allTransactionsStreamProvider =
    AutoDisposeStreamProvider<List<AccountTransaction>>.internal(
      allTransactionsStream,
      name: r'allTransactionsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allTransactionsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllTransactionsStreamRef =
    AutoDisposeStreamProviderRef<List<AccountTransaction>>;
String _$accountServiceHash() => r'b0959ff253124bbd0b8d130b3b7f98f8cd78324d';

/// See also [AccountService].
@ProviderFor(AccountService)
final accountServiceProvider =
    AutoDisposeNotifierProvider<AccountService, void>.internal(
      AccountService.new,
      name: r'accountServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AccountService = AutoDisposeNotifier<void>;
String _$accountCalculationsHash() =>
    r'4f1b5eb24d59beb9fcab69323b8fd021c9c5a905';

/// See also [AccountCalculations].
@ProviderFor(AccountCalculations)
final accountCalculationsProvider =
    AutoDisposeNotifierProvider<AccountCalculations, void>.internal(
      AccountCalculations.new,
      name: r'accountCalculationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountCalculationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AccountCalculations = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
