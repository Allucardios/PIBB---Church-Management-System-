// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/const/theme.dart';
import '../../core/widgets/email_tf.dart';
import '../../core/widgets/pass_tf.dart';
import '../../data/providers/auth_provider.dart';
import 'sign_up.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});
  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  // Controllers
  final _email = TextEditingController();
  final _pass = TextEditingController();

  // Variables
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authLoadingNotifierProvider);
    final errorMessage = ref.watch(authErrorNotifierProvider);

    // Show SnackBar when error occurs
    ref.listen(authErrorNotifierProvider, (prev, next) {
      if (next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.secondary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: size.height * .37,
                  child: Center(
                    child: Image.asset(
                      'assets/icon.png',
                      height: size.height * .27,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Form(
                              key: key,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Email Field
                                  EmailTextField(
                                    controller: _email,
                                    hint: 'Digite o seu Email',
                                  ),
                                  const SizedBox(height: 12),
                                  // Password Field
                                  PasswordTextField(
                                    controller: _pass,
                                    hint: '***********',
                                    label: 'Palavra - passe',
                                  ),
                                  const SizedBox(height: 12),
                                  // Error Message
                                  if (errorMessage.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Text(
                                        errorMessage,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  // Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: isLoading
                                          ? null
                                          : () async {
                                              if (!key.currentState!
                                                  .validate()) {
                                                return;
                                              }
                                              await ref
                                                  .read(
                                                    authServiceProvider
                                                        .notifier,
                                                  )
                                                  .signIn(
                                                    _email.text,
                                                    _pass.text,
                                                    context,
                                                  );
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              'Entrar',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const SignUp()),
                            ),
                            child: const Text(
                              'Criar Conta',
                              style: TextStyle(color: AppTheme.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Desenvolvido por Eng. Silviano da Silva',
                        style: TextStyle(fontSize: 7, color: Colors.white),
                      ),
                      const Text(
                        'PIBB 1.0.1 Versão Beta de teste',
                        style: TextStyle(fontSize: 7, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
