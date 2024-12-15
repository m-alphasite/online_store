import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore do Firebase para interagir com o banco de dados
import 'package:flutter/foundation.dart'; // Importa o foundation.dart para utilizar funcionalidades do Flutter

// Classe User que representa um usuário
class User {
  User({
    this.id = '', // Inicializa o ID com uma string vazia
    required this.email, // Email do usuário
    required this.password, // Senha do usuário
    required this.name, // Nome do usuário
    this.confirmPassword =
        '', // Inicializa o campo confirmPassword com uma string vazia
    this.admin = false, // Inicializa o campo admin com false
  });

  // Factory para criar um objeto User a partir de um snapshot do Firestore
  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return User(
      id: snapshot.id, // Obtém o ID do snapshot
      email: data['email'] as String, // Obtém o email do snapshot
      name: data['name'] as String, // Obtém o nome do snapshot
      password: '', // Inicializa a senha com uma string vazia
      admin: data['admin'] ??
          false, // Verifica se o campo admin existe e o obtém, caso contrário inicializa com false
    );
  }

  String id; // ID do usuário
  String name; // Nome do usuário
  String email; // Email do usuário
  String password; // Senha do usuário
  String confirmPassword; // Confirmação da senha
  bool admin; // Indica se o usuário é admin

  // Referência ao documento Firestore do usuário
  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc("users/$id");

  // Getter para a referência ao carrinho de compras do usuário
  CollectionReference get cartReference => firestoreRef.collection("cart");

  // Método para salvar os dados do usuário no Firestore
  Future<void> saveData() async {
    try {
      await firestoreRef.set(toMap());
    } catch (e) {
      debugPrint(
          'Error saving user data: $e'); // Imprime uma mensagem de erro se a operação falhar
    }
  }

  // Método para converter o objeto User em um mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name, // Adiciona o nome ao mapa
      'email': email, // Adiciona o email ao mapa
      'admin': admin, // Adiciona o status de admin ao mapa
    };
  }

  // Método para validar se a senha e a confirmação da senha são iguais
  bool validatePassword() {
    return password == confirmPassword;
  }
}
