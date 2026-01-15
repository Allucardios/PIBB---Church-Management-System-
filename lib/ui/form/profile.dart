// Libraries
import 'package:app_pibb/core/widgets/money_tf.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../core/widgets/drop_tf.dart';
import '../../core/widgets/textfield.dart';
import '../../data/controllers/profile.dart';
import '../../data/models/user.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key, required this.prof, required this.isAdmin});
  final bool isAdmin;
  final Profile prof;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _key = GlobalKey<FormState>();
  final _ctrl = Get.find<ProfileCtrl>();

  ///Admin
  final _level = TextEditingController();
  final _active = TextEditingController();
  final _role = TextEditingController();

  ///User
  final _name = TextEditingController();
  final _phone = TextEditingController();

  ///Lists
  final levels = ['Admin', 'Manager', 'User'];
  final roles = ['Pastor', 'Membro', 'Tesoureiro', 'M. Finanças'];
  final actives = ['Ativo', 'Inativo'];

  bool isActive() {
    if (_active.text == actives[0]) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    //Admin
    _level.text = widget.prof.level;
    _role.text = widget.prof.role!;
    _active.text = widget.prof.active! ? actives[0] : actives[1];
    //User
    _phone.text=widget.prof.phone!;
    _name.text=widget.prof.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: widget.isAdmin ? admin() : user());
  }

  Widget _container(Widget child) => Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
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
                color: Get.theme.primaryColor,
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _submit(widget.prof),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
            MyTextField(controller: _name, hint: 'Fulano de Tal', icon: Icons.person_2_outlined, label: 'Nome Completo',),
            NumberTextField(controller: _phone, hint: '923000000', icon: Icons.phone, label: 'Telefone', limit: 9,),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _submit(widget.prof),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
        await _ctrl.updateProfile(value);
        Get.back();
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

        await _ctrl.updateProfile(value);
        Get.back();
      }
    }
  }
}
