import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/admin_users_manager.dart';
import 'package:provider/provider.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinhasCores.rosa_1,
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager, __) {
          return AlphabetListScrollView(
            itemBuilder: (_, index) => ListTile(
              leading: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.white,
                onPressed: () {
                  adminUsersManager
                      .deleteUser(adminUsersManager.adminUsers[index]);
                },
              ),
              title: Text(
                adminUsersManager.adminUsers[index]['name']!,
                style: const TextStyle(
                    color: Colors.white), // Define a cor da letra como branca
              ),
              subtitle: Text(
                adminUsersManager.adminUsers[index]['email']!,
                style: const TextStyle(
                    color: Colors.white), // Define a cor da letra como branca
              ),
            ),
            indexedHeight: (index) => 80,
            strList: adminUsersManager.names
                .map((name) => name[0].toUpperCase())
                .toList(),
            showPreview: true, // Habilita o preview
            highlightTextStyle: const TextStyle(
                fontSize: 20,
                color: Colors
                    .white), // Define a cor da letra destacada como branca
          );
        },
      ),
    );
  }
}
