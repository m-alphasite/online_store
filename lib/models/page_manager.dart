import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário

// Classe PageManager que gerencia a navegação entre páginas
class PageManager {
  // Construtor que inicializa o PageManager com um PageController
  PageManager(this._pageController);

  PageController _pageController; // Controlador para a navegação entre páginas

  int page = 0; // Índice da página atual

  // Método para definir a página atual
  void setPage(int value) {
    if (value == page)
      return; // Se a nova página for igual à página atual, retorna sem fazer nada
    page = value; // Atualiza o índice da página atual
    _pageController.jumpToPage(value); // Navega para a nova página sem animação
  }
}
