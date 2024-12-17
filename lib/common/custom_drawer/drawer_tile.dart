import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa o arquivo de cores personalizadas
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
    // Observa a página atual gerenciada por PageManager
    final int curPage = context.watch<PageManager>().page;

    return InkWell(
      onTap: () {
        // Define a página atual quando o tile é clicado
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60, // Define a altura do tile
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ), // Define o padding do ícone
              child: Icon(
                icon, // Ícone do tile
                size: 32, // Tamanho do ícone
                color: curPage == page
                    ? MinhasCores
                        .rosa_3 // Cor do ícone se estiver na página atual
                    : const Color.fromARGB(255, 255, 255,
                        255), // Cor do ícone se não estiver na página atual
              ),
            ),
            Text(
              title, // Título do tile
              style: TextStyle(
                fontSize: 16, // Tamanho do texto
                color: curPage == page
                    ? MinhasCores
                        .rosa_3 // Cor do texto se estiver na página atual
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
