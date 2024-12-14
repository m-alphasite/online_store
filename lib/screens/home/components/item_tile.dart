import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/models/product_manager.dart'; // Importa o ProductManager
import 'package:online_store/models/section_item.dart'; // Importa o modelo SectionItem
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart'; // Importa o pacote provider para gerenciamento de estado

// Classe ItemTile que estende StatelessWidget para criar um tile de item
class ItemTile extends StatelessWidget {
  const ItemTile(
    this.item, {
    super.key,
  }); // Construtor da classe ItemTile

  final SectionItem item; // Declaração do item

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Verifica se o produto não é nulo e não está vazio
        if (item.product != null && item.product!.isNotEmpty) {
          final productManager = context.read<ProductManager>();
          final product = productManager.findProductById(item.product!);
          // Navega para a tela do produto se o produto for encontrado
          if (product != null) {
            Navigator.of(context).pushNamed('/produtos', arguments: product);
          }
        }
      },
      child: AspectRatio(
        aspectRatio: 1.0, // Mantém a proporção 1:1
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: item.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
