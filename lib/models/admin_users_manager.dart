import 'package:faker/faker.dart';
import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário
import 'package:online_store/models/user_manager.dart'; // Importa o gerenciador de usuários

class AdminUsersManager extends ChangeNotifier {
  List<Map<String, String>> _adminUsers = [];

  List<Map<String, String>> get adminUsers => _adminUsers;

  void updateUser(UserManager userManager) {
    if (userManager.adminEnabled) {
      _listenToUsers();
    }
  }

  void _listenToUsers() {
    final fake = Faker();

    for (int i = 0; i < 1000; i++) {
      final user = {
        'name': fake.person.name(),
        'email': fake.internet.email(),
      };
      _adminUsers.add(user);
    }

    // Ordena a lista de usuários em ordem alfabética por nome
    _adminUsers.sort(
        (a, b) => a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()));

    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }

  void deleteUser(Map<String, String> user) {
    _adminUsers.remove(user);

    // Ordena a lista de usuários em ordem alfabética por nome
    _adminUsers.sort(
        (a, b) => a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase()));

    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }

  List<String> get names => _adminUsers.map((e) => e['name']!).toList();
}
