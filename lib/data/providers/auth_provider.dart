// Libraries
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Local Imports
import '../../core/const/functions.dart';
import '../../ui/home/home.dart';

part 'auth_provider.g.dart';

/// Auth State Notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  User? build() {
    // Listen to auth state changes
    final subscription = client.auth.onAuthStateChange.listen((data) {
      final user = data.session?.user;
      if (state != user) {
        state = user;
      }
    });

    // Clean up subscription
    ref.onDispose(() => subscription.cancel());

    // Check current session
    final session = client.auth.currentSession;
    if (session == null || session.isExpired) {
      return null;
    }

    return session.user;
  }

  bool get isAuthenticated => state != null;
}

/// Loading State Provider
@riverpod
class AuthLoadingNotifier extends _$AuthLoadingNotifier {
  @override
  bool build() => false;

  void setLoading(bool value) => state = value;
}

/// Error Message Provider
@riverpod
class AuthErrorNotifier extends _$AuthErrorNotifier {
  @override
  String build() => '';

  void setError(String value) => state = value;

  void clearError() => state = '';
}

/// Auth Service Provider
@riverpod
class AuthService extends _$AuthService {
  @override
  void build() {}

  Future<void> signIn(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      ref.read(authLoadingNotifierProvider.notifier).setLoading(true);
      ref.read(authErrorNotifierProvider.notifier).clearError();

      await client.auth
          .signInWithPassword(email: email, password: password)
          .then((event) async {
            // Check if user is active before proceeding
            final profileData = await client
                .from('profiles')
                .select()
                .eq('id', event.user!.id)
                .single();
            final isActive = profileData['active'] as bool? ?? false;

            if (!isActive) {
              await client.auth.signOut();
              ref
                  .read(authErrorNotifierProvider.notifier)
                  .setError(
                    'A tua conta está desativada. Contacta o administrador.',
                  );
              return;
            }

            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }
          });
    } catch (e) {
      ref.read(authLoadingNotifierProvider.notifier).setLoading(false);
      ref
          .read(authErrorNotifierProvider.notifier)
          .setError(_errorLogin(e.toString()));
    } finally {
      ref.read(authLoadingNotifierProvider.notifier).setLoading(false);
    }
  }

  Future<void> signUp(
    String name,
    String email,
    String password,
    context,
  ) async {
    try {
      ref.read(authLoadingNotifierProvider.notifier).setLoading(true);
      ref.read(authErrorNotifierProvider.notifier).clearError();

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'email': email},
      );

      if (response.user != null && response.session != null) {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      }
    } catch (e) {
      ref
          .read(authErrorNotifierProvider.notifier)
          .setError(_errorSignup(e.toString()));
    } finally {
      ref.read(authLoadingNotifierProvider.notifier).setLoading(false);
    }
  }

  Future<void> signOut() async => await client.auth.signOut();

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
