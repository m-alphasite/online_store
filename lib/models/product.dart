import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o pacote Cloud Firestore
import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/models/item_size.dart'; // Importa o modelo de tamanho

class Product extends ChangeNotifier {
  // Construtor padrão
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.sizes,
  });

  // Construtor a partir de um DocumentSnapshot
  Product.fromDocument(DocumentSnapshot doc) {
    // Construtor
    id = doc.id; // ID do produto
    name = doc['name']; // Nome do produto
    description = doc['description']; // Descrição do produto
    images =
        List<String>.from(doc['images'] as List<dynamic>); // Imagens do produto

    if (doc.data() != null &&
        (doc.data() as Map<String, dynamic>).containsKey('sizes')) {
      sizes = (doc['sizes'] as List<dynamic>)
          .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
          .toList();
    } else {
      sizes = [];
    }

    _selectedSize = sizes.isNotEmpty
        ? sizes.first
        : ItemSize(
            name: '',
            price: 0,
            stock: 0); // Inicia com o primeiro tamanho disponível
  }

  late String id; // ID do produto
  late String name; // Nome do produto
  late String description; // Descrição do produto
  List<String> images = []; // Imagens do produto
  List<ItemSize> sizes = []; // Tamanhos do produto

  late ItemSize _selectedSize; // Marca como 'late'
  ItemSize get selectedSize =>
      _selectedSize; // Getter para o tamanho selecionado

  set selectedSize(ItemSize value) {
    // Setter para o tamanho selecionado
    _selectedSize = value; // Atualiza o tamanho selecionado
    notifyListeners(); // Notifica os listeners que o produto foi atualizado
  }

  int get totalStock {
    // Total de estoque
    int stock = 0; // Estoque inicial
    for (final size in sizes) {
      // Percorre os tamanhos
      stock += size.stock; // Soma o estoque de cada tamanho
    }
    return stock; // Retorna o estoque total
  }

  bool get hasStock {
    // Verifica se o produto tem estoque
    return totalStock >
        0; // Retorna true se houver estoque, false caso contrário
  }

  ItemSize? findSize(String name) {
    // Encontra um tamanho pelo nome
    try {
      return sizes.firstWhere((size) =>
          size.name == name); // Encontra o primeiro tamanho que atende ao nome
    } catch (e) {
      return null; // Retorna null se não encontrar
    }
  }
}
