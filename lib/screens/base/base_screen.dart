import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/common/custom_drawer/custom_drawer.dart'; // Importa o custom drawer
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa o arquivo de cores personalizadas
import 'package:online_store/models/page_manager.dart'; // Importa o gerenciador de páginas
import 'package:online_store/models/user_manager.dart'; // Importa o gerenciador de usuários
import 'package:online_store/screens/home/home_screen.dart'; // Importa a tela inicial
import 'package:online_store/screens/product/products_screen.dart'; // Importa a tela de produtos
import 'package:online_store/screens/admin/pedidos_screen.dart'; // Importa a tela de pedidos
import 'package:online_store/screens/admin/usuarios_screen.dart'; // Importa a tela de usuários
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciamento de estado

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key}); // Construtor da tela base

  final PageController _pageController =
      PageController(); // Controlador de páginas para navegação

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PageManager(_pageController), // Cria um gerenciador de páginas
      child: Consumer2<PageManager, UserManager>(
        builder: (_, pageManager, userManager, __) {
          List<Widget> screens = [
            HomeScreen(), // Tela inicial
            ProductsScreen(), // Tela de produtos
            Scaffold(
              drawer: const CustomDrawer(),
              appBar: AppBar(
                title: const Text('MeusPedidos'),
              ),
            ),
            Scaffold(
              drawer: const CustomDrawer(),
              appBar: AppBar(
                title: const Text('Lojas'),
              ),
            ),
          ];

          if (userManager.user?.admin ?? false) {
            screens.addAll([
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  centerTitle: true,
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.menu), // Ícone de menu
                        onPressed: () => Scaffold.of(context)
                            .openDrawer(), // Abre o drawer ao clicar no ícone de menu
                      );
                    },
                  ),
                  title: const Text(
                    'Usuários',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  toolbarHeight: 90.0, // Define a altura da AppBar
                ),
                body: const UsuariosScreen(),
              ),
              if (!(userManager.user?.admin ?? false))
                Scaffold(
                  drawer: const CustomDrawer(),
                  appBar: AppBar(
                    centerTitle: true,
                    leading: Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu), // Ícone de menu
                          onPressed: () => Scaffold.of(context)
                              .openDrawer(), // Abre o drawer ao clicar no ícone de menu
                        );
                      },
                    ),
                    title: const Text(
                      'Pedidos',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    toolbarHeight: 90.0, // Define a altura da AppBar
                  ),
                  body: const PedidosScreen(),
                ),
            ]);
          }

          return Scaffold(
            body: PageView(
              controller: _pageController, // Controlador de páginas
              physics:
                  const NeverScrollableScrollPhysics(), // Desabilita a navegação pelo swipe
              children: screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: pageManager.page,
              onTap: (index) {
                pageManager.setPage(index);
                _pageController
                    .jumpToPage(index); // Navega para a página selecionada
              },
              selectedItemColor: MinhasCores.rosa_3,
              unselectedItemColor: MinhasCores.rosa_3,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag),
                  label: 'Produtos',
                ),
                if (!(userManager.user?.admin ?? false))
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: 'Meus Pedidos',
                  ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: 'Lojas',
                ),
                if (userManager.user?.admin ?? false) ...[
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: 'Usuários',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    label: 'Pedidos',
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
