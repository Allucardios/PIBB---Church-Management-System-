// Libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../core/const/theme.dart';
import '../../core/widgets/email_tf.dart';
import '../../core/widgets/pass_tf.dart';
import '../../data/controllers/auth.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // Controllers
  final ctrl = Get.find<AuthCtrl>();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  // Variables
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: Get.height * .37,
                  child: Center(
                    child: Image.asset(
                      'assets/icon.png',
                      height: Get.height * .27,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    spacing: 12,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Form(
                            key: key,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12,
                              children: [
                                // Email Field
                                EmailTextField(
                                  controller: _email,
                                  hint: 'Digite o seu Email',
                                ),
                                // Password Field
                                PasswordTextField(
                                  controller: _pass,
                                  hint: '***********',
                                  label: 'Palavra - passe',
                                ),
                                // Error Message
                                Obx(() {
                                  if (ctrl.errorMessage.value.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Text(
                                        ctrl.errorMessage.value,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                                // Login Button
                                Obx(() {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: ctrl.isLoading.value
                                          ? null
                                          : () async {
                                              if (!key.currentState!
                                                  .validate()) {
                                                return;
                                              }
                                              await ctrl.signIn(
                                                _email.text,
                                                _pass.text,
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
                                      child: ctrl.isLoading.value
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
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Get.to(() => SignUp()),
                            child: Text(
                              'Criar Conta',
                              style: TextStyle(color: AppTheme.primary),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        'Desenvolvido por Eng. Silviano da Silva',
                        style: TextStyle(fontSize: 7, color: Colors.white),
                      ),
                      Text(
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
