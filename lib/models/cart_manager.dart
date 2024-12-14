import 'package:cloud_firestore/cloud_firestore.dart'; // Importa o Firestore do Firebase para interagir com o banco de dados
import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/models/cart_product.dart'; // Importa o modelo de produto do carrinho
import 'package:online_store/models/product.dart'; // Importa o modelo Product
import 'package:online_store/models/user.dart'; // Importa o modelo User
import 'package:online_store/models/user_manager.dart'; // Importa o gerenciador de usuários

// Classe CartManager que gerencia os produtos no carrinho de compras
class CartManager extends ChangeNotifier {
  List<CartProduct> items = []; // Lista que armazena os itens no carrinho

  User? user; // Modelo de usuário

  num productsPrice = 0.0; // Preço total dos produtos

  // Função para atualizar o usuário
  void updateUser(UserManager userManager) {
    user = userManager.user; // Atualiza o modelo de usuário com o usuário atual
    items.clear(); // Limpa os itens do carrinho

    if (user != null) {
      _loadCartItems(); // Carrega os itens do carrinho do usuário
    }
  }

  // Função assíncrona para carregar os itens do carrinho
  Future<void> _loadCartItems() async {
    if (user != null) {
      final QuerySnapshot cartSnap = await user!.cartReference
          .get(); // Obtém os documentos da referência do carrinho do usuário
      items = cartSnap.docs
          .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdate))
          .toList(); // Mapeia os documentos para objetos CartProduct
      notifyListeners(); // Notifica os listeners após carregar os itens
    }
  }

  // Função para adicionar um produto ao carrinho
  void addToCart(Product product) {
    try {
      // Verifica se o produto já está no carrinho
      final existingProduct = items.firstWhere((p) => p.stackable(product));
      existingProduct
          .increment(); // Incrementa a quantidade usando o método increment
      _updateCartProduct(existingProduct); // Atualiza o produto no Firestore
    } catch (e) {
      // Se o produto não estiver no carrinho, adiciona uma nova instância
      final cartProduct = CartProduct.fromProduct(
          product); // Cria uma instância de CartProduct a partir do produto
      cartProduct.addListener(
          _onItemUpdate); // Adiciona um listener para atualizar o carrinho
      items.add(
          cartProduct); // Adiciona a instância de CartProduct à lista de itens
      user?.cartReference.add(cartProduct.toCartItemMap()).then((doc) {
        cartProduct.id = doc.id; // Adiciona o produto ao carrinho e define o id
        _updateCartProduct(cartProduct); // Atualiza o produto no Firestore
      });
    }
    notifyListeners(); // Notifica os listeners após adicionar um item
  }

  // Função chamada quando um item é atualizado
  void _onItemUpdate() {
    productsPrice = 0.0;

    final itemsToRemove = <CartProduct>[];
    for (final cartProduct in items) {
      if (cartProduct.quantity == 0) {
        itemsToRemove.add(cartProduct); // Adiciona o produto à lista de remoção
        continue; // Pula para a próxima iteração
      } else {
        productsPrice += cartProduct.totalPrice; // Calcula o preço total
        _updateCartProduct(cartProduct); // Atualiza o produto no carrinho
      }
      notifyListeners();
    }

    // Remove os itens fora da iteração para evitar ConcurrentModificationError
    for (final cartProduct in itemsToRemove) {
      removeFromCart(cartProduct); // Remove o produto do carrinho
    }
    notifyListeners(); // Notifica os listeners após atualização de itens
  }

  // Função para remover um produto do carrinho
  void removeFromCart(CartProduct cartProduct) {
    items.removeWhere(
        (p) => p.id == cartProduct.id); // Remove o produto da lista de itens
    user?.cartReference
        .doc(cartProduct.id)
        .delete(); // Remove o produto do Firestore
    cartProduct.removeListener(_onItemUpdate); // Remove o listener
    notifyListeners();
  }

  // Função para atualizar o produto no Firestore
  void _updateCartProduct(CartProduct cartProduct) {
    if (user != null) {
      user!.cartReference.doc(cartProduct.id).update(cartProduct
          .toCartItemMap()); // Atualiza o produto no carrinho do usuário
    }
  }

  // Função para verificar se o carrinho é válido
  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) {
        return false; // Se algum produto não tiver estoque, retorna falso
      }
    }
    return true; // Se todos os produtos tiverem estoque, retorna verdadeiro
  }

  // Função para verificar se todos os produtos têm estoque
  bool get hasStock {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) {
        return false; // Se algum produto não tiver estoque, retorna falso
      }
    }
    return true; // Se todos os produtos tiverem estoque, retorna verdadeiro
  }
}
