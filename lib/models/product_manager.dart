import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore do Firebase para interagir com o banco de dados
import 'package:flutter/material.dart'; // Importa o pacote Flutter para construir a interface do usuário
import 'package:online_store/models/product.dart'; // Importa o modelo Product

// Classe ProductManager que estende ChangeNotifier para gerenciar os produtos
class ProductManager extends ChangeNotifier {
  // Construtor que chama o método para carregar todos os produtos
  ProductManager() {
    _loadAllProducts();
  }

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Instância do Firestore

  List<Product> allProducts = []; // Lista que armazena todos os produtos

  String? _search = ''; // String para armazenar o termo de busca

  String? get search => _search; // Getter para o termo de busca

  set search(String? value) {
    _search = value; // Define o valor do termo de busca
    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }

  List<Product> get filteredProducts {
    if (_search == null || _search!.isEmpty) {
      return allProducts; // Retorna todos os produtos se não houver termo de busca
    } else {
      return allProducts
          .where(
            (p) => p.name.toLowerCase().contains(_search!.toLowerCase()),
          )
          .toList(); // Retorna os produtos que correspondem ao termo de busca
    }
  }

  // Método para carregar todos os produtos do Firestore
  Future<void> _loadAllProducts() async {
    try {
      final QuerySnapshot snapProduct = await firestore
          .collection('products')
          .get(); // Consulta a coleção de produtos

      allProducts = snapProduct.docs
          .map((doc) => Product.fromDocument(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList(); // Mapeia os documentos para objetos Product

      notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
    } catch (e) {
      // Tratar qualquer erro que possa ocorrer durante a consulta ao Firestore
      print("Erro ao carregar produtos: $e");
    }
  }

  // Função para encontrar um produto pelo ID
  Product? findProductById(String id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null; // Retorna null se o produto não for encontrado
    }
  }
}
