// Libraries
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Local Imports
import '../../core/const/app_config.dart';
import '../../core/const/functions.dart';
import '../models/user.dart';
import 'auth_provider.dart';

part 'profile_provider.g.dart';

/// Current Profile Provider
@riverpod
class CurrentProfile extends _$CurrentProfile {
  @override
  Profile? build() {
    final asyncProfile = ref.watch(currentUserStreamProvider);

    // Side effect: Logout if inactive
    ref.listen(currentUserStreamProvider, (prev, next) {
      final profile = next.value;
      if (profile != null && profile.active == false) {
        if (kDebugMode) print('CurrentProfile: User deactivated. Signing out.');
        ref
            .read(authErrorNotifierProvider.notifier)
            .setError('A tua conta está desativada. Contacta o administrador.');
        ref.read(authServiceProvider.notifier).signOut();
      }
    });

    return asyncProfile.value;
  }

  Future<void> updateProfile(Profile prof) async {
    try {
      await client
          .from(AppConfig.tableProfiles)
          .update(prof.toJson())
          .eq('id', prof.id!);
    } catch (e) {
      if (kDebugMode) print('Update Profile Error: $e');
    }
  }

  bool isAdmin() => state?.level.trim().toLowerCase() == 'admin';
  bool isManager() => state?.level.trim().toLowerCase() == 'manager';
  bool isActive() => state?.active ?? false;

  bool canEdit() {
    final lvl = state?.level.trim().toLowerCase();
    if (lvl == 'admin' || lvl == 'manager') return true;
    return false;
  }

  Profile? getProfile() => state;

  Future<void> logout(BuildContext context) async {
    try {
      state = null;
      await client.auth.signOut();
    } catch (e) {
      if (kDebugMode) print('Logout Error: $e');
    }
  }
}

/// All Profiles Stream Provider
@riverpod
Stream<List<Profile>> allProfiles(AllProfilesRef ref) {
  return client
      .from(AppConfig.tableProfiles)
      .stream(primaryKey: ['id'])
      .order('name', ascending: false)
      .map((rows) => rows.map((e) => Profile.fromJson(e)).toList());
}

/// Profile by ID Stream Provider
@riverpod
Stream<Profile?> profileById(ProfileByIdRef ref, String id) {
  return client
      .from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', id)
      .limit(1)
      .map((data) => data.isEmpty ? null : Profile.fromJson(data.first));
}

/// Current User Stream Provider
@riverpod
Stream<Profile?> currentUserStream(CurrentUserStreamRef ref) {
  final user = ref.watch(authNotifierProvider);
  if (user == null) return Stream.value(null);

  return client
      .from('profiles')
      .stream(primaryKey: ['id'])
      .eq('id', user.id)
      .map((rows) => rows.isEmpty ? null : Profile.fromJson(rows.first));
}

/// Profile Service Provider
@riverpod
class ProfileService extends _$ProfileService {
  @override
  void build() {}

  Future<void> updateProf(Profile doc) async => await client
      .from(AppConfig.tableProfiles)
      .update(doc.toJson())
      .eq('id', doc.id!);

  Future<Profile> getCurrentProfile() async {
    final data = await client.from('profiles').select().eq('id', uid).single();
    return Profile.fromJson(data);
  }
}
