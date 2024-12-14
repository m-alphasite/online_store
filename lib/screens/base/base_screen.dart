import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/page_manager.dart'; // Importa o gerenciador de páginas
import 'package:online_store/screens/home/home_screen.dart'; // Importa a tela inicial
import 'package:online_store/screens/product/products_screen.dart'; // Importa a tela de produtos
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciamento de estado

// Classe BaseScreen que estende StatelessWidget para criar a tela base do app
class BaseScreen extends StatelessWidget {
  BaseScreen({super.key}); // Construtor da tela base

  final PageController _pageController =
      PageController(); // Controlador de páginas para navegação

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PageManager(_pageController), // Cria um gerenciador de páginas
      child: Consumer<PageManager>(
        builder: (context, pageManager, _) {
          return Scaffold(
            body: PageView(
              controller: _pageController, // Controlador de páginas
              physics:
                  const NeverScrollableScrollPhysics(), // Desabilita a navegação pelo swipe
              children: [
                HomeScreen(), // Tela inicial
                ProductsScreen(), // Tela de produtos
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: MinhasCores
                  .rosa_1, // Define a cor de fundo da barra de navegação
              elevation: 0,
              currentIndex: pageManager.page,
              onTap: (index) {
                pageManager.setPage(index);
              },
              selectedItemColor: Colors
                  .white, // Define a cor do ícone e texto do item selecionado como branco
              unselectedItemColor: Colors
                  .white, // Define a cor do ícone e texto do item não selecionado como branco
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag),
                  label: 'Produtos',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
