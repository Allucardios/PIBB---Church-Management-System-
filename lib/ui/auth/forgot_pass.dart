import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/const/functions.dart';
import '../../core/widgets/email_tf.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _email = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool _isLoading = false;

  void _request() async {
    if (!_key.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    try {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Verifica o Seu Email'),
            content: Text(
              'Foi enviado um token de reset de palavra passe para o seu email',
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: Text('Cancelar')),
              TextButton(onPressed: () {}, child: Text('Continuar')),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        snackDialog(context, 'Error: $e', Colors.redAccent);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 12),
                  child: Text(
                    'Esqueceu a sua palavra passe?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Digite o seu email e receberá um token de troca de senha',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 40),
                  child: EmailTextField(
                    controller: _email,
                    hint: 'Email do Utilizador',
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _request(),
                    child: Text('Receber Token'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
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
