import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:online_store/models/item_size.dart';
import 'dart:io';
import 'package:uuid/uuid.dart'; // Para manipulação de arquivos locais

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

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Corrigindo o tipo de 'StorageReference' para 'Reference'
  Reference get storageRef => storage.ref().child('products/$id');

  late String id;
  late String name;
  late String description;
  List<String> images = [];
  List<ItemSize> sizes = [];

  List<dynamic> newImages =
      []; // Lista de imagens novas que precisam ser enviadas

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

  /// Função para enviar as novas imagens para o Firebase Storage
  Future<void> uploadImages() async {
    final List<String> updatedImages = [];

    // Verificando as novas imagens e enviando para o Firebase Storage
    for (final newImage in newImages) {
      // Verificando se a imagem é nova e precisa ser enviada para o Firebase Storage
      if (images.contains(newImage)) {
        // Imagem já existe, mantemos a URL existente
        updatedImages.add(newImage);
      } else {
        try {
          print('Enviando imagem para o Firebase Storage...');
          final url = await uploadImageToStorage(newImage);
          updatedImages.add(url); // Adiciona a nova URL de imagem
          print('Imagem enviada com sucesso: $url');
        } catch (e) {
          print('Erro ao enviar imagem: $e');
        }
      }
    }

    // Atualiza as imagens no Firestore
    images = updatedImages;

    // Notifica os ouvintes sobre a mudança
    notifyListeners();
  }

  /// Envia uma nova imagem para o Firebase Storage e retorna a URL
  Future<String> uploadImageToStorage(String imagePath) async {
    final storageRef = storage
        .ref()
        .child('products/$id/${DateTime.now().millisecondsSinceEpoch}');
    final file = File(imagePath);

    try {
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});
      print('Upload concluído. Obtendo a URL...');
      return await snapshot.ref.getDownloadURL(); // Retorna a URL da imagem
    } catch (e) {
      print('Erro durante o upload da imagem: $e');
      rethrow; // Re-lança o erro para ser tratado fora da função
    }
  }

  /// Salva o produto no Firestore, evitando sobrescritas desnecessárias
  Future<void> saveToFirestore() async {
    await uploadImages(); // Chama a função para upload das imagens

    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'images': images, // Imagens finais
      'sizes': exportSizeList(),
    };

    try {
      if (id.isEmpty) {
        final doc = await firestore.collection('products').add(data);
        id = doc.id;
      } else {
        await firestore.collection('products').doc(id).update(data);
      }
    } catch (e) {
      debugPrint('Erro ao salvar o produto: $e');
    }
  }

  /// Converte os tamanhos em uma lista de Map<String, dynamic> para exportação
  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
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
