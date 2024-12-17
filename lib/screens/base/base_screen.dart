import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Importa o pacote Curved Navigation Bar
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
            if (!(userManager.user?.admin ?? false))
              Scaffold(
                backgroundColor: MinhasCores.rosa_1,
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  centerTitle: true,
                  toolbarHeight: 80.0,
                  elevation: 0,
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ), // Ícone de menu
                        onPressed: () => Scaffold.of(context)
                            .openDrawer(), // Abre o drawer ao clicar no ícone de menu
                      );
                    },
                  ),
                  title: const Text(
                    'Meus Pedidos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
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
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ), // Ícone de menu
                      onPressed: () => Scaffold.of(context)
                          .openDrawer(), // Abre o drawer ao clicar no ícone de menu
                    );
                  },
                ),
                centerTitle: true,
                backgroundColor: MinhasCores.rosa_1,
                elevation: 0, // Remove a sombra da AppBar
                toolbarHeight: 80.0, // Define a altura da AppBar
              ),
            ),
            if (userManager.user?.admin ?? false)
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  backgroundColor: MinhasCores.rosa_1,
                  elevation: 0, // Remove a sombra da AppBar
                  toolbarHeight: 80.0, // Define a altura da AppBar
                  centerTitle: true,
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ), // Ícone de menu
                        onPressed: () => Scaffold.of(context)
                            .openDrawer(), // Abre o drawer ao clicar no ícone de menu
                      );
                    },
                  ),
                  title: const Text(
                    'Usuários',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                body: const UsuariosScreen(),
              ),
            if (userManager.user?.admin ?? false)
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
                  toolbarHeight: 80.0, // Define a altura da AppBar
                ),
                body: const PedidosScreen(),
              ),
          ];

          return Scaffold(
            body: PageView(
              controller: _pageController, // Controlador de páginas
              physics:
                  const NeverScrollableScrollPhysics(), // Desabilita a navegação pelo swipe
              children: screens,
            ),
            bottomNavigationBar: CurvedNavigationBar(
              backgroundColor:
                  MinhasCores.rosa_1, // Cor de fundo do CurvedNavigationBar
              color: MinhasCores.rosa_2, // Cor da barra
              buttonBackgroundColor:
                  MinhasCores.rosa_3, // Cor do botão ao ser pressionado
              height: 60, // Altura da barra
              items: <Widget>[
                Icon(Icons.home, size: 30, color: Colors.white),
                Icon(Icons.shopping_bag, size: 30, color: Colors.white),
                if (userManager.user?.admin ?? false) ...[
                  Icon(Icons.people, size: 30, color: Colors.white),
                  Icon(Icons.list_alt, size: 30, color: Colors.white),
                ] else ...[
                  Icon(Icons.list, size: 30, color: Colors.white),
                ],
                Icon(Icons.location_on, size: 30, color: Colors.white),
              ],
              onTap: (index) {
                pageManager.setPage(index);
                _pageController
                    .jumpToPage(index); // Navega para a página selecionada
              },
              animationDuration:
                  const Duration(milliseconds: 300), // Duração da animação
              animationCurve: Curves.easeInOut, // Curva da animação
            ),
          );
        },
      ),
    );
  }
}
