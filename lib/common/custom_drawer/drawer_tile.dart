import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário
import 'package:online_store/models/page_manager.dart'; // Importa o gerenciador de páginas
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciar o estado

// Classe DrawerTile que estende StatelessWidget para criar um tile personalizado no drawer
class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.icon, // Ícone do tile
    required this.title, // Título do tile
    required this.page, // Página associada ao tile
  });

  final IconData icon; // Declaração do ícone
  final String title; // Declaração do título
  final int page; // Declaração da página associada

  @override
  Widget build(BuildContext context) {
    final int curPage = context
        .watch<PageManager>()
        .page; // Observa a página atual gerenciada por PageManager

    return InkWell(
      onTap: () {
        context
            .read<PageManager>()
            .setPage(page); // Define a página atual quando o tile é clicado
      },
      child: SizedBox(
        height: 60, // Define a altura do tile
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 16), // Define o padding do ícone
              child: Icon(
                icon, // Ícone do tile
                size: 32, // Tamanho do ícone
                color: curPage == page
                    ? const Color.fromARGB(255, 120, 3,
                        216) // Cor do ícone se estiver na página atual
                    : const Color.fromARGB(255, 255, 255,
                        255), // Cor do ícone se não estiver na página atual
              ),
            ),
            Text(
              title, // Título do tile
              style: TextStyle(
                fontSize: 16, // Tamanho do texto
                color: curPage == page
                    ? const Color.fromARGB(255, 100, 5,
                        189) // Cor do texto se estiver na página atual
                    : const Color.fromARGB(255, 255, 255,
                        255), // Cor do texto se não estiver na página atual
              ),
            ),
          ],
        ),
      ),
    );
  }
}
