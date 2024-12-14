import 'package:flutter/material.dart'; // Importa o pacote Flutter para construção de interfaces
import 'package:online_store/models/item_size.dart'; // Importa o modelo ItemSize
import 'package:provider/provider.dart'; // Importa o pacote provider para gerenciamento de estado
import 'package:online_store/models/product.dart'; // Importa o modelo Product

// Classe SizerWidget que estende StatelessWidget para criar um widget de seleção de tamanho
class SizerWidget extends StatelessWidget {
  const SizerWidget({
    super.key,
    required this.size, // Construtor da classe SizerWidget
  });

  final ItemSize size; // Declaração do tamanho do item

  @override
  Widget build(BuildContext context) {
    // Obtém o produto atual do contexto usando provider
    final product = context.watch<Product>();
    // Verifica se o tamanho é o selecionado
    final selected = size == product.selectedSize;

    // Declaração da variável cor
    Color color;
    if (!size.hasStock) {
      // Define a cor vermelha com opacidade se não houver estoque
      color = Colors.red.withAlpha(70);
    } else if (selected) {
      // Define a cor primária do tema se o tamanho estiver selecionado
      color = Theme.of(context).primaryColor;
    } else {
      // Define a cor cinza se o tamanho não estiver selecionado e houver estoque
      color = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        if (size.hasStock) {
          // Atualiza o tamanho selecionado se houver estoque
          product.selectedSize = size;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color, // Define a cor da borda
          ),
          borderRadius: BorderRadius.circular(8), // Define o raio da borda
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ), // Define a margem
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Ajusta o tamanho da linha ao conteúdo
          children: [
            Container(
              color: color, // Define a cor de fundo do container
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ), // Define o padding
              child: Text(
                size.name.toString(), // Exibe o nome do tamanho
                style: const TextStyle(
                  color: Colors.white, // Define a cor do texto
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16), // Define o padding
              child: Text(
                'R\$ ${size.price.toStringAsFixed(2)}', // Exibe o preço do tamanho
                style: TextStyle(
                  color: color, // Define a cor do texto
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
