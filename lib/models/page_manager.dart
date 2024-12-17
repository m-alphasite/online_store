import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário

// Classe PageManager que gerencia a página atual
class PageManager extends ChangeNotifier {
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
    if (_pageController.hasClients) {
      // Verifica se o controlador está anexado a alguma visualização de rolagem
      if (value == page) {
        return; // Se a página atual for igual à página desejada, não faz nada
      }

      page = value; // Atualiza a página atual
      _pageController.animateToPage(
        value, // Define a página desejada
        duration: duration, // Define a duração da animação
        curve: curve, // Define a curva da animação
      );
      notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
    } else {
      // Adicionar um tratamento de erro ou log para ajudar na depuração
      print(
          'PageController não está anexado a nenhuma visualização de rolagem.');
    }
  }
}
