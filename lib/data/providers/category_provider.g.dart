// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesStreamHash() => r'4acca7acd51cf170853a5317fe7253bf481c50e5';

/// Categories Stream Provider
///
/// Copied from [categoriesStream].
@ProviderFor(categoriesStream)
final categoriesStreamProvider =
    AutoDisposeStreamProvider<List<Categories>>.internal(
      categoriesStream,
      name: r'categoriesStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoriesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoriesStreamRef = AutoDisposeStreamProviderRef<List<Categories>>;
String _$categoryServiceHash() => r'bbe797ec2d10478e1ca7e489c753bf7471d2ee32';

/// Category Service Provider
///
/// Copied from [CategoryService].
@ProviderFor(CategoryService)
final categoryServiceProvider =
    AutoDisposeNotifierProvider<CategoryService, void>.internal(
      CategoryService.new,
      name: r'categoryServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CategoryService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
