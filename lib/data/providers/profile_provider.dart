// Libraries
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Local Imports
import '../../core/const/app_config.dart';
import '../../core/const/functions.dart';
import '../models/user.dart';

part 'profile_provider.g.dart';

/// Current Profile Provider
@riverpod
class CurrentProfile extends _$CurrentProfile {
  @override
  Profile? build() {
    // Listen to auth state changes to trigger rebuilds
    final authSub = client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedOut) {
        state = null;
      }
    });

    ref.onDispose(() => authSub.cancel());

    final user = client.auth.currentUser;
    if (user == null) return null;

    // Use stream for real-time updates of the current profile
    final stream = client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', user.id)
        .map((rows) => rows.isEmpty ? null : Profile.fromJson(rows.first));

    final subscription = stream.listen((profile) {
      state = profile;
      if (profile != null && profile.active == false) {
        client.auth.signOut();
      }
    });

    ref.onDispose(() => subscription.cancel());

    return null; // Initial state
  }

  Future<void> updateProfile(Profile prof) async {
    try {
      await client
          .from(AppConfig.tableProfiles)
          .update(prof.toJson())
          .eq('id', prof.id!);
      // state will be automatically updated by the stream
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  bool isAdmin() => state?.level == 'Admin';
  bool isManager() => state?.level == 'Manager';
  bool isActive() => state?.active ?? false;

  bool canEdit() {
    if (isAdmin() || isManager()) return true;
    return false;
  }

  Profile? getProfile() => state;

  Future<void> logout(BuildContext context) async {
    try {
      // Clear local data
      state = null;

      // Logout from Supabase
      await client.auth.signOut();

      // Navigation will be handled by UI layer
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
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
  final user = client.auth.currentUser;
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
