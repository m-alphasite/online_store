import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/item_size.dart';

class Product extends ChangeNotifier {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.sizes,
  }) {
    _selectedSize =
        sizes.isNotEmpty ? sizes.first : ItemSize(name: '', price: 0, stock: 0);
    _updateBasePrice();
  }

  /// Construtor a partir de um documento do Firestore
  Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;
    name = doc.data()?['name'] ?? '';
    description = doc.data()?['description'] ?? '';
    images = List<String>.from(doc.data()?['images'] ?? []);
    sizes = (doc.data()?['sizes'] as List<dynamic>? ?? [])
        .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
        .toList();

    _selectedSize =
        sizes.isNotEmpty ? sizes.first : ItemSize(name: '', price: 0, stock: 0);
    _updateBasePrice(); // Garante que _basePrice seja inicializado corretamente
  }

  late String id;
  late String name;
  late String description;
  List<String> images = [];
  List<ItemSize> sizes = [];

  List<dynamic> newImages = [];

  /// Tamanho selecionado atualmente
  late ItemSize _selectedSize;
  ItemSize get selectedSize => _selectedSize;
  set selectedSize(ItemSize value) {
    _selectedSize = value;
    notifyListeners();
  }

  /// Estoque total do produto
  int get totalStock => sizes.fold(0, (total, size) => total + size.stock);

  /// Verifica se o produto tem estoque
  bool get hasStock => totalStock > 0;

  /// Preço base (menor preço entre tamanhos com estoque)
  late num _basePrice = 0;

  num get basePrice => _basePrice;
  set basePrice(num value) {
    _basePrice = value;
    notifyListeners();
  }

  /// Atualiza `_basePrice` com o menor preço disponível
  void _updateBasePrice() {
    final pricesWithStock = sizes
        .where((size) => size.stock > 0)
        .map((size) => size.price)
        .toList();
    _basePrice = pricesWithStock.isNotEmpty
        ? pricesWithStock.reduce((a, b) => a < b ? a : b)
        : 0;
  }

  /// Obtém o menor preço de um tamanho com estoque de forma assíncrona
  Future<num> get basePriceAsync async {
    final pricesWithStock =
        sizes.where((size) => size.hasStock).map((size) => size.price).toList();
    return pricesWithStock.isNotEmpty
        ? pricesWithStock.reduce((a, b) => a < b ? a : b)
        : 0;
  }

  /// Busca um tamanho pelo nome
  ItemSize? findSize(String name) {
    return sizes.firstWhere((size) => size.name == name,
        orElse: () => ItemSize(name: '', price: 0, stock: 0));
  }

  /// Atualiza os atributos do produto e notifica ouvintes
  void updateProduct({
    String? newName,
    String? newDescription,
    List<String>? newImages,
    List<ItemSize>? newSizes,
  }) {
    name = newName ?? name;
    description = newDescription ?? description;
    images = newImages ?? images;
    sizes = newSizes ?? sizes;
    _updateBasePrice();
    notifyListeners();
  }

  /// Adiciona um tamanho ao produto, garantindo que não haja duplicatas
  void addSize(ItemSize size) {
    if (!sizes.any((s) => s.name == size.name)) {
      sizes.add(size);
      _updateBasePrice();
      notifyListeners();
    } else {
      debugPrint('Tamanho "${size.name}" já existe. Não foi adicionado.');
    }
  }

  /// Remove um tamanho e atualiza o tamanho selecionado, se necessário
  void removeSize(ItemSize size) {
    sizes.remove(size);
    if (_selectedSize == size && sizes.isNotEmpty) {
      _selectedSize = sizes.first;
    }
    _updateBasePrice();
    notifyListeners();
  }

  /// Valida se os tamanhos do produto estão corretos
  bool validateSizes() {
    for (final size in sizes) {
      if (size.name.isEmpty || size.price <= 0 || size.stock < 0) {
        debugPrint('Erro: Tamanho inválido - ${size.toMap()}');
        return false;
      }
    }
    return true;
  }

  /// Salva o produto no Firestore, evitando sobrescritas desnecessárias
  Future<void> saveToFirestore() async {
    if (!validateSizes()) {
      debugPrint('Erro: Existem tamanhos inválidos. Produto não salvo.');
      return;
    }

    final data = {
      'name': name,
      'description': description,
      'images': images,
      'sizes': sizes.map((size) => size.toMap()).toList(),
      'basePrice': basePrice,
    };

    try {
      if (id.isEmpty) {
        // Criando um novo documento
        final docRef =
            await FirebaseFirestore.instance.collection('products').add(data);
        id = docRef.id; // Atribui o ID gerado ao produto
        debugPrint('Novo produto "$name" salvo com sucesso com ID: $id');
      } else {
        // Atualizando um produto existente
        final docRef =
            FirebaseFirestore.instance.collection('products').doc(id);
        await docRef.set(data, SetOptions(merge: true));
        debugPrint('Produto "$name" atualizado com sucesso!');
      }
    } catch (e) {
      debugPrint('Erro ao salvar o produto: $e');
    }
  }

  /// Retorna uma cópia do produto
  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((size) => size.clone()).toList(),
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, sizes: $sizes}';
  }
}
