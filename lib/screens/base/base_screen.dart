import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:online_store/common/custom_drawer/custom_drawer.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/page_manager.dart';
import 'package:online_store/models/user_manager.dart';
import 'package:online_store/screens/home/home_screen.dart';
import 'package:online_store/screens/product/products_screen.dart';
import 'package:online_store/screens/admin/pedidos_screen.dart';
import 'package:online_store/screens/admin/usuarios_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PageManager(_pageController),
      child: Consumer2<PageManager, UserManager>(
        builder: (_, pageManager, userManager, __) {
          // Lista de telas na ordem correta
          List<Widget> screens = [
            HomeScreen(), // Página 0
            ProductsScreen(), // Página 1
            if (userManager.user?.admin ?? false)
              const UsuariosScreen(), // Página 2 (Usuários - Admins)
            if (userManager.user?.admin ?? false)
              const PedidosScreen(), // Página 3 (Pedidos - Admins)
            Scaffold(
              backgroundColor: MinhasCores.rosa_1,
              drawer: const CustomDrawer(),
              appBar: AppBar(
                title: const Text(
                  'Lojas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  },
                ),
                centerTitle: true,
                backgroundColor: MinhasCores.rosa_1,
                elevation: 0,
                toolbarHeight: 80.0,
              ),
            ), // Página 4
          ];

          // Lista de ícones na ordem correta
          List<Widget> navItems = [
            const Icon(Icons.home, size: 30, color: Colors.white), // Página 0
            const Icon(Icons.shopping_bag,
                size: 30, color: Colors.white), // Página 1
            if (userManager.user?.admin ?? false) ...[
              const Icon(Icons.people,
                  size: 30, color: Colors.white), // Página 2
              const Icon(Icons.list_alt,
                  size: 30, color: Colors.white), // Página 3
            ],
            const Icon(Icons.location_on,
                size: 30, color: Colors.white), // Página 4
          ];

          return Scaffold(
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: screens,
            ),
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor: MinhasCores.rosa_1,
              color: MinhasCores.rosa_2,
              buttonBackgroundColor: MinhasCores.rosa_3,
              height: 60,
              items: navItems,
              onTap: (index) {
                pageManager.setPage(index);
                _pageController.jumpToPage(index);
              },
              animationDuration: const Duration(milliseconds: 300),
              animationCurve: Curves.easeInOut,
            ),
          );
        },
      ),
    );
  }
}
