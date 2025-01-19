import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o pacote Cloud Firestore
import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/models/item_size.dart'; // Importa o modelo de tamanho

class Product extends ChangeNotifier {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.sizes,
  });

  Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;
    name = doc.data()?['name'] ?? ''; // Verifica e inicializa o nome
    description =
        doc.data()?['description'] ?? ''; // Verifica e inicializa a descrição
    images = List<String>.from(doc.data()?['images'] ?? []);
    sizes = (doc.data()?['sizes'] as List<dynamic>? ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();

    // Inicializa o tamanho selecionado com o primeiro disponível ou cria um padrão vazio
    _selectedSize = sizes.isNotEmpty
        ? sizes.first
        : ItemSize(
            name: '',
            price: 0,
            stock: 0,
          );
  }

  late String id;
  late String name;
  late String description;
  List<String> images = [];
  List<ItemSize> sizes = [];

  late ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  /// Retorna o estoque total do produto
  int get totalStock {
    return sizes.fold(0, (total, size) => total + size.stock);
  }

  /// Verifica se há estoque no produto
  bool get hasStock => totalStock > 0;

  /// Retorna o preço base mais baixo entre os tamanhos com estoque
  num get basePrice {
    final pricesWithStock =
        sizes.where((size) => size.hasStock).map((size) => size.price);
    return pricesWithStock.isNotEmpty
        ? pricesWithStock.reduce((a, b) => a < b ? a : b)
        : 0;
  }

  /// Busca um tamanho específico pelo nome
  ItemSize? findSize(String name) {
    try {
      return sizes.firstWhere((size) => size.name == name);
    } catch (e) {
      return null;
    }
  }
}
