// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoriesStreamHash() => r'57a0e8258d18a002e40c06bcdd52cdeb76d3e098';

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
String _$categoryServiceHash() => r'0b890b5f7a579dd62564b0411c8ab8c5f3a26af5';

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
