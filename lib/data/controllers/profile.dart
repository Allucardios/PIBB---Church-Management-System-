// Libraries
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Local Imports
import '../../core/const/app_config.dart';
import '../../core/const/functions.dart';
import '../../ui/auth/sign_in.dart';
import '../models/user.dart';

class ProfileCtrl extends GetxController {
  // Database
  static final inDB = client.from(AppConfig.tableProfiles);

  // Raw data
  final profile = Rxn<Profile>();
  final RxList<Profile> profileList = <Profile>[].obs;
  StreamSubscription<List<Profile>>? _profStream;

  @override
  void onInit() {
    super.onInit();
    //Escuta mudança de sessão
    client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        loadProfile();
        _checkUserActive();
      } else if (event == AuthChangeEvent.signedOut) {
        profile.value = null;
        profileList.clear();
      }
    });

    loadProfile();
    _checkUserActive();
  }

  @override
  void onClose() {
    _profStream?.cancel();
    super.onClose();
  }

  Future<void> _checkUserActive() async {
    await Future.delayed(Duration(milliseconds: 500)); // Aguarda carregar
    final prof = profile.value;
    if (prof != null && prof.active == false) {
      await client.auth.signOut();
      Get.snackbar(
        'Acesso Negado',
        'Sua conta foi desativada pelo administrador',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      Get.offAll(() => SignIn());
    }
  }

  Future<void> loadProfile() async {
    /// 1. Stream de Receitas (Incomes)
    _profStream = getAllProfiles().listen((list) {
      profileList.assignAll(list);
    });

    final user = client.auth.currentUser;
    if (user == null) return;

    try {
      final data = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      final p = Profile.fromJson(data);
      profile.value = p;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  ///Read
  Stream<List<Profile>> getAllProfiles() => client.from(AppConfig.tableProfiles)
      .stream(primaryKey: ['id'])
      .order('name', ascending: false)
      .map((rows) => rows.map((e) => Profile.fromJson(e)).toList());

  Stream<Profile?> get currentUser {
    final user = client.auth.currentUser;
    if (user == null) return Stream.value(null);

    return client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', user.id)
        .map((rows) => rows.isEmpty ? null : Profile.fromJson(rows.first));
  }

  Stream<Profile?> getById(String id) {
    return client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .limit(1)
        .map((data) => Profile.fromJson(data.first));
  }

  Future<Profile> getCurrentProfile() async {
    final data = await client.from('profiles').select().eq('id', uid).single();

    return Profile.fromJson(data);
  }

  ///Update
  Future<void> updateProf(Profile doc) async =>
      await inDB.update(doc.toJson()).eq('id', doc.id!);

  Future<void> updateProfile(Profile prof) async {
    try {
      await inDB
          .update(prof.toJson())
          .eq('id', prof.id!)
          .then((_) => Get.back());
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  bool isAdmin() => profile.value?.level == 'Admin';
  bool isManager() => profile.value?.level == 'Manager';
  bool isActive() => profile.value?.active ?? false;

  bool canEdit() {
    if (isAdmin() || isManager()) return true;
    return false;
  }



  Profile? getProfile() => profile.value;

  Future<void> logout() async {
    try {
      // Cancela streams
      await _profStream?.cancel();

      // Limpa dados locais
      profile.value = null;
      profileList.clear();

      // Logout do Supabase
      await client.auth.signOut().then((_) {
        // Limpa cache do GetX
        Get.delete<ProfileCtrl>();
        Get.put(ProfileCtrl(), permanent: true);
        Get.offAll(() => SignIn());
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
