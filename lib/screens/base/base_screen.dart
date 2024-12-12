import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/common/custom_drawer/custom_drawer.dart'; // Importa o drawer personalizado
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa as cores personalizadas
import 'package:online_store/models/page_manager.dart'; // Importa o gerenciador de páginas
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
          PageManager(_pageController), // Cria e fornece o PageManager
      child: PageView(
        controller: _pageController, // Controlador de páginas
        children: <Widget>[
          Scaffold(
            backgroundColor:
                MinhasCores.rosa_1, // Define a cor de fundo do Scaffold
            drawer: const CustomDrawer(), // Adiciona o drawer personalizado
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () => Scaffold.of(context)
                      .openDrawer(), // Abre o drawer ao clicar no ícone de menu
                );
              }),
              title: Column(
                children: const [
                  Text(
                    'Pandora Fashion', // Título da AppBar
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              centerTitle: true, // Centraliza o título
              backgroundColor:
                  MinhasCores.rosa_2, // Define a cor de fundo da AppBar
              elevation: 0, // Remove a sombra da AppBar
              toolbarHeight: 80.0, // Define a altura da AppBar
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom:
                      Radius.circular(12.0), // Define o raio de borda inferior
                ),
              ),
            ),
          ),
          ProductsScreen(), // Adiciona a tela de produtos
          Scaffold(
            backgroundColor:
                MinhasCores.rosa_1, // Define a cor de fundo do Scaffold
            drawer: const CustomDrawer(), // Adiciona o drawer personalizado
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () => Scaffold.of(context)
                      .openDrawer(), // Abre o drawer ao clicar no ícone de menu
                );
              }),
              title: Column(
                children: const [
                  Text(
                    'Pandora Fashion', // Título da AppBar
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              centerTitle: true, // Centraliza o título
              backgroundColor:
                  MinhasCores.rosa_2, // Define a cor de fundo da AppBar
              elevation: 0, // Remove a sombra da AppBar
              toolbarHeight: 80.0, // Define a altura da AppBar
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom:
                      Radius.circular(12.0), // Define o raio de borda inferior
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor:
                MinhasCores.rosa_1, // Define a cor de fundo do Scaffold
            drawer: const CustomDrawer(), // Adiciona o drawer personalizado
            appBar: AppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  color: Colors.white,
                  onPressed: () => Scaffold.of(context)
                      .openDrawer(), // Abre o drawer ao clicar no ícone de menu
                );
              }),
              title: Column(
                children: const [
                  Text(
                    'Pandora Fashion', // Título da AppBar
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              centerTitle: true, // Centraliza o título
              backgroundColor:
                  MinhasCores.rosa_2, // Define a cor de fundo da AppBar
              elevation: 0, // Remove a sombra da AppBar
              toolbarHeight: 80.0, // Define a altura da AppBar
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom:
                      Radius.circular(12.0), // Define o raio de borda inferior
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
