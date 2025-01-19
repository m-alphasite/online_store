import 'package:flutter/material.dart';
import 'package:online_store/common/custom_drawer/custom_drawer_header.dart';
import 'package:online_store/common/custom_drawer/drawer_tile.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<UserManager>().adminEnabled;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MinhasCores.rosa_2,
              MinhasCores.rosa_2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            CustomDrawerHeader(),
            DrawerTile(
              icon: Icons.home,
              title: 'Inicio',
              page: 0, // Página inicial (índice 0)
            ),
            DrawerTile(
              icon: Icons.list,
              title: 'Produtos',
              page: 1, // Página de produtos (índice 1)
            ),
            if (!isAdmin)
              DrawerTile(
                icon: Icons.playlist_add_check,
                title: 'Meus Pedidos',
                page: 2, // Página de pedidos (índice 2)
              ),
            DrawerTile(
              icon: Icons.location_on,
              title: 'Lojas',
              page: isAdmin ? 4 : 3, // Página de lojas
            ),
            if (isAdmin)
              Column(
                children: [
                  const Divider(),
                  DrawerTile(
                    icon: Icons.people,
                    title: 'Usuários',
                    page: 2, // Página de usuários (índice 2 para admin)
                  ),
                  DrawerTile(
                    icon: Icons.list_alt,
                    title: 'Pedidos',
                    page: 3, // Página de pedidos admin (índice 3)
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
