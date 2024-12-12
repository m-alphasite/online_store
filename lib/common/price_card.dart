import 'package:flutter/material.dart'; // Importa o Flutter para construir a interface do usuário
import 'package:online_store/common/custom_drawer/minhas_cores.dart';
import 'package:online_store/models/cart_manager.dart'; // Importa o gerenciador de carrinho
import 'package:provider/provider.dart'; // Importa o Flutter para construir a interface do usuário

class PriceCard extends StatelessWidget {
  // Classe PriceCard que estende StatelessWidget
  const PriceCard(
      {super.key, required this.buttonText, required this.onPressed});

  final String buttonText;
  final VoidCallback? onPressed; // Torna o onPressed opcional

  @override
  Widget build(BuildContext context) {
    // Método build que cria a interface do usuário

    final cartManager = context.watch<CartManager>(); // Observa o CartManager
    final productPrice = cartManager.productsPrice; // Preço dos produtos

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 8.0), // Define o espaçamento
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            16.0, 16.0, 16.0, 4.0), // Define o espaçamento
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Alinha os elementos da coluna
          children: <Widget>[
            Text(
              'Resumo do pedido', // Título do card
              textAlign: TextAlign.start, // Alinha o texto ao início
              style: TextStyle(
                fontSize: 16.0, // Tamanho da fonte
                fontWeight: FontWeight.w600, // Peso da fonte
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Alinha os elementos da linha
              children: <Widget>[
                Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(), // Espaço entre o texto e o valor
                Text(
                  'R\$ ${productPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Entrega',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  'R\$ 12,00',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(), // Divisor
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  'R\$ ${(productPrice + 12.00).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: MinhasCores.rosa_3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey,
                disabledForegroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              onPressed: onPressed, // Botão de clique
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on, // Ícone de endereço
                    color: Colors.white,
                    size: 20.0,
                  ),
                  const SizedBox(
                      width: 8.0), // Espaçamento entre o ícone e o texto
                  Text(buttonText,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
