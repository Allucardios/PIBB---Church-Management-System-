// Libraries
import 'package:app_pibb/ui/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../core/widgets/email_tf.dart';
import '../../core/widgets/pass_tf.dart';
import '../../core/widgets/textfield.dart';
import '../../data/controllers/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Controllers
  final auth = Get.find<AuthCtrl>();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _pass = TextEditingController();
  final _conf = TextEditingController();
  final _key = GlobalKey<FormState>();

  //methods
  void _signUp() async {
    //get data
    final email = _email.text;
    final pass = _pass.text;
    final conf = _conf.text;
    final name = _name.text;

    if (_key.currentState!.validate()) {
      if (conf == pass) {
        await auth.signUp(name, email, pass);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            showCloseIcon: true,
            closeIconColor: Colors.white,
            content: Text(
              'Senhas Devem ser Identicas',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Conta'), centerTitle: true),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    MyTextField(
                      controller: _name,
                      hint: 'Nome Completo',
                      icon: Icons.person_2_outlined,
                      label: 'Nome',
                    ),
                    EmailTextField(
                      controller: _email,
                      hint: 'Digite o seu email...',
                    ),
                    PasswordTextField(
                      controller: _pass,
                      hint: 'Digite a Senha',
                      label: 'Palavra - Passe',
                    ),
                    PasswordTextField(
                      controller: _conf,
                      hint: 'Corfirme a Senha',
                      label: 'Confirmar a Palavra - Passe',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Error Message
            Obx(() {
              if (auth.errorMessage.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    auth.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            // Sign Up Button
            Obx(() {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: auth.isLoading.value
                        ? null
                        : () async => _signUp(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: auth.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Criar Conta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Já tem uma conta? ',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                TextButton(
                  onPressed: () => Get.offAll(() => SignIn()),
                  child: Text(
                    'Entrar',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
