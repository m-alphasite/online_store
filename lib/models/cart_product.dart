import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore do Firebase para interagir com o banco de dados
import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/models/item_size.dart'; // Importa o modelo ItemSize
import 'package:online_store/models/product.dart'; // Importa o modelo Product

// Classe CartProduct que representa um produto no carrinho de compras
class CartProduct extends ChangeNotifier {
  // Extende ChangeNotifier para notificar os listeners

  // Construtor que cria um CartProduct a partir de um Product
  CartProduct.fromProduct(this.product) {
    id = ''; // Inicializa o ID com uma string vazia
    productId = product.id; // Obtém o ID do produto
    quantity = 1; // Inicializa a quantidade com 1
    size = product.selectedSize.name; // Obtém o tamanho selecionado do produto
  }

  // Construtor que cria um CartProduct a partir de um DocumentSnapshot do Firestore
  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id; // Inicializa o ID a partir do documento
    final data = document.data()
        as Map<String, dynamic>; // Converte os dados do documento para um Map
    productId = data['pid'] as String; // Obtém o ID do produto no carrinho
    quantity =
        data['quantity'] as int; // Obtém a quantidade do produto no carrinho
    size = data['size'] as String; // Obtém o tamanho do produto no carrinho

    // Inicializa o produto como um objeto Product vazio antes de carregar do Firestore
    product = Product(
      id: '',
      name: '',
      description: '',
      images: [],
      sizes: [],
    );

    // Obtém o produto do Firestore e converte para Product
    firestore.doc('products/$productId').get().then((doc) {
      product = Product.fromDocument(doc);
      notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
    });
  }

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Instância do Firestore

  late String id; // ID do produto no Firestore
  late String productId; // ID do produto
  late int quantity; // Quantidade do produto no carrinho
  late String size; // Tamanho do produto no carrinho

  late Product product; // Referência ao produto

  // Getter que retorna o tamanho do produto
  ItemSize? get itemSize {
    return product
        .findSize(size); // Busca o tamanho do produto na lista de tamanhos
  }

  // Getter que retorna o preço unitário do produto
  num get unitPrice {
    final itemSize = product
        .findSize(size); // Busca o tamanho do produto na lista de tamanhos
    return itemSize?.price ??
        0.0; // Retorna o preço do tamanho, ou 0.0 se o tamanho não for encontrado
  }

  // Getter que retorna o preço total do produto (quantidade * preço unitário)
  num get totalPrice {
    return unitPrice * quantity;
  }

  // Converte o CartProduct para um Map
  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId, // ID do produto no carrinho
      'quantity': quantity, // Quantidade do produto no carrinho
      'size': size, // Tamanho do produto no carrinho
    };
  }

  // Verifica se o produto pode ser empilhado
  bool stackable(Product product) {
    return product.id == productId &&
        product.selectedSize.name ==
            size; // Verifica se o produto tem o mesmo ID e tamanho
  }

  // Incrementa a quantidade do produto no carrinho
  void increment() {
    quantity++;
    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }

  // Decrementa a quantidade do produto no carrinho
  void decrement() {
    quantity--;
    notifyListeners(); // Notifica os listeners para atualizar a interface do usuário
  }

  // Verifica se o estoque é maior ou igual à quantidade
  bool get hasStock {
    final itemSize = this.itemSize; // Obtém o tamanho do produto
    if (itemSize == null) return false; // Verifica se o tamanho é nulo
    return itemSize.stock >=
        quantity; // Verifica se o estoque é maior ou igual à quantidade
  }
}
