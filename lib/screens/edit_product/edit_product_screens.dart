import 'package:flutter/material.dart';
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/product.dart';
import 'package:online_store/screens/edit_product/componets/images_form.dart';

class EditProductScreens extends StatelessWidget {
  const EditProductScreens({super.key, required this.product});

  final Product product; // Produto recebido para edição

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Editar Produto',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ), // Título da tela
        centerTitle: true,
        backgroundColor: MinhasCores.rosa_1, // Centraliza o título
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0), // Adiciona espaçamento nas bordas
        children: [
          // Componente para edição das imagens
          ImagesForm(
              product: product), // Passa o produto como parâmetro nomeado
        ],
      ),
    );
  }
}
