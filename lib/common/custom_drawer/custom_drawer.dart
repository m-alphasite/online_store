import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/custom_drawer_header.dart'; // Importa o cabeçalho personalizado do drawer
import 'package:online_store/common/custom_drawer/drawer_tile.dart'; // Importa os tiles do drawer
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/user_manager.dart';
import 'package:provider/provider.dart'; // Importa as cores personalizadas

// Classe CustomDrawer que estende StatelessWidget para criar um drawer personalizado
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          // Define um fundo gradiente para o container do drawer
          gradient: LinearGradient(
            colors: [
              MinhasCores.rosa_2, // Cor do gradiente (rosa 2)
              MinhasCores.rosa_2, // Cor do gradiente (rosa 2)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            CustomDrawerHeader(), // Adiciona o cabeçalho personalizado do drawer
            DrawerTile(
              icon: Icons.home,
              title: 'Inicio',
              page: 0,
            ), // Adiciona um tile para a página inicial
            DrawerTile(
              icon: Icons.list,
              title: 'Produtos',
              page: 1,
            ), // Adiciona um tile para a página de produtos
            if (!(context.watch<UserManager>().adminEnabled))
              DrawerTile(
                icon: Icons.playlist_add_check,
                title: 'Meus Pedidos',
                page: 2,
              ), // Adiciona um tile para a página de pedidos
            DrawerTile(
              icon: Icons.location_on,
              title: 'Lojas',
              page: 3,
            ), // Adiciona um tile para a página de lojas
            Consumer<UserManager>(
              builder: (_, userManager, __) {
                if (userManager.adminEnabled) {
                  return Column(
                    children: [
                      Divider(),
                      DrawerTile(
                        icon: Icons.people,
                        title: 'Usuários',
                        page: 4, // Página de usuários
                      ),
                      DrawerTile(
                        icon: Icons.list_alt,
                        title: 'Pedidos',
                        page: 5, // Página de pedidos
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
