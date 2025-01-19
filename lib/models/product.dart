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
  });

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
  }

  late String id;
  late String name;
  late String description;
  List<String> images = [];
  List<ItemSize> sizes = [];

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
  num get basePrice {
    final pricesWithStock =
        sizes.where((size) => size.hasStock).map((size) => size.price);
    return pricesWithStock.isNotEmpty
        ? pricesWithStock.reduce((a, b) => a < b ? a : b)
        : 0;
  }

  /// Busca um tamanho pelo nome
  ItemSize? findSize(String name) {
    try {
      return sizes.firstWhere((size) => size.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Atualiza as propriedades do produto
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
    notifyListeners();
  }

  /// Adiciona um tamanho (com validação para evitar duplicados)
  void addSize(ItemSize size) {
    if (!sizes.any((s) => s.name == size.name)) {
      sizes.add(size);
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
    notifyListeners();
  }

  /// Valida os tamanhos antes de salvar
  bool validateSizes() {
    for (final size in sizes) {
      if (size.name.isEmpty || size.price <= 0 || size.stock < 0) {
        debugPrint('Erro: Tamanho inválido - $size');
        return false;
      }
    }
    return true;
  }

  /// Salva o produto no Firestore (com validação)
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
    };

    try {
      final docRef = FirebaseFirestore.instance.collection('products').doc(id);
      await docRef.set(data, SetOptions(merge: true));
      debugPrint('Produto "$name" salvo com sucesso!');
    } catch (e) {
      debugPrint('Erro ao salvar o produto: $e');
    }
  }
}
