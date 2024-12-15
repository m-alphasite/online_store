import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore do Firebase para interagir com o banco de dados
import 'package:firebase_auth/firebase_auth.dart'; // Importa o FirebaseAuth para autenticação de usuário
import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário
import 'package:online_store/helpers/firebase_errors.dart'; // Importa o helper para tratar erros do Firebase
import 'package:online_store/models/user.dart'
    as user_model; // Importa o modelo User com alias para evitar conflitos

// Classe UserManager que estende ChangeNotifier para gerenciar o usuário
class UserManager extends ChangeNotifier {
  // Construtor que chama o método para carregar o usuário atual
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance; // Instância do FirebaseAuth
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Instância do Firestore

  user_model.User? _user; // Usuário atual

  user_model.User? get user => _user; // Getter para o usuário atual

  bool _loading = false; // Variável para indicar o estado de carregamento
  bool get loading => _loading; // Getter para o estado de carregamento

  bool get isLoggedIn => _user != null; // Verifica se o usuário está logado

  // Método para fazer login
  Future<void> signIn({
    required String email, // Email do usuário
    required String password, // Senha do usuário
    required Function(String) onFail, // Função de callback para falha
    required Function(User) onSuccess, // Função de callback para sucesso
  }) async {
    loading = true; // Define o estado de carregamento como verdadeiro

    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ); // Tenta fazer login com email e senha

      _user = user_model.User(
        id: result.user!.uid,
        email: result.user!.email!,
        password: '',
        name: '',
      ); // Cria um objeto User com os dados do usuário logado

      final DocumentSnapshot doc = await firestore
          .collection('users')
          .doc(_user!.id)
          .get(); // Busca os dados do usuário no Firestore

      if (doc.exists) {
        _user = user_model.User.fromSnapshot(
            doc); // Atualiza o objeto User com os dados do Firestore
        await _checkAdminStatus(
            result.user!); // Verifica e exibe o status de admin
        onSuccess(result.user!); // Chama a função de sucesso
      } else {
        onFail(
            'Usuário não encontrado no banco de dados.'); // Chama a função de falha se o usuário não for encontrado
      }
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code)); // Trata erros de autenticação
    } finally {
      loading = false; // Define o estado de carregamento como falso
      notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
    }
  }

  // Método para registrar um novo usuário
  Future<void> signUp({
    required String email, // Email do novo usuário
    required String password, // Senha do novo usuário
    required String name, // Nome do novo usuário
    required Function(String) onFail, // Função de callback para falha
    required Function(User) onSuccess, // Função de callback para sucesso
  }) async {
    loading = true; // Define o estado de carregamento como verdadeiro

    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ); // Tenta registrar um novo usuário com email e senha

      _user = user_model.User(
        id: result.user!.uid,
        email: email,
        password: password,
        name: name,
      ); // Cria um objeto User com os dados do novo usuário

      await _user!.saveData(); // Salva os dados do usuário no Firestore
      await _checkAdminStatus(
          result.user!); // Verifica e exibe o status de admin
      onSuccess(result.user!); // Chama a função de sucesso
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code)); // Trata erros de autenticação
    } finally {
      loading = false; // Define o estado de carregamento como falso
      notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
    }
  }

  // Método para fazer logout
  void signOut() {
    auth.signOut(); // Faz logout no FirebaseAuth
    _user = null; // Define o usuário atual como null
    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }

  // Setter para o estado de carregamento
  set loading(bool value) {
    _loading = value;
    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }

  // Método para carregar o usuário atual
  Future<void> _loadCurrentUser() async {
    final User? currentUser = auth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot doc = await firestore
          .collection('users')
          .doc(currentUser.uid)
          .get(); // Busca os dados do usuário no Firestore

      if (doc.exists) {
        _user = user_model.User.fromSnapshot(
            doc); // Atualiza o objeto User com os dados do Firestore
        await _checkAdminStatus(
            currentUser); // Verifica e exibe o status de admin
        notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
      }
    }
  }

  // Método para verificar e exibir o status de administrador
  Future<void> _checkAdminStatus(User user) async {
    final docAdmin = await firestore.collection('admins').doc(user.uid).get();
    if (docAdmin.exists) {
      _user!.admin =
          true; // Define o usuário como admin se encontrado na coleção de admins
    }
    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }

  bool get adminEnabled => user != null && user!.admin;
}
