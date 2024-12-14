import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o pacote Cloud Firestore
import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/models/item_size.dart'; // Importa o modelo de tamanho

class Product extends ChangeNotifier {
  // Classe Product que estende ChangeNotifier para gerenciar as mudanças de estado

  // Construtor padrão
  Product({
    required this.id, // ID do produto
    required this.name, // Nome do produto
    required this.description, // Descrição do produto
    required this.images, // Lista de URLs de imagens do produto
    required this.sizes, // Lista de tamanhos do produto
  });

  // Construtor a partir de um DocumentSnapshot
  Product.fromDocument(DocumentSnapshot doc) {
    id =
        doc.id; // Inicializa o ID do produto com o ID do documento do Firestore
    name = doc['name']; // Inicializa o nome do produto com o valor do documento
    description = doc['description']; // Inicializa a descrição do produto

    // Inicializa a lista de URLs de imagens com os valores do documento
    images = List<String>.from(doc['images'] as List<dynamic>);

    // Verifica se o documento contém dados e se há uma chave 'sizes'
    if (doc.data() != null &&
        (doc.data() as Map<String, dynamic>).containsKey('sizes')) {
      // Inicializa a lista de tamanhos do produto a partir dos dados do documento
      sizes = (doc['sizes'] as List<dynamic>)
          .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
          .toList();
    } else {
      sizes =
          []; // Inicializa a lista de tamanhos como vazia se não houver dados
    }

    // Inicializa o tamanho selecionado com o primeiro tamanho disponível ou um tamanho vazio
    _selectedSize = sizes.isNotEmpty
        ? sizes.first
        : ItemSize(
            name: '', // Nome vazio
            price: 0, // Preço zero
            stock: 0, // Estoque zero
          );
  }

  late String id; // ID do produto
  late String name; // Nome do produto
  late String description; // Descrição do produto
  List<String> images = []; // Lista de URLs de imagens do produto
  List<ItemSize> sizes = []; // Lista de tamanhos do produto

  late ItemSize _selectedSize; // Tamanho selecionado
  ItemSize get selectedSize =>
      _selectedSize; // Getter para o tamanho selecionado

  set selectedSize(ItemSize value) {
    _selectedSize = value; // Atualiza o tamanho selecionado
    notifyListeners(); // Notifica os listeners que o tamanho selecionado foi atualizado
  }

  int get totalStock {
    int stock = 0; // Inicializa o estoque total como zero
    for (final size in sizes) {
      stock += size.stock; // Soma o estoque de cada tamanho ao estoque total
    }
    return stock; // Retorna o estoque total
  }

  bool get hasStock {
    return totalStock >
        0; // Retorna true se houver estoque, false caso contrário
  }

  ItemSize? findSize(String name) {
    // Método para encontrar um tamanho pelo nome
    try {
      return sizes.firstWhere((size) =>
          size.name ==
          name); // Retorna o primeiro tamanho que corresponde ao nome
    } catch (e) {
      return null; // Retorna null se o tamanho não for encontrado
    }
  }
}
