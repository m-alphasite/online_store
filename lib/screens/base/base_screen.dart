import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/models/page_manager.dart'; // Importa o gerenciador de páginas
import 'package:online_store/screens/home/home_screen.dart';
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
      child: PageView(
        controller: _pageController, // Controlador de páginas
        physics:
            NeverScrollableScrollPhysics(), // Desabilita a navegação pelo swipe
        children: [
          HomeScreen(), // Tela inicial
          ProductsScreen(), // Tela de produtos
        ],
      ),
    );
  }
}
