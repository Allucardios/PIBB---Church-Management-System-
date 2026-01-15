// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../core/widgets/drop_tf.dart';
import '../../core/widgets/money_tf.dart';
import '../../core/widgets/textfield.dart';
import '../../data/models/user.dart';
import '../../data/providers/profile_provider.dart';

class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({super.key, required this.prof, required this.isAdmin});
  final bool isAdmin;
  final Profile prof;

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  final _key = GlobalKey<FormState>();

  ///Admin
  final _level = TextEditingController();
  final _active = TextEditingController();
  final _role = TextEditingController();

  ///User
  final _name = TextEditingController();
  final _phone = TextEditingController();

  ///Lists
  final levels = const ['Admin', 'Manager', 'User'];
  final roles = const ['Pastor', 'Membro', 'Tesoureiro', 'M. Finanças'];
  final actives = const ['Ativo', 'Inativo'];

  bool isActive() {
    if (_active.text == actives[0]) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    //Admin
    _level.text = widget.prof.level;
    _role.text = widget.prof.role ?? '';
    _active.text = (widget.prof.active ?? false) ? actives[0] : actives[1];
    //User
    _phone.text = widget.prof.phone ?? '';
    _name.text = widget.prof.name ?? '';
  }

  @override
  void dispose() {
    _level.dispose();
    _active.dispose();
    _role.dispose();
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: widget.isAdmin ? admin() : user());
  }

  Widget _container(Widget child) => Container(
    padding: const EdgeInsets.all(8.0),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 35,
          child: Center(
            child: Text(
              'Editar Dados ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        child,
      ],
    ),
  );

  Widget admin() => _container(
    Form(
      key: _key,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            DropDownTextField(
              ctrl: _role,
              label: 'Função Na Igreja',
              list: roles,
              icon: Icons.groups,
              hint: 'Membro',
            ),
            DropDownTextField(
              ctrl: _level,
              label: 'Actividade No Sistema',
              list: levels,
              icon: Icons.security_outlined,
              hint: 'Admin',
            ),
            DropDownTextField(
              ctrl: _active,
              label: 'Visibilidade',
              list: actives,
              icon: Icons.check,
              hint: 'Ativo ou Inativo',
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _submit(widget.prof),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Alterar'),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget user() => _container(
    Form(
      key: _key,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            MyTextField(
              controller: _name,
              hint: 'Fulano de Tal',
              icon: Icons.person_2_outlined,
              label: 'Nome Completo',
            ),
            NumberTextField(
              controller: _phone,
              hint: '923000000',
              icon: Icons.phone,
              label: 'Telefone',
              limit: 9,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _submit(widget.prof),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Alterar'),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  void _submit(Profile prof) async {
    Profile value;

    if (_key.currentState!.validate()) {
      if (widget.isAdmin) {
        value = Profile(
          id: prof.id,
          name: prof.name,
          phone: prof.phone,
          email: prof.email,
          role: _role.text.trim(),
          img: prof.img,
          active: isActive(),
          level: _level.text.trim(),
        );
      } else {
        value = Profile(
          id: prof.id,
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          email: prof.email,
          role: prof.role,
          img: prof.img,
          active: prof.active,
          level: prof.level,
        );
      }

      await ref.read(profileServiceProvider.notifier).updateProf(value);

      // If updating current user, we should also manually trigger a refresh or let the stream handle it.
      // But currentProfileProvider is a StateNotifier, we might want to update it if it's the current user.
      final currentProf = ref.read(currentProfileProvider);
      if (currentProf?.id == value.id) {
        await ref.read(currentProfileProvider.notifier).updateProfile(value);
      }

      if (mounted) Navigator.of(context).pop();
    }
  }
}
