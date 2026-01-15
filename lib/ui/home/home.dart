// Libraries
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Imports
import '../../data/controllers/profile.dart';
import 'dashboard.dart';
import 'expenses.dart';
import 'income.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ctrl = Get.find<ProfileCtrl>();

  int _page = 0;

  //methods
  void _goToPage(int index) => setState(() {
    _page = index;
  });

  final List _screens = [
    const DashBoard(),
    const IncomePage(),
    const ExpensePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  _screens[_page],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        onTap: _goToPage,
        items: _navs,
      ),
    );
  }

  final _navs = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.house_outlined),
      activeIcon: Icon(Icons.house),
      label: 'Casa',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.monetization_on_outlined),
      activeIcon: Icon(Icons.monetization_on),
      label: 'Receitas',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart_outlined),
      activeIcon: Icon(Icons.shopping_cart),
      label: 'Despesas',
    ),
  ];
}
