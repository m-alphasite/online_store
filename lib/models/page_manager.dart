import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário

class PageManager extends ChangeNotifier {
  // Cria uma classe que extende ChangeNotifier para gerenciar a página atual
  PageManager(this._pageController); // Construtor que recebe um PageController

  final PageController _pageController; // Controlador de páginas
  int page = 0; // Variável que armazena a página atual

  // Método para definir a página atual com animação
  void setPage(
    int value, {
    Duration duration =
        const Duration(milliseconds: 300), // Define a duração da animação
    Curve curve = Curves.ease, // Define a curva da animação
  }) {
    if (value == page)
      return; // Se a página atual for igual à página desejada, não faz nada

    page = value; // Atualiza a página atual
    _pageController.animateToPage(
      value, // Define a página desejada
      duration: duration, // Define a duração da animação
      curve: curve, // Define a curva da animação
    );
    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }
}
