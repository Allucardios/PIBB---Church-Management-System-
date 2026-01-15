// Imports
import 'package:app_pibb/data/service/bindings.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../ui/home/home.dart';

class AuthCtrl extends GetxController {
  final Rx<User?> _user = Rx<User?>(null);
  User? get user => _user.value;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  bool get isAuthenticated => _user.value != null;

  @override
  void onInit() {
    _user.value = client.auth.currentUser;
    client.auth.onAuthStateChange.listen((data) {
      _user.value = data.session?.user;
    });
    super.onInit();
  }

  // Auth Methods
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await client.auth
          .signInWithPassword(email: email, password: password)
          .then((event) {
            listenAuth();
          });
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = _errorLogin(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Sign up user with Supabase Auth
      await client.auth
          .signUp(
            email: email,
            password: password,
            data: {
              'name': name,
              'email': email,
            },
          )
          .then((event) => listenAuth());
    } catch (e) {
      print(e.toString());
      errorMessage.value = _errorSignup(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> listenAuth() async {
    client.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Get.deleteAll(force: true);
        AppBinding().dependencies();
        Get.offAll(() => HomePage());
      }
    });
  }

  String _errorLogin(String code) {
    switch (code) {
      case 'invalid_credentials':
      case 'invalid_grant':
        return 'Email ou palavra-passe incorretos.';
      case 'email_not_confirmed':
        return 'O teu email ainda não foi confirmado.';
      case 'user_not_found':
        return 'Conta não encontrada.';
      case 'invalid_email':
        return 'O email inserido é inválido.';
      case 'too_many_requests':
        return 'Muitas tentativas. Tente novamente dentro de alguns minutos.';
      case 'unexpected_failure':
        return 'Ocorreu um erro inesperado ao iniciar sessão.';
      case 'provider_disabled':
        return 'Este método de autenticação não está disponível.';
      default:
        return 'Erro ao iniciar sessão. Verifique os dados e tente novamente.';
    }
  }

  String _errorSignup(String code) {
    switch (code) {
      case 'user_already_exists':
        return 'Já existe uma conta com este email.';
      case 'invalid_email':
        return 'O email inserido é inválido.';
      case 'weak_password':
        return 'A palavra-passe é muito fraca.';
      case 'rate_limit_exceeded':
        return 'Muitas tentativas. Tente novamente dentro de alguns minutos.';
      case 'email_not_confirmed':
        return 'Confirma o email antes de continuar.';
      case 'unexpected_failure':
        return 'Ocorreu um erro inesperado ao criar a conta.';
      default:
        return 'Erro ao criar a conta. Tente novamente.';
    }
  }
}
