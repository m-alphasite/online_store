import 'package:flutter/material.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.page,
  });

  final IconData icon;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    // Observa a página atual gerenciada pelo PageManager
    final int curPage = context.watch<PageManager>().page;

    return InkWell(
      onTap: () {
        // Fecha o Drawer ao clicar
        Navigator.of(context).pop();
        // Atualiza a página no PageManager
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60, // Altura do tile
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              child: Icon(
                icon,
                size: 32,
                color: curPage == page
                    ? MinhasCores.rosa_3
                    : const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: curPage == page
                    ? MinhasCores.rosa_3
                    : const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
