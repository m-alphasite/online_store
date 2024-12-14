import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário

class PageManager extends ChangeNotifier {
  // Cria uma classe que extende ChangeNotifier para gerenciar a página atual
  PageManager(this._pageController); // Construtor que recebe um PageController

  final PageController _pageController; // Controlador de páginas
  int page = 0;

  void setPage(int value, // Define a página atual
      {Duration duration =
          const Duration(milliseconds: 300), // Define a duração da animação
      Curve curve = Curves.ease}) {
    // Define a curva da animação
    if (value == page)
      return; // Se a página atual for igual à página desejada, não faça nada

    page = value; // Define a página atual
    _pageController.animateToPage(
      // Anima a página atual
      value, // Define a página desejada
      duration: duration, // Define a duração da animação
      curve: curve, // Define a curva da animação
    );
    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }
}
