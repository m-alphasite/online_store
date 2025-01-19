import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:online_store/common/custom_drawer/custom_drawer.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/admin_users_manager.dart';
import 'package:provider/provider.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(), // Adiciona o CustomDrawer
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            color: Colors.white,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: MinhasCores.rosa_1, // Cor de fundo da AppBar
        title: const Text(
          'Lista de Usuários',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: MinhasCores.rosa_1, // Cor de fundo da tela
      body: SafeArea(
        child: Consumer<AdminUsersManager>(
          builder: (_, adminUsersManager, __) {
            // Se a lista de usuários estiver vazia, exibe uma mensagem
            if (adminUsersManager.adminUsers.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum usuário encontrado.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            // Lista de nomes dos usuários
            final userNames = adminUsersManager.adminUsers
                .map<String>((user) => user.name)
                .toList();

            // Índice alfabético
            final strList = userNames
                .map((name) => name[0].toUpperCase())
                .toSet()
                .toList()
              ..sort();

            return Column(
              children: [
                // Lista de usuários com índice alfabético
                Expanded(
                  child: AlphabetListScrollView(
                    itemBuilder: (_, index) {
                      final user = adminUsersManager.adminUsers[index];
                      return ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.white,
                          onPressed: () {
                            adminUsersManager.deleteUser(user);
                          },
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          user.email,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                    indexedHeight: (index) => 80, // Altura de cada item
                    strList: strList, // Índice alfabético
                    showPreview: true, // Exibe o índice alfabético
                    highlightTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
