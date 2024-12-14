import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/minhas_cores.dart'; // Importa o arquivo de cores personalizadas
import 'package:online_store/common/custom_icon_button.dart'; // Importa o CustomIconButton
import 'package:online_store/models/cart_product.dart'; // Importa o modelo de produto do carrinho
import 'package:provider/provider.dart'; // Importa o pacote provider

// Classe CartTile que estende StatelessWidget para criar um tile de produto no carrinho
class CartTile extends StatelessWidget {
  const CartTile(this.cartProduct, {super.key}); // Construtor da classe
  final CartProduct
      cartProduct; // Define o atributo cartProduct como um CartProduct

  @override
  Widget build(BuildContext context) {
    // Método build para construir a interface do usuário
    return ChangeNotifierProvider.value(
      value:
          cartProduct, // Define o cartProduct como o valor do ChangeNotifierProvider
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ), // Define o espaçamento do Card
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ), // Define o espaçamento interno do Card
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 80, // Define a altura do container da imagem
                width: 80, // Define a largura do container da imagem
                child: cartProduct.product.images.isNotEmpty
                    ? Image.network(cartProduct
                        .product.images.first) // Exibe a imagem do produto
                    : const Icon(Icons
                        .image_not_supported), // Ícone caso não haja imagem
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16), // Define o padding à esquerda
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinha o texto ao início
                    children: <Widget>[
                      Text(
                        cartProduct.product.name, // Exibe o nome do produto
                        style: const TextStyle(
                          fontSize: 19, // Define o tamanho da fonte
                          fontWeight: FontWeight.w500, // Define o peso da fonte
                          color: MinhasCores.rosa_1, // Define a cor da fonte
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8), // Espaço entre o nome e o tamanho
                        child: Text(
                          "Tamanho: ${cartProduct.size}", // Exibe o tamanho do produto
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.w300, // Define o peso da fonte
                          ),
                        ),
                      ),
                      Consumer<CartProduct>(
                        builder: (_, cartProduct, __) {
                          if (cartProduct.hasStock) {
                            return Text(
                              "R\$ ${cartProduct.unitPrice.toStringAsFixed(2)}", // Exibe o preço unitário
                              style: TextStyle(
                                color:
                                    MinhasCores.rosa_3, // Define a cor do texto
                                fontSize: 19, // Define o tamanho da fonte
                                fontWeight:
                                    FontWeight.bold, // Define o peso da fonte
                              ),
                            );
                          } else {
                            return const Text(
                              "Produto Indisponível", // Texto para produto indisponível
                              style: TextStyle(
                                color: Colors.red, // Cor do texto
                                fontSize: 19, // Define o tamanho da fonte
                                fontWeight:
                                    FontWeight.bold, // Define o peso da fonte
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<CartProduct>(
                builder: (_, cartProduct, __) {
                  return Column(
                    children: <Widget>[
                      CustomIconButton(
                        iconData: Icons.add, // Ícone de adicionar
                        color: Colors.green, // Define a cor do ícone
                        onTap: cartProduct.increment, // Função ao clicar
                      ),
                      Text(
                        "${cartProduct.quantity} ", // Exibe a quantidade
                        style: const TextStyle(
                          fontWeight: FontWeight.w500, // Define o peso da fonte
                          fontSize: 20, // Define o tamanho da fonte
                          color: Colors.black, // Define a cor do texto
                        ),
                      ),
                      CustomIconButton(
                        iconData: Icons.remove, // Ícone de remover
                        color: cartProduct.quantity > 1
                            ? Colors
                                .green // Define a cor do ícone se a quantidade for maior que 1
                            : Colors
                                .red, // Define a cor do ícone se a quantidade for 1 ou menor
                        onTap: cartProduct.decrement, // Função ao clicar
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
