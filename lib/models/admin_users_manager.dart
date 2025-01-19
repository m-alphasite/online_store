import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/user_manager.dart';
import 'package:online_store/models/user.dart';

class AdminUsersManager extends ChangeNotifier {
  final List<User> _adminUsers = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription?
      _subscription; // Torna a assinatura opcional para evitar problemas

  List<User> get adminUsers => _adminUsers;

  /// Atualiza os usuários quando o administrador está habilitado
  void updateUser(UserManager userManager) {
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      _stopListening(); // Para de escutar se o usuário não for mais admin
    }
  }

  /// Escuta os dados de usuários no Firestore em tempo real
  void _listenToUsers() {
    _subscription = firestore.collection('users').snapshots().listen(
      (snapshot) {
        _adminUsers.clear(); // Limpa a lista antes de adicionar novos dados
        _adminUsers.addAll(
          snapshot.docs.map((doc) =>
              User.fromSnapshot(doc)), // Converte os documentos em usuários
        );

        // Ordena a lista de usuários em ordem alfabética por nome
        _adminUsers.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );

        notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
      },
      onError: (error) {
        debugPrint('Erro ao escutar usuários: $error'); // Tratamento de erro
      },
    );
  }

  /// Para de escutar o Firestore para evitar vazamentos de memória
  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Remove um usuário da lista
  void deleteUser(User user) {
    firestore
        .collection('users')
        .doc(user.id)
        .delete(); // Remove o usuário do Firestore
    _adminUsers.remove(user);

    // Atualiza a lista de usuários após a remoção
    _adminUsers.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    notifyListeners();
  }

  /// Retorna uma lista de nomes para o índice alfabético
  List<String> get names => _adminUsers.map((user) => user.name).toList();

  @override
  void dispose() {
    _stopListening(); // Cancela a assinatura ao descartar o objeto
    super.dispose();
  }
}
