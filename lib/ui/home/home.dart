// Libraries
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Local Imports
import '../../data/providers/account_provider.dart';
import '../../data/providers/auth_provider.dart';
import '../../data/providers/finance_provider.dart';
import 'dashboard.dart';
import 'expenses.dart';
import 'income.dart';

import '../../core/widgets/responsive.dart';
import '../view/drawer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _page = 0;

  @override
  void initState() {
    super.initState();
    // Ensure default accounts exist
    Future.microtask(() {
      ref.read(accountServiceProvider.notifier).ensureDefaultAccount();
    });
  }

  //methods
  void _goToPage(int index) => setState(() {
    _page = index;
  });

  final List<Widget> _screens = [
    const DashBoard(),
    const IncomePage(),
    const ExpensePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    // Listen for auth errors globally in the home page
    ref.listen(incomeStreamProvider, (prev, next) {
      if (next.hasError && next.error.toString().contains('invalidjwttoken')) {
        ref.read(authServiceProvider.notifier).signOut();
      }
    });
    ref.listen(expenseStreamProvider, (prev, next) {
      if (next.hasError && next.error.toString().contains('invalidjwttoken')) {
        ref.read(authServiceProvider.notifier).signOut();
      }
    });

    final bodyContent = IndexedStack(index: _page, children: _screens);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            Builder(
              builder: (context) {
                final width = MediaQuery.of(context).size.width;
                return SizedBox(
                  width: width * 0.25 > 300 ? 300 : width * 0.25,
                  child: MyDrawer(currentPage: _page, onPageChanged: _goToPage),
                );
              },
            ),
            Expanded(child: bodyContent),
          ],
        ),
      );
    }

    return Scaffold(
      body: bodyContent,
      bottomNavigationBar: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _page,
          onTap: _goToPage,
          items: _navs,
        ),
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
